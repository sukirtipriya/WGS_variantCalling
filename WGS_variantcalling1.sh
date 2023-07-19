#!/bin/bash

# Script to filter and annotate variants


# directories

ref ="desktop/demo/hg38.fa"
result="desktop/demo/results"

# Filter Variants - GATK4

# Filter SNPs

gatk VariantFilteration \
   -R ${ref} \
   -V ${results}/raw_snps.vcf \
   -0 ${results}/filtered_snps.vcf \
   -filter-name "QD_filter" -filter "QD < 2.0" \
   -filter-name "FS_filter" -filter "FS > 60.0" \
   -filter-name "MQ_filter" -filter "MQ < 40.0" \
   -filter-name "S0R_filter" -filter "S0R > 4.0" \
   -filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
   -filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0" \
   -genotype-filter-expression "DP < 10" \
   -genotype-filter-name "DP_filter" \
   -genotype-filter-expression "GQ < 10" \
   -genotype-filter-name "GQ_filter" \
   
# Filter INDELS

 gatk VariantFilteration \
   -R ${ref} \
   -V ${results}/raw_indels.vcf \
   -0 ${results}/filtered_indels.vcf \
   -filter-name "QD_filter" -filter "QD < 2.0" \
   -filter-name "FS_filter" -filter "FS > 200.0" \
   -filter-name "S0R_filter" -filter "S0R > 10.0" \
   -genotype-filter-expression "DP < 10" \
   -genotype-filter-name "DP_filter" \
   -genotype-filter-expression "GQ < 10" \
   -genotype-filter-name "GQ_filter" \  


# Select Variants that PASS filters

gatk SelectVariants \
   --exclude-filtered \
   -V ${result}/filtered_snps.vcf \
   -0 ${results}/analysis-snps.vcf
   

gatk SelectVariants \
   --exclude-filtered \
   -V ${result}/filtered_indels.vcf \
   -0 ${results}/analysis-indels.vcf

# to exclude variants that failed genotype filters

cat analysis-ready-snps.vcf|grep -v -E "DP_filter|GQ_filter" > analysis-ready-snps-filteredGT.vcf
cat analysis-ready-indels.vcf|grep -v -E "DP_filter|GQ_filter" > analysis-ready-indels-filteredGT.vcf


#Annotate variants -

gatk Funcotator \
    --variant ${results}/analysis-ready-snps-filteredGT.vcf \
    --reference ${ref} \
    --ref-version hg38\
    --data-source-path /Desktop/demo/hg38/funcotator_dataSources.v1.7.20200521g \
    --output ${results}/analysis-ready-snps-filteredGT-functotated.vcf \
    --output-file-format VCF
    
gatk Funcotator \
    --variant ${results}/analysis-ready-indels-filteredGT.vcf \
    --reference ${ref} \
    --ref-version hg38\
    --data-source-path /Desktop/demo/hg38/funcotator_dataSources.v1.7.20200521g \
    --output ${results}/analysis-ready-indels-filteredGT-functotated.vcf \
    --output-file-format VCF

fi

# Extract fields from a VCF file to a tab-delimited table

gatk VariantsToTable \
     -V ${results}/analysis-ready-snps-filteredGT-functotated.vcf -F AC -F AN -F DP -F AF -F FUNCOTATION \
     -0 ${results}/output_snps.table


