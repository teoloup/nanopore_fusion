class: Workflow
cwlVersion: v1.0
id: nanopore_bcr_abl_umi_analysis
label: Nanopore_BCR_ABL_umi_analysis
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: raw.fastq.gz
    type: File
    'sbg:x': 387.58984375
    'sbg:y': 145.13851928710938
  - id: BCR_ABL_reference
    type: File
    secondaryFiles:
      - '*.fa'
    'sbg:x': 1287.9437255859375
    'sbg:y': 357.7132568359375
  - id: hg38
    type: File
    secondaryFiles:
      - '*.fasta'
    'sbg:x': 2414.123291015625
    'sbg:y': -166.8821563720703
  - id: bed_file
    type: File
    'sbg:x': 3460.578369140625
    'sbg:y': 519.3949584960938
  - id: annovar_dbs
    type: Directory
    'sbg:x': 3958.647216796875
    'sbg:y': 376.3619689941406
outputs:
  - id: groupreads.tsv
    outputSource:
      - fgbio_groupreadsbyumi/groupreads.tsv
    type: File
    'sbg:x': 2245.133056640625
    'sbg:y': -68.70415496826172
steps:
  - id: umi_tools_extract_for
    in:
      - id: raw.fastq.gz
        source: raw.fastq.gz
    out:
      - id: umiextracted.fastq.gz
    run: ./umi_tools_extract_for.cwl
    label: umi_tools_extract_for
    'sbg:x': 600.9937744140625
    'sbg:y': 56.05329895019531
  - id: umi_tools_extract_rev
    in:
      - id: raw.fastq.gz
        source: raw.fastq.gz
    out:
      - id: umiextracted.fastq.gz
    run: ./umi_tools_extract_rev.cwl
    label: umi_tools_extract_rev
    'sbg:x': 636.6342163085938
    'sbg:y': 216.40350341796875
  - id: cutadapt_for
    in:
      - id: umi_extracted.fastq.gz
        source: umi_tools_extract_rev/umiextracted.fastq.gz
    out:
      - id: rev_trimmed.fastq.gz
    run: ./cutadapt_for.cwl
    label: cutadapt_rev
    'sbg:x': 819.7537841796875
    'sbg:y': 252.07574462890625
  - id: cutadapt_for_1
    in:
      - id: umi_extracted.fastq.gz
        source: umi_tools_extract_for/umiextracted.fastq.gz
    out:
      - id: rev_trimmed.fastq.gz
    run: ./cutadapt_for.cwl
    label: cutadapt_rev
    'sbg:x': 837.5740356445312
    'sbg:y': -10.804327011108398
  - id: header_rename
    in:
      - id: trimmed.fastq.gz
        source: cutadapt_for_1/rev_trimmed.fastq.gz
    out:
      - id: output
    run: ./header_rename.cwl
    label: header_rename
    'sbg:x': 1100.7364501953125
    'sbg:y': 225.3454132080078
  - id: header_rename_1
    in:
      - id: trimmed.fastq.gz
        source: cutadapt_for/rev_trimmed.fastq.gz
    out:
      - id: output
    run: ./header_rename.cwl
    label: header_rename
    'sbg:x': 1145.2869873046875
    'sbg:y': 51.56645202636719
  - id: combine_fastq
    in:
      - id: fastq_for
        source: header_rename/output
      - id: fastq_rev
        source: header_rename_1/output
    out:
      - id: combined_fastq
    run: ./combine_fastq.cwl
    label: combine_fastq
    'sbg:x': 1346.7462158203125
    'sbg:y': 146.17242431640625
  - id: minimap2
    in:
      - id: reference_file
        source: BCR_ABL_reference
      - id: fastq
        source: combine_fastq/combined_fastq
    out:
      - id: aligned.bam
    run: ./minimap2.cwl
    label: minimap2
    'sbg:x': 1542.41064453125
    'sbg:y': 210.2346954345703
  - id: samtools_view__sb
    in:
      - id: aligned_sam
        source: minimap2/aligned.bam
    out:
      - id: aligned_bam
    run: ./samtools_view_sb.cwl
    label: samtools_view_Sb
    'sbg:x': 1705.1358642578125
    'sbg:y': 190.369384765625
  - id: samtools_sort
    in:
      - id: aligned_bam
        source: samtools_view__sb/aligned_bam
    out:
      - id: sorted
    run: ./samtools_sort.cwl
    label: samtools_sort
    'sbg:x': 1880.8389892578125
    'sbg:y': 162.958740234375
  - id: samtools_index_bam
    in:
      - id: bam_file
        source: samtools_sort/sorted
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
    'sbg:x': 1905.546875
    'sbg:y': -28.624549865722656
  - id: fgbio_copyumifromreadname_1
    in:
      - id: trimmed.fastq.gz
        source: samtools_sort/sorted
    out:
      - id: output
    run: ./fgbio_copyumifromreadname.cwl
    label: fgbio_CopyUmiFromReadName
    'sbg:x': 2088.2041015625
    'sbg:y': 118.42407989501953
  - id: fgbio_groupreadsbyumi
    in:
      - id: sorted_RX.bam
        source: fgbio_copyumifromreadname_1/output
    out:
      - id: GroupReadsByUmi_adjecency.bam
      - id: groupreads.tsv
    run: ./fgbio_groupreadsbyumi.cwl
    label: fgbio_GroupReadsByUmi
    'sbg:x': 2261.680908203125
    'sbg:y': 392.0766906738281
  - id: generate_corrected_reads
    in:
      - id: GroupReadsByUmi_adjecency.bam
        source: fgbio_groupreadsbyumi/GroupReadsByUmi_adjecency.bam
    out:
      - id: umi_consensus.fastq
    run: ./generate_corrected_reads.cwl
    label: Generate_corrected_reads
    'sbg:x': 2405.51513671875
    'sbg:y': 229.8163604736328
  - id: minimap3
    in:
      - id: reference_file
        source: BCR_ABL_reference
      - id: fastq
        source: generate_corrected_reads/umi_consensus.fastq
    out:
      - id: aligned.bam
    run: ./minimap2.cwl
    label: minimap2
    'sbg:x': 2701.458984375
    'sbg:y': 189.70497131347656
  - id: minimap4
    in:
      - id: reference_file
        source: hg38
      - id: fastq
        source: generate_corrected_reads/umi_consensus.fastq
    out:
      - id: aligned.bam
    run: ./minimap2.cwl
    label: minimap2
    'sbg:x': 2594.53759765625
    'sbg:y': 10.8361177444458
  - id: samtools_sort_1
    in:
      - id: aligned_bam
        source: samtools_view__sb_1/aligned_bam
    out:
      - id: sorted
    run: ./samtools_sort.cwl
    label: samtools_sort
    'sbg:x': 2883.18994140625
    'sbg:y': 385.7274169921875
  - id: samtools_index_bam_1
    in:
      - id: bam_file
        source: samtools_sort_1/sorted
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
    'sbg:x': 3144.015869140625
    'sbg:y': 497.0879211425781
  - id: samtools_sort_2
    in:
      - id: aligned_bam
        source: samtools_view__sb_2/aligned_bam
    out:
      - id: sorted
    run: ./samtools_sort.cwl
    label: samtools_sort
    'sbg:x': 2941.105712890625
    'sbg:y': -24.169492721557617
  - id: samtools_view__sb_1
    in:
      - id: aligned_sam
        source: minimap3/aligned.bam
    out:
      - id: aligned_bam
    run: ./samtools_view_sb.cwl
    label: samtools_view_Sb
    'sbg:x': 2646.701904296875
    'sbg:y': 394.6375427246094
  - id: samtools_view__sb_2
    in:
      - id: aligned_sam
        source: minimap4/aligned.bam
    out:
      - id: aligned_bam
    run: ./samtools_view_sb.cwl
    label: samtools_view_Sb
    'sbg:x': 2784.80859375
    'sbg:y': -68.72004699707031
  - id: samtools_index_bam_2
    in:
      - id: bam_file
        source: samtools_sort_2/sorted
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
    'sbg:x': 3188.56640625
    'sbg:y': 15.910111427307129
  - id: picard_addorreplacereadgroups
    in:
      - id: sorted_dedup_bam
        source: samtools_sort_2/sorted
    out:
      - id: dedup_RG_bam
    run: ./picard_addorreplacereadgroups.cwl
    label: picard_AddOrReplaceReadGroups
    'sbg:x': 3077.190185546875
    'sbg:y': 203.08602905273438
  - id: samtools_index_bam_3
    in:
      - id: bam_file
        source: picard_addorreplacereadgroups/dedup_RG_bam
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
    'sbg:x': 3349.201904296875
    'sbg:y': 149.59356689453125
  - id: splitncigarreads
    in:
      - id: ref_file
        source: hg38
      - id: RG.bam
        source: picard_addorreplacereadgroups/dedup_RG_bam
    out:
      - id: SplitCigar.bam
    run: ./splitncigarreads.cwl
    label: SplitNCigarReads
    'sbg:x': 3335.836669921875
    'sbg:y': 343.0392761230469
  - id: samtools_index_bam_4
    in:
      - id: bam_file
        source: splitncigarreads/SplitCigar.bam
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
    'sbg:x': 3577.93359375
    'sbg:y': 99.9372329711914
  - id: gatk_mutect2_tumoronly
    in:
      - id: ref_fasta
        source: hg38
      - id: bam
        source: splitncigarreads/SplitCigar.bam
      - id: bed_file
        source: bed_file
    out:
      - id: vcf
    run: ./gatk_mutect2_tumoronly.cwl
    label: gatk_Mutect2_tumorOnly
    'sbg:x': 3733.860595703125
    'sbg:y': 309.991455078125
  - id: gatk_filtermutectcalls
    in:
      - id: ref_file
        source: hg38
      - id: vcf_file
        source: gatk_mutect2_tumoronly/vcf
    out:
      - id: filtered_vcf
    run: ./gatk_filtermutectcalls.cwl
    label: gatk_FilterMutectCalls
    'sbg:x': 3909.06201171875
    'sbg:y': 40.12729263305664
  - id: annovar_convert2annovar
    in:
      - id: filtered.vcf.gz
        source: gatk_filtermutectcalls/filtered_vcf
    out:
      - id: Convert_2_Annovar.avinput
    run: ./annovar_convert2annovar.cwl
    label: Annovar_convert2annovar
    'sbg:x': 3979.985595703125
    'sbg:y': 167.4296875
  - id: annovar_table_annovar_pl
    in:
      - id: Convert_2_Annovar.avinput
        source: annovar_convert2annovar/Convert_2_Annovar.avinput
      - id: annovar_dbs
        source: annovar_dbs
    out:
      - id: annotated.vcf
    run: ./annovar_table_annovar-pl.cwl
    label: annovar_table_annovar.pl
    'sbg:x': 4156.8154296875
    'sbg:y': 299.0340576171875
requirements: []
