#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;

print "This small script is designed to scrape the number of discrete mutations per gene from a curated output. Do not run script unless familiar with function or output may be compromised.\n";
print "Are you ready to proceed?\n";

my $proceedloop = ""; #this whole business is a y/n prompt - basically, does the user want to proceed? The loop runs until proceedloop becomes positive
until ($proceedloop) {
	print "Enter Y|N: ";
	chomp (my $yesno = <STDIN>);
	if ($yesno =~ /^[Y]$/i){ #matches Y or y
		print "This script will continue.\n";
		$proceedloop =1;
	} elsif ($yesno =~ /^[N]$/i){ #matches N, n
		die "This script will close.\n";	
	} else {
		print "What? Unrecognised character. Try again?\n";
	}
}

print "Which input file would you like to open?\n";
my $filename = <STDIN>;

print "Which sample would you like to assess? eg. s115 \n";
my $samplename = <STDIN>;
chomp $samplename;

my %sampledata;

open (INPUT,"$filename")
	or die "Couldn't find this file, sorry. Did you name it right?\n";
	
while (my $line = <INPUT>) {
	chomp $line;
	if ($line =~ /(^\w*)\t\d\t(s\d*)\t/) {
		my $gene = $1;
		my $sample = $2;
		if ($sample =~ /$samplename/) {
			$sampledata{$gene} ++;
		}
	}
}

print Dumper (\%sampledata);

close (INPUT);

my $output = "$samplename.csv";
print "Filename is -> $output\n";

open (OUTPUT, ">$output")
	or die "Could not create.\n";

foreach my $gene (keys %sampledata) {
	print OUTPUT "$gene",",","$sampledata{$gene}\n";
}
