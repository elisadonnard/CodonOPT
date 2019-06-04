#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# gene expression
genes = data.table::fread(args[1], stringsAsFactors = F)
genes$max = apply(genes[,-1],1,max)
#summary(genes$max)
#quantile(genes$max, seq(0,1,0.1))
top10 = genes$ID[genes$max>=quantile(genes$max, 0.9)]
write.table(top10,"top_expressed_genes", row.names = F, quote = F, col.names = F)
