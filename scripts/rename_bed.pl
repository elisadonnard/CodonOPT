#!/usr/bin/perl
#####################################
# Program: rename_bed.pl  -  Date: Wed Oct  7 10:24:09 EDT 2015
# Autor: Elisa Donnard
#
# License: GPL - http://www.gnu.org/licenses/gpl.html
#
#####################################

my %ref = ();

open (IN0,"<$ARGV[0]");

while (<IN0>) {
    chomp $_;
    @tmp = split (/\t/, $_);
    $ref{$tmp[1]} = $tmp[0];
}


open (IN1,"<$ARGV[1]");
while (<IN1>) {
    chomp $_;
    @tmp = split (/\t/, $_);
    $transc = $tmp[3];
    if ($ref{$transc}){
#    print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$ref{$transc}\t$tmp[4]\t$tmp[5]\n";  # use for simple bed
    print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$ref{$transc}\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t$tmp[8]\t$tmp[9]\t$tmp[10]\t$tmp[11]\n"; # use for bed12
    }
}
