class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: gatk_mutect2_tumoronly
baseCommand:
  - gatk
  - Mutect2
inputs:
  - id: ref_fasta
    type: File
    inputBinding:
      position: 1
      prefix: '-R'
  - id: bam
    type: File
    inputBinding:
      position: 3
      prefix: '-I'
  - id: vcf_name
    type: string
    inputBinding:
      position: 5
      prefix: '-O'
  - id: bed_file
    type: File
    inputBinding:
      position: 8
      prefix: '-L'
  - id: sample_name
    type: string
    inputBinding:
      position: 0
      prefix: '-tumor'
outputs:
  - id: vcf
    type: File
    outputBinding:
      glob: $(inputs.vcf_name)
label: gatk_Mutect2_tumorOnly
arguments:
  - position: 0
    prefix: '--af-of-alleles-not-in-resource'
    valueFrom: '0.00003125'
requirements:
  - class: ResourceRequirement
    ramMin: 4000
    coresMin: 0
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk:4.0.9.0'
  - class: InlineJavascriptRequirement