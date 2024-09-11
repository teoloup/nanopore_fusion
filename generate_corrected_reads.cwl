class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: generate_corrected_reads
baseCommand:
  - bcr_abl_consensus_0.2.py
inputs:
  - id: GroupReadsByUmi_adjecency.bam
    type: File
    inputBinding:
      position: 0
      valueFrom: GroupReadsByUmi_adjecency.bam
outputs:
  - id: umi_consensus.fastq
    type: File
label: Generate_corrected_reads
arguments:
  - position: 0
    prefix: '-m'
    valueFrom: '2'
  - position: 1
    prefix: ''
    valueFrom: '--clean'
  - position: 0
    prefix: ''
    valueFrom: '-i'
  - position: 3
    prefix: '-o'
    valueFrom: umi_consensus.fastq
