class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: samtools_sort
baseCommand:
  - samtools
  - sort
inputs:
  - id: aligned_bam
    type: File
    inputBinding:
      position: 0
outputs:
  - id: sorted
    type: File
    outputBinding:
      glob: '*_sorted.bam'
label: samtools_sort
arguments:
  - position: 1
    prefix: '-o'
    valueFrom: $(inputs.aligned_bam.nameroot)_sorted.bam
requirements:
  - class: DockerRequirement
    dockerPull: 'biocontainers/samtools:1.3.1'
  - class: InlineJavascriptRequirement