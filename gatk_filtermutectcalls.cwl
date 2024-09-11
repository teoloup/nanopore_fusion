class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: gatk_filtermutectcalls
baseCommand:
  - gatk
  - FilterMutectCalls
inputs:
  - id: ref_file
    type: File
    inputBinding:
      position: 0
      prefix: '-R'
  - id: vcf_file
    type: File
    inputBinding:
      position: 0
      prefix: '-V'
outputs:
  - id: filtered_vcf
    type: File
    outputBinding:
      glob: $(inputs.vcf_file.nameroot)_filtered.vcf
label: gatk_FilterMutectCalls
arguments:
  - position: 0
    prefix: '-O'
    valueFrom: $(inputs.vcf_file.nameroot)_filtered.vcf
requirements:
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk:4.1.2.0'
  - class: InlineJavascriptRequirement