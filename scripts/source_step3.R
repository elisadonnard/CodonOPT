#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
options(scipen = 999)
# AA names
tableAA = read.table(args[1])
# gene expression
genes = read.table(args[2], header = T, stringsAsFactors = F, row.names = 1)
genes$max = apply(genes,1,max)
#summary(genes$max)
#quantile(genes$max, seq(0,1,0.1))
top10 = rownames(genes[genes$max>=quantile(genes$max, 0.9),])
write.table(top10,"top_expressed_genes", row.names = F, quote = F, col.names = F)
### Codon input
codons = read.table(args[3], stringsAsFactors = F)
codons = codons[top10,]
#########################################################################################################################
# with methionine
freqs = as.data.frame(table(codons$V2[grep("TGA|TAG|TAA", codons$V2, invert = T)]))
### calculate cAI
merged = merge(tableAA,freqs,by=1,all.y = T)
colnames(merged) = c("codon","aa","aaname","freq")
ncod = as.data.frame(table(merged$aa))
colnames(ncod) = c("aa","num")
ncod$aa = as.character(ncod$aa)
merged = merge(merged,ncod,by="aa")
for (i in 1:nrow(ncod)) {
  aa=ncod$aa[i]
  merged$expected[merged$aa==aa] = sum(merged$freq[merged$aa==aa])/ncod$num[ncod$aa==aa]
}
merged$ratio = merged$freq/merged$expected
for (i in 1:nrow(ncod)) { # warning issued because of lack of stop codons
  aa = ncod$aa[i]
  maxaa = max(merged$ratio[merged$aa==aa])
  merged$cAI[merged$aa==aa] = merged$ratio[merged$aa==aa]/maxaa
}
write.table(merged[,c("codon","aa","freq","ratio","cAI")],"cAI.tsv", sep = "\t", quote = F, row.names = F, col.names = T)
#########################################################################################################################
# without methionine
freqs = freqs[grep("ATG", freqs$Var1, invert = T),]
###
merged = merge(tableAA,freqs,by=1,all.y = T)
colnames(merged) = c("codon","aa","aaname","freq")
ncod = as.data.frame(table(merged$aa))
colnames(ncod) = c("aa","num")
ncod$aa = as.character(ncod$aa)
merged = merge(merged,ncod,by="aa")
for (i in 1:nrow(ncod)) {
  aa=ncod$aa[i]
  merged$expected[merged$aa==aa] = sum(merged$freq[merged$aa==aa])/ncod$num[ncod$aa==aa]
}
merged$ratio = merged$freq/merged$expected
for (i in 1:nrow(ncod)) {
  aa = ncod$aa[i]
  maxaa = max(merged$ratio[merged$aa==aa])
  merged$cAI[merged$aa==aa] = merged$ratio[merged$aa==aa]/maxaa
}
write.table(merged[,c("codon","aa","freq","ratio","cAI")],"cAI_noMET.tsv", sep = "\t", quote = F, row.names = F, col.names = T)
