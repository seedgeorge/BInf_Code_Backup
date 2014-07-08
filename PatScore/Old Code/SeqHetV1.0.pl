#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;

# Version 1.0 Incomplete
# Not for commercial use
# Designed and written by George Seed; Birkbeck College and the Institute of Cancer Research

print "WORK IN PROGRESS\n";
print "V0.9\n";
print "This script works on several input documents, and produces some output statistics regarding the distribution of genetic aberrations among signalling pathways.\n";
print "The script requires ONE input file from the user: a simple list of genetic aberrations present in the sample in the format 'Gene Name','Number' (.csv); additionally, a pathway-assignment file will be referenced automatically and will be bundled with this script\n.";
print "Please ensure that 1. the input file is in the right format (.csv extension,) and 2. that both the input file and reference file are in the same folder as this script.\n";
print "\n";
print "Are you happy to proceed?\t";

# -----------------	------------------ # this is all basic introductory stuff, selecting files etc, with some limited error detection

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

print "Please write the name of the file that you wish to assess \(including filetype, ie: file.csv\).\n";
 # User defines filename, relies on being in the same folder, would also accept directory of course, but it's weird on windows etc

my $filename = "";

my $proceedloop2 = ""; #second proceedloop
until ($proceedloop2) {
	print "Enter filename: ";
	chomp ($filename = <STDIN>);
	if ($filename =~ /\.csv$/) { #matches .csv documents
		print "Correct filetype, this script will continue.\n\n";
		$proceedloop2 =1;	
	} else {
		print "Unrecognised filetype. Try again?\n";
	}
}

open (INPUT,"$filename") 
	or die "Couldn't find this file, sorry. Did you name it right?\n";

# -----------------	------------------ # this loads the entry gene/variants list into a hash, duplicates are alerted to the user - in the case of a duplicate, only the first instance is recorded in the main hash.
	
my %ghash;  
my $dupcount = "0";
my @dups;

while (my $line = <INPUT>){
	chomp $line;
	if ($line =~ /(^\w+),(\d+$)/) {
		if ($ghash{$1}){
			$dupcount++;
			push (@dups, $1);
		} else {
			$ghash{$1} = $2;
		}
	}
}

print "The file $filename was read successfully.\n\n";
if ($dupcount > 0){ 
	print "However, it contained $dupcount duplicate genes, for an accurate assessment, please check duplicates and re-enter data for analysis.\n";
	print "Duplicates are: \n @dups \n";
}
	
print "\nSuccessfully read data is: \n";
print Dumper(\%ghash),"\n";

close (INPUT);

# -----------------	------------------ # this section is the part where the script checks %ghash against the reference pathway document, relying that both are in the same folder - I should package the reference document with this script

my $pathref = "ReactomePathwaysCurated.csv"; #filehandle for the reactome dump file, this is the curated version with the highest tier of pathways removed - the uncurated version is reactomepathways.csv
my %pathways; # saving the pathway data in here, formatted Pathway:array of genes
my %results; # I'd like to put all the results for each pathway in here - formatted Pathway:Score

open (INPUT,"$pathref")
	or die "Pathway reference file not found. Script closing.\n"; 

while (my $line = <INPUT>){
	chomp $line;
	if ($line =~ /^(.*),Reactome Pathway,(.*)$/){
		my @patgenes = split (',',$2);
		my $patgenes = join(' ', @patgenes);
		$pathways{$1} = $patgenes;
		$results{$1} = 0;
	}
}

close (INPUT);

# print Dumper(\%pathways); # debugging to see if the hashes are working - both %results and %pathwaysprint appropriately here

# -----------------	------------------ # This section is the scoring for the %results hash and also prints out a summary for the user

foreach my $gene (keys %ghash){
	my $genescore = $ghash{$gene};
	# print "$gene = $genescore\n"; # more optional debugging to test if the assignments are working the right way - they are
# }

	foreach my $pathway (keys %pathways){
		# print "$pathway $gene $genescore"; # more debugging, seems fine
	# }
# }
		if ($pathways{$pathway} =~ m/$gene\b/g) {
			my $patscore = "1";
			if ($patscore == 1){
				$results{$pathway} += $genescore;
			}
		}
	}
}

print "What pathway involvement threshold should be used?\n";
my $threshold = <STDIN>;

my $resultcount = "";
foreach my $score (values %results){
	if ($score >= $threshold) {
		$resultcount ++;
	}
}

print "The number of pathways scoring at the threshold or above are: $resultcount.\n";
print "The selected pathways are shown below.\n";


foreach (sort { ($results{$a} cmp $results{$b}) || ($a cmp $b) } keys %results) {
	if ($results{$_} >= $threshold){
	print "$_: $results{$_}\n";
	}
}

# print Dumper(\%rhash); # is handy if you just want to print the entire hash, but it can be bit massive

# -----------------	------------------ # This section is the outputting to various files - there is a results file generated for the user AND the results are appended to a log file found in the same folder

my $localtime = localtime();

open (LOG, '>>SeqHetLog.txt');
print LOG "$localtime\n\n";
foreach (sort { ($results{$a} cmp $results{$b}) || ($a cmp $b) } keys %results) {
	print LOG "$_ \t $results{$_}\n";
}


#print "\nPlease enter name of new output file: ";
#my $newfilename = <STDIN>;



