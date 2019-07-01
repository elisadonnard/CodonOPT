perl highestTPMisoform.pl $1 > max_tpm_isoform
awk '{print $2}' max_tpm_isoform | sed "s/_/\t/" | awk '{print $2}' > get_isoforms
Rscript source_step1.R $2
perl rename_bed.pl $3 one_iso_mp.bed > coding_renamed_one_iso.bed
