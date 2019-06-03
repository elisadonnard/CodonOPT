perl ~/bin/highestTPMisoform.pl $1 > max_tpm_isoform
awk '{print $2}' max_tpm_isoform | sed "s/_/\t/" | awk '{print $2}' > get_isoforms
fgrep -w -f get_isoforms $2 > one_iso_mp.bed
perl ~/bin/rename_bed.pl $3 one_iso_mp.bed > coding_renamed_one_iso.bed
