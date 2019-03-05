#!/usr/bin/perl
#####################################
# Program: highestTPMisoform.pl  -  Date: Mon Aug 29 15:40:47 EDT 2016
# Autor: Elisa Donnard
#
# License: GPL - http://www.gnu.org/licenses/gpl.html
#
#####################################

my @header = ();
my %max = ();
my %maxiso = ();

open (IN0,"<$ARGV[0]");

while (<IN0>) {
    my $gene = "";
    my %LPS = ();
    my @lps = ();
    chomp $_;
    if (/^Id\t/) {
	@header = split (/\t/, $_);
    }
    else {
	@tmp = split (/\t/, $_);
	$iso = $tmp[0];
	$gene = $iso;
	$gene =~ s/_.*//;
	for ($i=1; $i<=$#tmp; $i++) { ### second comlumn is first tpm value
	    $LPS{$header[$i]} = $tmp[$i];
	}
    }
    @lps = (sort { $LPS{$a} <=> $LPS{$b} } keys %LPS);
    my $lastLPS = $lps[$#lps];
    if ($max{$gene}) {
	if ($LPS{$lastLPS} >= $max{$gene}) {
	    $max{$gene} = $LPS{$lastLPS};
	    $maxiso{$gene} = $iso;
	}
    }
    else {
	$max{$gene} = $LPS{$lastLPS};
	$maxiso{$gene} = $iso;
    }
}
foreach $k (keys %max) {
    if ($k ne "") {
	print "$k\t$maxiso{$k}\t$max{$k}\n";
    }
}
