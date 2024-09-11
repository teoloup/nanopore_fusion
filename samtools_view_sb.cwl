class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: samtools_view_Sb
baseCommand:
  - samtools
  - view
inputs:
  - id: aligned_sam
    type: File
    inputBinding:
      position: 0
outputs:
  - id: aligned_bam
    type: File
    outputBinding:
      glob: '*.bam'
label: samtools_view_Sb
arguments:
  - position: 0
    prefix: ''
    valueFrom: '-Sb'
requirements:
  - class: DockerRequirement
    dockerPull: 'biocontainers/samtools:1.3.1'
  - class: InlineJavascriptRequirement
stdout: $(inputs.aligned_sam.nameroot).bam