args = commandArgs(trailingOnly=TRUE)
genes = scan("get_isoforms", what=character())
bed = read.table(args[1], stringsAsFactors=F)
sub = bed[bed$V4%in%genes,]
write.table(sub, "one_iso_mp.bed", col.names=F, row.names=F, quote=F, sep="\t")
