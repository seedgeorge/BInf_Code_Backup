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

print "WORK IN PROGRESS\n";
print "V1.1\n";
print "This script works on several input documents, and produces some output statistics regarding the distribution of genetic aberrations among signalling pathways.\n";
print "The script requires ONE input file from the user: a simple list of genetic aberrations present in the sample in the format 'Gene Name','Number' (.csv); additionally, a pathway-assignment file will be referenced automatically and will be bundled with this script\n.";
print "Please ensure that 1. the input file is in the right format (.csv extension,) and 2. that it is in the same folder as this script.\n";
print "\n";
print "THIS SCRIPT IS ALREADY CONFIGURED\nType directory to score:\t";

# -----------------	------------------ # this scrapes the filenames from the selected directory and stores them in an array, and opens up foreach loop to iterate through it.
my $inputdir = <STDIN>;
chomp($inputdir);
my $fulldir = "Input/$inputdir";

opendir DIR, $fulldir or die "This directory doesn't exist!";
my @files = readdir DIR;
closedir DIR;

foreach my $file (@files) {
	print "\t$file\n";
}
print "\n";

@files = @files[2.. $#files];

my $count = "";
foreach my $filename (@files) {
	$count++;
	print "Working... $count";
	open (INPUT1,"$fulldir/$filename")
		or die "Couldn't find any files...\n";

# -----------------	------------------ # this loads the entry gene/variants list into a hash, duplicates are alerted to the user - in the case of a duplicate, only the first instance is recorded in the main hash.
	
	my %ghash;  
	my $dupcount = "0";
	my @dups;
	while (my $line = <INPUT1>){
		chomp($line);
		if ($line =~ /,(\w+),(\d+)/) {
			if ($ghash{$1}){
				$dupcount++;
				push (@dups, $1);
			} else {
				$ghash{$1} = $2;
			}
		}
	}
	#print "The file $filename was read successfully.\n\n";
	if ($dupcount > 0){ 
		print "However, it contained $dupcount duplicate genes, for an accurate assessment, please check duplicates and re-enter data for analysis.\n";
		print "Duplicates are: \n @dups \n";
	}
	#print "\nSuccessfully read data is: \n";
	#print Dumper(\%ghash),"\n";
	close (INPUT1);

# -----------------	------------------ # this section is the part where the script checks %ghash against the reference pathway document

	my $pathref = "Pathways.csv";
	my %pathways; # saving the pathway data in here, formatted Pathway:array of genes
	my %results; # I'd like to put all the results for each pathway in here - formatted Pathway:Score
	open (INPUT2,"Database/$pathref")
		or die "Pathway reference file not found. Script closing.\n"; 
	while (my $line = <INPUT2>){
		chomp($line);
		if ($line =~ /^(.*),Reactome Pathway,(.*)$/){
			my @patgenes = split (',',$2);
			my $patgenes = join(' ', @patgenes);
			$pathways{$1} = $patgenes;
			$results{$1} = 0;
		}
	}	
	close (INPUT2);

# -----------------	------------------ # This section is the scoring for the %results hash and also prints out a summary for the user
	
	foreach my $gene (keys %ghash){
		my $genescore = $ghash{$gene};
		foreach my $pathway (keys %pathways){
			if ($pathways{$pathway} =~ m/$gene\b/g) {
				my $patscore = "1";
				if ($patscore == 1){
					$results{$pathway} += $genescore;
				}
			}
		}
	}
	my $threshold = 0;
	#print "Involvement threshold = $threshold";
	my $resultcount = "";
	foreach my $score (values %results){
		if ($score >= $threshold) {
			$resultcount ++;
		}
	}
	#print "The number of pathways scoring at the threshold or above are: $resultcount.\n";
	#print "The selected pathways are shown below.\n";
	# foreach (sort { ($results{$a} cmp $results{$b}) || ($a cmp $b) } keys %results) {
		# if ($results{$_} >= $threshold){
		# print "$_: $results{$_}\n";
		# }
	# }

# -----------------	------------------ # This section is the outputting to various files - there is a results file in the results folder AND the results are appended to a log file found in the local folder

	my $dt = DateTime->now(time_zone=>'local');
	my $date = $dt->mdy('.');
	my $localtime = localtime();
	my $outputname = "run $filename-$localtime";
	open (LOG, '>>SeqHetLog.txt');
	print LOG "\n$outputname\n\n";
	foreach (sort { ($results{$a} cmp $results{$b}) || ($a cmp $b) } keys %results) {
		print LOG " $_ \t $results{$_}\n";
	}
	close (LOG);
	print "\n New output file will be named: $outputname\n";
	my $run = "Results/$inputdir\_$date";
	make_path("$run");
	open (OUTPUT,">$run/$filename") or die "Could not open output file\n";
	print OUTPUT "\n$outputname\n";
	foreach my $path (keys %results) {
		print OUTPUT "$path",",","$results{$path}","\n";
	}
	close (OUTPUT);
}

print "$count files generated.\n";