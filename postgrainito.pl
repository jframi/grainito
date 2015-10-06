#!/usr/bin/perl
use strict;
use warnings;

my @files;
opendir(DIRHANDLE, ".");
while(my $file = readdir(DIRHANDLE)) {
  push @files, $file if $file =~ /\.txt/;
}

open (RESFICH, ">grainito.out");
my $f = 1;

foreach my $file (@files){
	open (FICH, $file);
	my $line=<FICH>;
	if ($f==1) {
		print RESFICH "File\t$line";
	}
    while ($line=<FICH>){
		print RESFICH "$file\t$line";
	}
	$f = $f+1;
}

close (RESFICH);
