class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: samtools_view
baseCommand:
  - samtools view
inputs:
  - id: aligned.bam
    type: File
    inputBinding:
      position: 0
      valueFrom: aligned.bam
outputs:
  - id: map60.bam
    type: File
label: samtools_view
arguments:
  - position: 0
    prefix: '-@'
    valueFrom: '16'
  - position: 0
    prefix: ''
    valueFrom: '-b'
  - position: 0
    prefix: '-F'
    valueFrom: '516'
  - position: 0
    prefix: '-q'
    valueFrom: '30'
requirements:
  - class: DockerRequirement
    dockerPull: zavolab/samtools
stdout: map60.bam
