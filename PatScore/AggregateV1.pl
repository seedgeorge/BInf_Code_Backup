#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;
use File::Path qw(make_path);
use List::Util qw(sum);

# This script is designed to summarise the results from a discrete set of SeqHet runs. 
# It produces an aggregate table, rows being individual pathways, and the columns as mean score, standard deviation
# Supercedes old code - summariser.pl

# ---------- Section 1  - directory opening and file scanning
print "Run to summarise? ";
chomp (my $directory = <STDIN>);
print "\n";

my $fulldir = "Results/$directory";
print "Trying to open ","$fulldir:\n";

opendir DIR, $fulldir or die "This directory doesn't exist!";
my @files = readdir DIR;
closedir DIR;

foreach my $file (@files) {
	print "\t$file\n";
}
print "\n";

@files = @files[2.. $#files];

# ---------- Section 2  - prepares the pathwaytotals hash with the aggregate scores, and prints an AGGREGATE file of all results
my %pathwaytotals;

foreach my $file (@files) {
	open (FH,"$fulldir/$file");
	while (my $line = <FH>) {
		chomp $line;
		if ($line =~ /(.+)\,(\d+$)/) {
			my $pathway = $1;
			my $score = $2;
			$pathwaytotals{$pathway} .= $score;
			$pathwaytotals{$pathway} .= "\t";
		}
	}
	close (FH);
}

my $fileoutput1 = $directory."-aggregate.txt";
open (OUTPUT1,">$fulldir/$fileoutput1") or die "Could not open output file\n";

foreach my $filename (@files) { #printing the filenames as column headers 
	print OUTPUT1 "\t$filename";
}
print OUTPUT1 "\n";
foreach my $key (keys %pathwaytotals) { #printing the actual data
	print OUTPUT1 $key,"\t",$pathwaytotals{$key},"\n";
}
close OUTPUT1;

# ---------- Section 3  - generate the mean and std dev for each pathway
my $length = scalar(@files);
print "$length files are evaluated.\n";

foreach my $pathway (keys %pathwaytotals) {
	my @temparray = split(/\t/,$pathwaytotals{$pathway});
	# print my $sum = sum(@temparray);
	# print "\n";
	my $avg = Mean(@temparray);
	my $std = StdDev(@temparray);
	my $sum = sum(@temparray);
	$pathwaytotals{$pathway} = "$sum\t$avg\t$std"; 
}

sub StdDev { #subroutine for StDev
	my $total = "0"; 
	my $sumOfSquares = "0";
	my $stddev = "0";
	my $variance = "0";
	my $sum = sum(@_);
	if ($sum > 0) {
		foreach my $value (@_) {
			$total++;
			$sumOfSquares += $value * $value;
		}
		$variance = ($sumOfSquares -(($sum*$sum)/$total))/($total-1);
		$stddev = sqrt($variance);
	}
	return $stddev;
}

sub Mean { #subroutine for Mean
	my $mean = "";
	my $total = "";
	my $sum = sum(@_);
	my $value = "";
	foreach $value (@_) {
		# $sum += $value;
		$total++;
	}
	$mean = $sum/$total;
	return $mean;
}

# ---------- Section 4  - output SUMMARY file
my $fileoutput2 = $directory."-summary.txt";

open (OUTPUT2,">$fulldir/$fileoutput2") or die "Could not open output file\n";
print OUTPUT2 "Reactome Pathway\tSum\tAvg\tStdDev\n";
foreach my $pathway (keys %pathwaytotals) {
	print OUTPUT2 "$pathway\t$pathwaytotals{$pathway}\n";
}

close (OUTPUT2);