class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: annovar_convert2annovar
baseCommand:
  - convert2annovar.pl
inputs:
  - id: filtered.vcf.gz
    type: File
outputs:
  - id: Convert_2_Annovar.avinput
    type: File
label: Annovar_convert2annovar
arguments:
  - position: 0
    prefix: '-format'
    valueFrom: vcf4
  - position: 0
    prefix: ''
    valueFrom: filtered.vcf.gz
  - position: 0
    prefix: '-outfile'
    valueFrom: Convert_2_Annovar.avinput
  - position: 0
    prefix: ''
    valueFrom: '--includeinfo'
  - position: 0
    prefix: ''
    valueFrom: '--withzyg'
requirements:
  - class: DockerRequirement
    dockerPull: bioinfochrustrasbourg/annovar
