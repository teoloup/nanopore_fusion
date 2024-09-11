class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: fgbio_copyumifromreadname
baseCommand:
  - fgbio CopyUmiFromReadName
inputs:
  - id: trimmed.fastq.gz
    type: File
    inputBinding:
      position: 0
      valueFrom: trimmed.fastq.gz
outputs:
  - id: output
    type: File
label: fgbio_CopyUmiFromReadName
arguments:
  - position: 0
    prefix: ''
    valueFrom: '-i'
  - position: 1
    prefix: '-o'
    valueFrom: sorted_RX.bam
requirements:
  - class: DockerRequirement
    dockerPull: dceoy/fgbio
