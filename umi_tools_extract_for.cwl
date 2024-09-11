class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: umi_tools_extract_for
baseCommand:
  - umi_tools
  - extract
inputs:
  - id: raw.fastq.gz
    type: File
    inputBinding:
      position: 0
      prefix: ''
      valueFrom: nanopore_pass_reads.fastq.gz
outputs:
  - id: umiextracted.fastq.gz
    type: File
    outputBinding:
      glob: '*.fastq.gz'
label: umi_tools_extract_for
arguments:
  - position: 0
    prefix: '--extract-method='
    separate: false
    valueFrom: regex
  - position: 0
    prefix: '--bc-pattern='
    separate: false
    valueFrom: >-
      ".*(?P<discard_1>TGAGATGCCTCACTCCAAG){s<=2}(?P<umi_2>.{18})(?P<discard_1>ATCTCGTATGCCGTCTTCTGCTTG){s<=2}.*"
requirements:
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 0
  - class: DockerRequirement
    dockerPull: parisepigenetics/umitools
