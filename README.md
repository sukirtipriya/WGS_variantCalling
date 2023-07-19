# WGS_variantCalling



# Variant identification and analysis

A likely workflow in human genetic variation studies is the analysis and identification of variants associated with a specific trait or population. Bioinformatics is key to each stage of this process and is essential for handling genome-scale data. It also provides us with a standardised framework to describe variants.

In this section we will learn about the major steps in the process of variant calling, the VCF file format and variant identifiers. We will also examine the value of prediction in determining impact of variation on protein function and structure.  
What is variant calling?

# Variant calling is the process by which we identify variants from sequence data (Figure 11).

    1.Carry out whole genome or whole exome sequencing to create FASTQ files.
    2.Align the sequences to a reference genome, creating BAM or CRAM files.
    3.Identify where the aligned reads differ from the reference genome and write to a VCF file.
    ![image](https://github.com/sukirtipriya/WGS_variantCalling/assets/88479900/e172e4ac-7533-482a-b585-4dc423026aba)

# Somatic versus germline variant calling
In germline variant calling, the reference genome is the standard for the species of interest. This allows us to identify genotypes. As most genomes are diploid, we expect to see that at any given locus, either all reads have the same base, indicating homozygosity, or approximately half of all reads have one base and half have another, indicating heterozygosity. An exception to this would be the sex chromosomes in male mammals.


# Understanding VCF format

VCF is the standard file format for storing variation data. It is used by large scale variant mapping projects such as IGSR. It is also the standard output of variant calling software such as GATK and the standard input for variant analysis tools such as the VEP or for variation archives like EVA.

VCF is a preferred format because it is unambiguous, scalable and flexible, allowing extra information to be added to the info field. Many millions of variants can be stored in a single VCF file. 

VCF files are tab delimited text files. Here is an example of a variant in VCF (Figure 12) as viewed in a spreadsheet:
![image](https://github.com/sukirtipriya/WGS_variantCalling/assets/88479900/bf13047f-7a12-4f8a-9073-14ef0faba53a)


# Variant analysis

Variants can be analysed in different ways. For example, you might want to determine which genes the variants hit and what effects they have on them. Tools such as the Ensembl VEP and SnpEff can be used for this.
Pprediction can never be as valuable as experimental data. Any predictions determined bioinformatically should be followed up experimentally, and no conclusions should be drawn in what variant causes a phenotype based only on bioinformatic predictions.


# Predicting the effect of variation on protein structure and function

The effect of genetic variation on protein structure and function varies dramatically depending on the type of protein and the extent of variation. This means that it is difficult to predict the exact effect of sequence variance upon structure, and therefore, function of a protein.

The location of the variation needs to be considered, along with the function of the protein, to help gain an understanding of the effect of a variant on the protein structure and its function.

There are various tools available to assist in the prediction of variation on protein stability, including, such as I-Mutant.

In addition, if there are structural homologs available, you can use structure prediction servers to predict the structure, for example I-TASSER or Phyre2.
