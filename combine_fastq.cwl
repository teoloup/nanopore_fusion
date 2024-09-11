class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: combine_fastq
baseCommand:
  - cat
inputs:
  - id: fastq_for
    type: File
    inputBinding:
      position: 0
      valueFrom: fastq_for
  - id: fastq_rev
    type: File
    inputBinding:
      position: 0
      valueFrom: fastq_rev
outputs:
  - id: combined_fastq
    type: File
label: combine_fastq
stdout: combined_fastq.gz
