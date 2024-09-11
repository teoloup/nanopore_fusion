class: Workflow
cwlVersion: v1.0
id: nanopore_bcr_abl_umi_analysis
label: Nanopore_BCR_ABL_umi_analysis

inputs:
  - id: raw.fastq.gz
    type: File
  - id: BCR_ABL_reference
    type: File
    secondaryFiles:
      - '*.fa'
  - id: hg38
    type: File
    secondaryFiles:
      - '*.fasta'
  - id: bed_file
    type: File
  - id: annovar_dbs
    type: Directory
  - id: Barcode
    type: string
  - id: Library
    type: string
  - id: Platform
    type: string
  - id: Sample
    type: string
  - id: vcf_name
    type: string
outputs:
  - id: groupreads.tsv
    outputSource:
      - fgbio_groupreadsbyumi/groupreads.tsv
    type: File
steps:
  - id: umi_tools_extract_for
    in:
      - id: raw.fastq.gz
        source: raw.fastq.gz
    out:
      - id: umiextracted.fastq.gz
    run: ./umi_tools_extract_for.cwl
    label: umi_tools_extract_for
  - id: umi_tools_extract_rev
    in:
      - id: raw.fastq.gz
        source: raw.fastq.gz
    out:
      - id: umiextracted.fastq.gz
    run: ./umi_tools_extract_rev.cwl
    label: umi_tools_extract_rev
  - id: cutadapt_for
    in:
      - id: umi_extracted.fastq.gz
        source: umi_tools_extract_rev/umiextracted.fastq.gz
    out:
      - id: rev_trimmed.fastq.gz
    run: ./cutadapt_for.cwl
    label: cutadapt_rev
  - id: cutadapt_for_1
    in:
      - id: umi_extracted.fastq.gz
        source: umi_tools_extract_for/umiextracted.fastq.gz
    out:
      - id: rev_trimmed.fastq.gz
    run: ./cutadapt_for.cwl
    label: cutadapt_rev
  - id: header_rename
    in:
      - id: trimmed.fastq.gz
        source: cutadapt_for_1/rev_trimmed.fastq.gz
    out:
      - id: output
    run: ./header_rename.cwl
    label: header_rename
  - id: header_rename_1
    in:
      - id: trimmed.fastq.gz
        source: cutadapt_for/rev_trimmed.fastq.gz
    out:
      - id: output
    run: ./header_rename.cwl
    label: header_rename
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
  - id: samtools_view__sb
    in:
      - id: aligned_sam
        source: minimap2/aligned.bam
    out:
      - id: aligned_bam
    run: ./samtools_view_sb.cwl
    label: samtools_view_Sb
  - id: samtools_sort
    in:
      - id: aligned_bam
        source: samtools_view__sb/aligned_bam
    out:
      - id: sorted
    run: ./samtools_sort.cwl
    label: samtools_sort
  - id: samtools_index_bam
    in:
      - id: bam_file
        source: samtools_sort/sorted
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
  - id: fgbio_copyumifromreadname_1
    in:
      - id: trimmed.fastq.gz
        source: samtools_sort/sorted
    out:
      - id: output
    run: ./fgbio_copyumifromreadname.cwl
    label: fgbio_CopyUmiFromReadName
  - id: fgbio_groupreadsbyumi
    in:
      - id: sorted_RX.bam
        source: fgbio_copyumifromreadname_1/output
    out:
      - id: GroupReadsByUmi_adjecency.bam
      - id: groupreads.tsv
    run: ./fgbio_groupreadsbyumi.cwl
    label: fgbio_GroupReadsByUmi
  - id: generate_corrected_reads
    in:
      - id: GroupReadsByUmi_adjecency.bam
        source: fgbio_groupreadsbyumi/GroupReadsByUmi_adjecency.bam
    out:
      - id: umi_consensus.fastq
    run: ./generate_corrected_reads.cwl
    label: Generate_corrected_reads
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
  - id: samtools_sort_1
    in:
      - id: aligned_bam
        source: samtools_view__sb_1/aligned_bam
    out:
      - id: sorted
    run: ./samtools_sort.cwl
    label: samtools_sort
  - id: samtools_index_bam_1
    in:
      - id: bam_file
        source: samtools_sort_1/sorted
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
  - id: samtools_sort_2
    in:
      - id: aligned_bam
        source: samtools_view__sb_2/aligned_bam
    out:
      - id: sorted
    run: ./samtools_sort.cwl
    label: samtools_sort
  - id: samtools_view__sb_1
    in:
      - id: aligned_sam
        source: minimap3/aligned.bam
    out:
      - id: aligned_bam
    run: ./samtools_view_sb.cwl
    label: samtools_view_Sb
  - id: samtools_view__sb_2
    in:
      - id: aligned_sam
        source: minimap4/aligned.bam
    out:
      - id: aligned_bam
    run: ./samtools_view_sb.cwl
    label: samtools_view_Sb
  - id: samtools_index_bam_2
    in:
      - id: bam_file
        source: samtools_sort_2/sorted
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
  - id: picard_addorreplacereadgroups
    in:
      - id: sorted_dedup_bam
        source: samtools_sort_2/sorted
      - id: Library
        source: Library
      - id: Platform
        source: Platform
      - id: Barcode
        source: Barcode
      - id: Sample
        source: Sample
    out:
      - id: dedup_RG_bam
    run: ./picard_addorreplacereadgroups.cwl
    label: picard_AddOrReplaceReadGroups
  - id: samtools_index_bam_3
    in:
      - id: bam_file
        source: picard_addorreplacereadgroups/dedup_RG_bam
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
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
  - id: samtools_index_bam_4
    in:
      - id: bam_file
        source: splitncigarreads/SplitCigar.bam
    out: []
    run: ./samtools_index_bam.cwl
    label: samtools_index_bam
  - id: haplotypecaller_gatk
    in:
      - id: ref_file
        source: hg38
      - id: SplitCigar.bam
        source: splitncigarreads/SplitCigar.bam
      - id: bed_file
        source: bed_file
    out:
      - id: output_vcf
    run: ./haplotypecaller_gatk.cwl
    label: haplotypecaller_GATK
  - id: annovar
    in:
      - id: avinput
        source: haplotypecaller_gatk/output_vcf
      - id: annovar_dbs
        source: annovar_dbs
    out:
      - id: annovar_output
    run: ./annovar.cwl
    label: annovar
  - id: annovar_csq_cadd
    in:
      - id: annovar
        source: annovar/annovar_output
      - id: vcf_name
        source: vcf_name
    out:
      - id: filtered_vcf
    run: ./annovar_csq_cadd.cwl
    label: annovar_csq_cadd
