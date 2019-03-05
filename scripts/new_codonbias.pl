#!/usr/bin/perl
#####################################
# Program: codonbias.pl  -  Date: Mon Jan 25 15:04:19 EST 2016
# Autor: Elisa Donnard
#
# License: GPL - http://www.gnu.org/licenses/gpl.html
#
#####################################
use bignum;    
my $dna = ();
my $chr = "";
my $start = "";
my $codon = "";
my %tAI = ();

open (IN0,"<$ARGV[0]");
$/ = ">";

while (<IN0>) { #genome fasta file
    chomp $_;
    my $seq = $_;
    if ($seq ne "") {
	if ($seq != /^>/) {
	    $seq =~ s/^/>/;
	}
	my ($id) = $seq =~ /^>*(\S+)/;  # parse ID as first word in FASTA header print "$id\n";
	$seq =~ s/^>*.+\n//;  # remove FASTA header
	$seq =~ s/\n//g;  # remove endlines              
	if ($id !~ /Un|gl/) {
	    $dna{$id} = $seq;
	}
    }
}
close (IN0);

open (IN1, "<$ARGV[1]");
$/ = "\n";

while (<IN1>) { # tRNA adaptiveness values
    chomp $_;
    if (!/codon/) {
	@tmp = split (/\t/, $_);
	$tAI{$tmp[0]} = log($tmp[4]);
    }
}


open (IN2,"<$ARGV[2]"); # bed12 file with organism genes ************* CDS ONLY ************ (one transcript per gene)
open (OUT, ">$ARGV[3]"); # control output with each codon and tAI

# for loop with all exons, get all seq from genome, then go 3 by 3 examining each codon and counting how many are optimal in one variable and how many codons in the gene in another. Calculate % optimal for each gene and print

while (<IN2>) {
    chomp $_;
    @tmp = split (/\t/, $_);
    $chr = $tmp[0];
    $rna = "";
    @exonstarts = split (/,/, $tmp[11]);
    @exonsizes = split (/,/, $tmp[10]);
    for ($i=0; $i<=$#exonstarts; $i++) {
	$start = $tmp[6] + $exonstarts[$i];
	$rna .= substr($dna{$chr}, $start, $exonsizes[$i]);
	$rna =~ tr/actg/ACTG/;
#	print $rna."\n";
#	$end = $start + $exonsizes[$i];
#	print $chr."\t".$start."\t".$end."\n";
    }
    if ($_ !~ /\+/) { # reverse complement for rev strand genes
	$rna =~ tr/ACGT/TGCA/;
	$rna = reverse($rna);
    }
    $size = length($rna);
    $total = 0;
    $prod = 0;
    $geneAI = 0;
    for ($j=3; $j<=$size-6; $j+=3) { # skip start and stop codon
	$codon = substr($rna, $j, 3);
	$total++;
	print OUT "$tmp[3] $codon $total $tAI{$codon}\n";
	if ($tAI{$codon}) {
	    if ($j > 3) {
		$prod += $tAI{$codon}; 
	    }
	    else {
		$prod = $tAI{$codon};
	    }
	}
    }
    $geneAI = exp($prod/$total);
    print "$tmp[3]\t$prod\t$total\t$geneAI\n";
}

close(OUT);
