class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: samtools_index_bam
baseCommand:
  - samtools
  - index
  - '-b'
inputs:
  - id: bam_file
    type: File
    inputBinding:
      position: 0
outputs: []
label: samtools_index_bam
requirements:
  - class: DockerRequirement
    dockerPull: 'biocontainers/samtools:1.3.1'
  - class: InlineJavascriptRequirement
stdout: $(inputs.bam_file.basename).bai