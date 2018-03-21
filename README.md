# CodonOPT
Calculating codon optimality (cAI or tAI)

## Getting Started

You will need a gene and isoform expression matrix with normalized values (ex: TPM)

### Prerequisites

R;
Perl;
bedtools 2.25.0 or higher;
Reference files for tRNA adaptiveness (human and mouse available here)

Isoform expression matrix: the first column has to contain the gene symbol as well as the isoform ID separated by one underscore character

```
ID  rep1  rep2  rep3  rep4  rep5
ACTB_NM_001101  N N N N N
```

### Step 1: Select highest expressed isoform

Run this script to select the isoform with highest expression for each gene. All the reference files needed for human and mouse are in the respective folders.

```
source_step1.bash YOUR_ISOFORM_EXP.tsv YOUR_REFERENCE.bed GENE_NAME_REF CODING_GENES
```
the output will be a file named coding_renamed_one_iso.bed


### Step 2: Calculate tAI (tRNA adaptiveness index, based on tRNA copy numbers in genome)

Run this script and generate a codon based and gene based tAI output

Reference fasta not provided, select apropriate tRNA adaptiveness file

```
perl new_codonbias.pl YOUR_REF.fa tRNA_adaptiveness_SPECIES.txt coding_renamed_one_iso.bed output_tAI_per_codon.txt > gene_tAI.tsv
```

### Step 3: Calculate cAI (codon adaptation index, Sharp 1987)

Run this R script to identify the top 10% expressed genes and get the input files for calculating cAI. Depends on the codon output generated in step 2.


```
Rscript source_step3.R table_AA.txt YOUR_GENE_EXPRESSION.tsv output_tAI_per_codon.txt
```
```
perl ~/bin/new_codonbias.pl YOUR_REF.fa cAI.tsv coding_renamed_one_iso.bed output_cAI_per_codon.txt > gene_cAI.tsv
```
