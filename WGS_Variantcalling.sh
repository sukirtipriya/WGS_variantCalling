#!/bin/bash

# Script to call germline variants in a human WGS paired end read 2 x 100bp
# this script is for demonstration purposes only

# Download data

wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/HG00096/sequence_read/SRR062634_1.filt.fastq.gz
wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/HG00096/sequence_read/SRR062634_2.filt.fastq.gz

echo "Run prep files"

########### prep_files ########################################################################

# download reference files

wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip hg38.fa.gz

# index ref - .fai file before running haplotype caller

samtools faidx hg38.fa

# ref dict - .dict file before running haplotype caller

gatk CreateSequenceDictionary hg38.dict

# download known sites files for BQSR from GATK resource bundle

wget -p https://storage.googleapis-public-data/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf

wget -p https://storage.googleapis-public-data/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx


############# Variant calling steps #############################################################

fi

# directories

ref="hg38.fa"
known_sites="Homo_sapiens_assembly38.dbsnp138.vcf"
aligned_reads="aligned_reads"
reads="reads"
results="results"
data="data"

#--------------- step-1: QC -- Run fastqc -------------------------

echo"QC -- Run fastqc"

fastqc ${reads}/SRR06264_1.filt.fastq.gz -o ${reads}/
fastqc ${reads}/SRR06264_2.filt.fastq.gz -o ${reads}/

# No trimming required, quality looks okay.

#---------------- step-2: Map to reference using BWA-NEM -----------

# BWA index reference 

bwa index ${ref}

# BWA alignment---------

bwa mem -t 4 -R "@RG\tID:SRR062634\tPL:ILLUMINA\tSM:SRR062634" $[ref} ${reads}/SRR062634_1.filt.fastq.gz $[reads]/SRR062634_2.filt.fastq.gz > ${aligned_reads}/SRR062634.paired.sam


#---------------- step-3: Mark Duplicates and Sort - GATK------------

gatk MarkDuplicatesSpark -I ${aligned_reads}/SRR062634.paired.sam -o ${aligned_reads}/SRR062634_sorted_dedup_reads.bam

#--------------- step-4: Base quality recalibration--------------------

# 1. build the model

gatk BaseRecalibrator -I ${aligned_reads}/SRR062634_sorted_dedup_reads.bam -R ${ref} --known-sites ${known-sites} -0 {data}/recal_data.table

# 2. Apply the model to adjust the base quality scores

gatk ApplyBQSR -I ${aligned_reads}/SRR062634_sorted_dedup_reads.bam -R ${ref} --bqsr-recal-file {data}/recal_data.table -0 ${aligned_reads}/SRR062634_sorted_dedup_bqsr_reads.bam


#-------------- step-5: collect Alignment & Insert size matrics -------------------

gatk CollectAlignmentSummaryMetrics R=${ref} I=${aligned_reads}/SRR062634_sorted_dedup_bqsr_reads.bam 0=${alignment_reads}/alignment_metrics.txt

gatk CollectInsertSizeMetrics INPUT=${aligned_reads}/SRR062634_sorted_dedup_bqsr_reads.bam OUTPUT=${aligned_reads}/insert_size_metrics.txt HISTOGRAM_FILE=${aligned_reads}/insert_size_histogram.pdf

$multiqc

#---------------step-6: Call Varients - gatk haplotype caller--------------

gatk HaplotypeCaller -R ${ref} -I ${aligned_reads}/SRR062634_sorted_dedup_bqsr_reads.bam -0 ${result}/raw_variantcs.vcf

# extract SNPs & INDELS

gatk SelectVariants -R ${ref} -V ${result}/raw_variants.vcf --select-type SNP -0 ${results}/raw_snps.vcf
gatk SelectVariants -R ${ref} -V ${result}/raw_variants.vcf --select-type INDEL -0 ${results}/raw_indels.vcf




