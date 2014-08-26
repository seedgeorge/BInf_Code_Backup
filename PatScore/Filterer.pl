#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;
use File::Path qw(make_path);
use List::Util qw(sum);

# script is used to filter results files based on a list of pathways
# it is pre-configured based on the existing directory structure
my $config = 4; # config code indicates which hierarchy of pathways to filter by
my $target = "";
if ($config == 1) {
	$target = "Tier1 pathways.txt";
	} elsif ($config == 2) {
		$target = "Tier2 pathways.txt";
	} elsif ($config == 3) {
		$target = "DNA_repair_tier2.txt";
	} elsif ($config == 4) {
		$target = "Cell_cycle_tier3.txt";
}
my @filter;
open (FH,"Database/$target") or die "Couldn't open filter.\n"; # opens up filter list into an array
while (my $line = <FH>) {	chomp $line;
	push (@filter,$line);
}
close (FH);

print "Which directory to access?\n"; # opens up and results file
my $dir = "BC-su2c Comp2";
chomp $dir; 
print "Which result to filter?\n";
my $res = "su2c-bc2012_titles_finished_temp.txt";
chomp $res;
my $file = "$dir/$res"; 
my @results;
open (INPUT2,"Results/$file") or die "Couldn't open results.\n";
while (my $line = <INPUT2>) {
	chomp $line;
	push (@results,$line);
}
close (INPUT2);

my @output; # prepares the output array


foreach my $path (@filter) {
	foreach my $result (@results) {
		if ($result =~ /^$path\t\d/) {
		push (@output,$result)
		}
	}
}

# foreach my $path (@output) {
	# print "$path\n";
# }
open (OUTPUT, ">Results/$dir/filter$config.txt") or die "Could not open output file...\n";
foreach my $filtered (@output) {
	print OUTPUT "$filtered\n";
}
close (OUTPUT);