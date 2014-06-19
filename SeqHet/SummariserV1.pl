#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;
use File::Path qw(make_path);

# THis script is designed to summarise the results from a discrete set of SeqHet runs. 
# It produces a summary table, with columns being individual sample scores and the rows different pathways

# Section 1  - directory opening and file scanning
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