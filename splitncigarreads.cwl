class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: splitncigarreads
baseCommand:
  - gatk
  - SplitNCigarReads
inputs:
  - id: ref_file
    type: File
  - id: RG.bam
    type: File
outputs:
  - id: SplitCigar.bam
    type: File
label: SplitNCigarReads
arguments:
  - position: 0
    prefix: '-R'
    valueFrom: ref_file
  - position: 0
    prefix: '-I'
    valueFrom: RG.bam
  - position: 0
    prefix: '-O'
    valueFrom: SplitCigar.bam
requirements:
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk:4.0.9.0'
