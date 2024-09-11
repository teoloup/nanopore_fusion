class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: cutadapt_rev
baseCommand:
  - cutadapt
inputs:
  - id: umi_extracted.fastq.gz
    type: File
    inputBinding:
      position: 0
      valueFrom: umi_extracted.fastq.gz
outputs:
  - id: rev_trimmed.fastq.gz
    type: File
    outputBinding:
      glob: '*.fastq.gz'
label: cutadapt_rev
arguments:
  - position: 0
    prefix: '-e'
    valueFrom: '0.2'
  - position: 0
    prefix: '-m'
    valueFrom: '1200'
  - position: 0
    prefix: ''
    valueFrom: '--discard-untrimmed'
  - position: 0
    prefix: '-g'
    valueFrom: AGATGCTGACCAACTCGTGTG...CTGAGATGCCTCACTCCAA
  - position: 0
    prefix: '-j'
    valueFrom: '16'
requirements:
  - class: ResourceRequirement
    ramMin: 32
    coresMin: 0
  - class: DockerRequirement
    dockerPull: genomicpariscentre/cutadapt
