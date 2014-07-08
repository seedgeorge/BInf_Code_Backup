#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;
use File::Path qw(make_path);

# This script is designed to take the 'trimmed' files from the directory SeqHet/Data/userdefined/Trim, and produce 'input' documents for running with the SeqHet script
# 1 It takes the filenames from a user defined directory, assigns into an array of filenames
# 2 each unique samplename is identified
# 3 the data from all matching samplenames are pushed into appropriate hashes
# 4 the hashes are combined together
# 5 a new file is created in SeqHet/Input containing the array

# Section 1  - directory opening
print "Directory to scan: ";
chomp (my $directory = <STDIN>);
print "\n";

my $fulldir = "Data/$directory/Trim";
print "Trying to open ","$fulldir:\n";

opendir DIR, $fulldir or die "This directory doesn't exist!";
my @files = readdir DIR;
closedir DIR;

foreach my $file (@files) {
	print "\t$file\n";
}
print "\n";

@files = @files[2.. $#files];

# Section 2 - finding sample names
my %uniquesamples;
foreach my $file (@files) {
	if ($file =~ /(\S+)/) {
		my $name = $1;
		$uniquesamples{$name} ++ if $name;
	}
}

print "Unique samples found: \n";
foreach my $key (keys %uniquesamples) {
	print "\t$key\n";
}

# Sections 3 + 4 + 5 - monster loop that pushes together matching samples and creates new files in the Input folder, ready for further processing
foreach my $name (keys %uniquesamples) {
	my %muthash;
	my %copyhash;
	my %mergedhash;
	foreach my $file (@files) {
		if ($file =~ /$name\sMuts/) {
			open (FH,"Data/$directory/Trim/$file");
			while (my $line = <FH>) {
				chomp $line;
				if  ($line =~ /\,(\S+)\,(\d+)/) {
					my $gene = $1;
					my $score = $2;
					$muthash{$gene} = $score;
				}
			}
			close (FH);
		} elsif ($file =~ /$name\sCopy/) {
			open (FH,"Data/$directory/Trim/$file");
			while (my $line = <FH>) {
				chomp $line;
				if  ($line =~ /\,(\S+)\,(\d+)/) {
					my $gene = $1;
					my $score = $2;
					$copyhash{$gene} = $score;
				}
			}
			close (FH);
		}
	}
	$mergedhash{$_} += $muthash{$_} for keys %muthash;
	$mergedhash{$_} += $copyhash{$_} for keys %copyhash;
	my $fileoutput = $name." COMB".".csv";	
	my $outdir = "Input/$directory";	
	make_path("$outdir");
	open (OUTPUT,">Input/$directory/$fileoutput") or die "Could not open output file\n";
	foreach my $gene (keys %mergedhash) {
		print OUTPUT ",","$gene",",","$mergedhash{$gene}\n";
	}
	close (OUTPUT);
}

print "\nTransfer complete. \n";