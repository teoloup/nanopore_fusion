class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: header_rename
baseCommand:
  - zcat
inputs:
  - id: trimmed.fastq.gz
    type: File
    inputBinding:
      position: 0
      valueFrom: trimmed.fastq.gz
outputs:
  - id: output
    type: File
label: header_rename
arguments:
  - position: 1
    prefix: '| awk'
    valueFrom: '''/^@/ {print $1; getline; print; getline; print; getline; print}'' |'
  - position: 2
    prefix: ''
    valueFrom: gzip
stdout: headerRename.fastq.gz
