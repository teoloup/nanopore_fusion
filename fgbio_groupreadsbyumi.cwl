class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: fgbio_groupreadsbyumi
baseCommand:
  - fgbio GroupReadsByUmi
inputs:
  - id: sorted_RX.bam
    type: File
    inputBinding:
      position: 0
      valueFrom: sorted_RX.bam
outputs:
  - id: GroupReadsByUmi_adjecency.bam
    type: File
  - id: groupreads.tsv
    type: File
label: fgbio_GroupReadsByUmi
arguments:
  - position: 0
    prefix: ''
    valueFrom: '-i'
  - position: 1
    prefix: '-f'
    valueFrom: groupreads.tsv
  - position: 2
    prefix: '-o'
    valueFrom: GroupReadsByUmi_adjecency.bam
  - position: 3
    prefix: '-s'
    valueFrom: adjacency
  - position: 4
    prefix: '-e'
    valueFrom: '6'
  - position: 5
    prefix: '-@'
    valueFrom: '16'
requirements:
  - class: DockerRequirement
    dockerPull: dceoy/fgbio
