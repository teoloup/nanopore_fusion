class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: annovar_table_annovar_pl
baseCommand:
  - table_annovar.pl
inputs:
  - id: Convert_2_Annovar.avinput
    type: File
  - id: annovar_dbs
    type: Directory
    inputBinding:
      position: 1
      valueFrom: annovar_dbs
outputs:
  - id: annotated.vcf
    type: File
label: annovar_table_annovar.pl
arguments:
  - position: 0
    prefix: ''
    valueFrom: Convert_2_Annovar.avinput
  - position: 2
    prefix: '-buildver'
    valueFrom: hg38
  - position: 3
    prefix: ''
    valueFrom: '-remove'
  - position: 4
    prefix: '-protocol'
    valueFrom: >-
      refGene,gnomad211_exome,clinvar_latest,oncokb_43,avsnp150,cosmic_coding,intervar_latest,dbnsfp42c,dbscsnv11
  - position: 5
    prefix: '-operation'
    valueFrom: 'g,f,f,f,f,f,f,f,f'
  - position: 6
    prefix: '-arg'
    valueFrom: '''--splicing_threshold 6 --hgvs'',,,,,''-colsWanted all'',,,'
  - position: 7
    prefix: '-nastring'
    valueFrom: .
  - position: 8
    prefix: ''
    valueFrom: '-csvout'
  - position: 9
    prefix: ''
    valueFrom: '-polish'
  - position: 10
    prefix: ''
    valueFrom: '--otherinfo'
  - position: 0
    prefix: '-o'
    valueFrom: annotated.vcf
requirements:
  - class: DockerRequirement
    dockerPull: bioinfochrustrasbourg/annovar
