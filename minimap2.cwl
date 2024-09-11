class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: minimap2
baseCommand:
  - minimap2
inputs:
  - id: reference_file
    type: File
    inputBinding:
      position: 0
      prefix: ''
      valueFrom: reference_file
  - id: fastq
    type: File
    inputBinding:
      position: 0
      valueFrom: fastq
outputs:
  - id: aligned.bam
    type: File
    outputBinding:
      glob: aligned.bam
label: minimap2
arguments:
  - position: 0
    prefix: '-ax'
    valueFrom: map-ont
  - position: 0
    prefix: ''
    valueFrom: '-Y'
  - position: 0
    prefix: ''
    valueFrom: '-L'
  - position: 0
    prefix: ''
    valueFrom: '--MD'
  - position: 0
    prefix: ''
    valueFrom: '--eqx'
  - position: 0
    prefix: '-@'
    valueFrom: '16'
  - position: 0
    prefix: ''
    valueFrom: '-Sb'
requirements:
  - class: ResourceRequirement
    ramMin: 60
    coresMin: 0
  - class: DockerRequirement
    dockerPull: ttubb/minimap2
