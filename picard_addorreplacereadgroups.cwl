class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: picard_addorreplacereadgroups
baseCommand:
  - gatk
  - AddOrReplaceReadGroups
inputs:
  - id: sorted_dedup_bam
    type: File
    inputBinding:
      position: 1
      prefix: '-I'
  - id: Library
    type: string
    inputBinding:
      position: 4
      prefix: '-LB'
  - id: Platform
    type: string
    inputBinding:
      position: 6
      prefix: '-PL'
  - id: Barcode
    type: string
    inputBinding:
      position: 8
      prefix: '-PU'
  - id: Sample
    type: string
    inputBinding:
      position: 10
      prefix: '-SM'
outputs:
  - id: dedup_RG_bam
    type: File
    outputBinding:
      glob: '*RG.bam'
label: picard_AddOrReplaceReadGroups
arguments:
  - position: 2
    prefix: '-O'
    valueFrom: $(inputs.sorted_dedup_bam.nameroot).RG.bam
requirements:
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk:4.1.2.0'
  - class: InlineJavascriptRequirement