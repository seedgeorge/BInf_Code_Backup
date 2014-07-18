#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use 5.010;
use Data::Dumper;
use DateTime;
use File::Path qw(make_path);
use List::Util qw(sum);

my $filehandle = "Pathway Hierarchy.txt";


my @pathways;
open (FH,"$filehandle");
while (my $line = <FH>) {
	if ($line =~ /\(Pathway\)/){
		push (@pathways, $line);
	}
}

open (OUTPUT, ">Pathways.txt");
foreach my $thing (@pathways) {
	print OUTPUT "$thing\n";
}