#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;
use File::Path qw(make_path);

# This script is designed to summarise the results from a discrete set of SeqHet runs. 
# It produces a summary table, rows being individual pathways, and the columns as mean score, standard deviation

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

# ---------- Section 2  - sum the score for each pathway
my %pathwaytotals;

foreach my $file (@files) {
	open (FH,"$fulldir/$file");
	while (my $line = <FH>) {
		chomp $line;
		if ($line =~ /(.+)\,(\d+$)/) {
			my $pathway = $1;
			my $score = $2;
			$pathwaytotals{$pathway} .= $score;
			$pathwaytotals{$pathway} .= ",";
		}
	}
	close (FH);
}

# ---------- Section 3  - generate the mean and std dev for each pathway
my $length = scalar(@files);
print "$length files are evaluated.\n";

foreach my $pathway (keys %pathwaytotals) {
	my @temparray = split(/,/,$pathwaytotals{$pathway});
	my $avg = Mean(@temparray);
	my $std = StdDev(@temparray);
	print "$pathway\t$avg\n"
}

sub StdDev {
	my $total = "";
	my $sum = "";
	my $sumOfSquares = "";
	my $stddev = "";
	my $variance = "";
	foreach my $value (@_) {
		$sum += $value;
		$total++;
		$sumOfSquares += $value * $value;
	}
	$variance = ($sumOfSquares -(($sum*$sum)/$total))/($total-1);
	$stddev = sqrt($variance);
	return $stddev;
}

sub Mean {
	my $mean = "";
	my $total = "";
	my $sum = "";
	my $value = "";
	foreach $value (@_) {
		$sum += $value;
		$total++;
	}
	$mean = $sum/$total;
	return $mean;
}
	