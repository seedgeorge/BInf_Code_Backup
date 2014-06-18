#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;
use File::Path qw(make_path);
# Version 1.1 Incomplete
# Not for commercial use
# Designed and written by George Seed; Birkbeck College and the Institute of Cancer Research

# This script is designed to take the copy number and mutation data from a specific subdirectory of 'data' and produce a combined results file


my %muthash = (
        key1 => '1',
        key15 => '3',
        key150 => '1', );
my %copyhash (
        key1 => '1',
        key15 => '1',
        key140 => '1', );
my %mergedhash;
%mergedhash = map {$_=> $muthash{$_} + $copyhash{$_} } (keys %muthash, +keys %copyhash);



my $fileoutput = $name." COMB".".csv";        
open (OUTPUT,">Input/$fileoutput") or die "Could not open output file\
+n";
foreach my $gene (keys %mergedhash) {
    print OUTPUT "$gene",",","$mergedhash{$gene}","\n";
}
close (OUTPUT);