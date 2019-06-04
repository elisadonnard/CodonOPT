Rscript source_step3.R YOUR_GENE_EXPRESSION.tsv
awk '{OFS = "\t"; print "\""$1"\"",$2,$3,$4}' output_tAI_per_codon.txt | fgrep -w -f top_expressed_genes > top_expressed_output_tAI_per_codon.txt
