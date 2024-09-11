import subprocess
import os
import argparse
from collections import defaultdict
import shutil

# Function to execute shell commands
def run_command(command):
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        raise Exception(f"Command failed: {command}\n{result.stderr.decode('utf-8')}")
    return result.stdout.decode('utf-8')

# Read arguments from command line
parser = argparse.ArgumentParser(
    description='Generate consensus reads for BCR-ABL, provide the grouped by UMI BAM and the output file',
    epilog='Developed by Theodoros Loupis and ChatGPT, tloupis@bioacademy.gr'
)
parser.add_argument('-i', '--bam', type=str, help='The input BAM file', required=True)
parser.add_argument('-o', '--out', type=str, help='The output FASTQ file', required=True)
parser.add_argument('-m', '--min_reads', type=int, help='Specify the minimum reads for each group to use', required=True)
parser.add_argument('--clean', action='store_true', help='Delete the temporary split files directory after processing')

args = parser.parse_args()

input_bam_file = args.bam
output_fastq = args.out
min_reads = args.min_reads
clean_up = args.clean


working_directory = os.path.dirname(input_bam_file)
# Directory for split BAM files
split_dir = os.path.join(working_directory,'split_bams')
os.makedirs(split_dir, exist_ok=True)

# Extract BAM header
bam_header = run_command(f"/software/usr/tloupis/conda4/envs/samtools/bin/samtools view -H {input_bam_file}")

# Statistics
discarded_groups = 0
total_groups = 0
kept_groups = 0
total_kept_reads = 0
read_group_sizes = defaultdict(int)

# Process each RX:Z tag manually
split_files = []
current_tag = None
current_reads = []

with subprocess.Popen(f"/software/usr/tloupis/conda4/envs/samtools/bin/samtools view {input_bam_file}", shell=True, stdout=subprocess.PIPE) as proc:
    for line in proc.stdout:
        fields = line.decode('utf-8').strip().split('\t')
        tags = {tag.split(':', 1)[0]: tag.split(':', 1)[1] for tag in fields[11:]}
        rx_tag = tags.get('RX')
        
        if rx_tag != current_tag:
            if current_tag is not None:
                read_count = len(current_reads)
                read_group_sizes[read_count] += 1
                if read_count >= min_reads:
                    current_bam = os.path.join(split_dir, f"{current_tag.replace('Z:', '')}{kept_groups}.bam")
                    with open(current_bam, 'w') as current_file:
                        current_file.write(bam_header)
                        for read in current_reads:
                            current_file.write(read)
                    # Sort the BAM file
                    sorted_bam = current_bam.replace('.bam', '.sorted.bam')
                    run_command(f"/software/usr/tloupis/conda4/envs/samtools/bin/samtools sort -o {sorted_bam} {current_bam}")
                    os.remove(current_bam)
                    split_files.append(sorted_bam)
                    kept_groups += 1
                    total_kept_reads += read_count
                else:
                    discarded_groups += 1
            current_tag = rx_tag
            current_reads = []
            total_groups += 1
        
        current_reads.append(line.decode('utf-8'))
    
    if current_tag is not None:
        read_count = len(current_reads)
        read_group_sizes[read_count] += 1
        if read_count >= min_reads:
            current_bam = os.path.join(split_dir, f"{current_tag.replace('Z:', '')}{kept_groups}.bam")
            with open(current_bam, 'w') as current_file:
                current_file.write(bam_header)
                for read in current_reads:
                    current_file.write(read)
            # Sort the BAM file
            sorted_bam = current_bam.replace('.bam', '.sorted.bam')
            run_command(f"/software/usr/tloupis/conda4/envs/samtools/bin/samtools sort -o {sorted_bam} {current_bam}")
            os.remove(current_bam)
            split_files.append(sorted_bam)
            kept_groups += 1
            total_kept_reads += read_count
        else:
            discarded_groups += 1

# Process each split BAM file
consensus_fastq_files = []
for split_file in split_files:
    bam_path = split_file
    
    # Generate mpileup and consensus
    consensus_fastq = f"{bam_path}.fastq"
    run_command(f"/software/usr/tloupis/conda4/envs/samtools/bin/samtools consensus -X r10.4_sup -f fastq -o {consensus_fastq} -l 3000 {bam_path}")
    consensus_fastq_files.append(consensus_fastq)

# Merge all consensus FASTQ files into one
final_read_count = 0
with open(output_fastq, 'w') as outfile:
    for fastq_file in consensus_fastq_files:
        with open(fastq_file, 'r') as infile:
            for line in infile:
                if line.startswith('@'):
                    final_read_count += 1
                outfile.write(line)

# Print statistics
print(f"Total groups processed: {total_groups}")
print(f"Groups discarded for having fewer than {min_reads} reads: {discarded_groups}")
print(f"Groups kept: {kept_groups}")
print(f"Total reads in kept groups: {total_kept_reads}")
print(f"Final merged file contains {final_read_count} reads: {output_fastq}")

# Detailed read group sizes
print("\nDetailed read group sizes:")
for size, count in sorted(read_group_sizes.items()):
    print(f"Groups with {size} reads: {count}")

# Optionally clean up the split directory
if clean_up:
    shutil.rmtree(split_dir)
    print(f"Temporary split files directory '{split_dir}' has been deleted.")
