#!/usr/bin/perl -w
use strict;
use warnings;
use Storable;

my $infile1=$ARGV[0];
my $outfile1_tag=$ARGV[1];
my $out_dir="list_hetero";
system("mkdir -p $out_dir");

my $hash_ref={}; my $chr1;
my %position_hash; my %altref_hash;
open(FILEA,"gunzip -c $infile1 | ") || die "Can't open $infile1 !\n";
LINE : while(<FILEA>) {
	chomp;
	my @line1=split(/\s+/,$_);
	my $temp_check=substr($line1[0],0,2);
	next LINE if /^##/;
	
    my $size=scalar @line1;

	if ($line1[1] eq "POS") {
		for (my $j1=9;$j1<$size;$j1++) {
			my $id1=$line1[$j1];							
				$position_hash{$id1}=$j1;
		}
	} else {
		if ( length($line1[3])==1 && length($line1[4])==1 ) {			# filter out indels
			
			if (!defined($chr1)) {
				$chr1=$line1[0];
			}
			
			for my $k0 (sort keys %position_hash) {
			
			
				my $tmp_line = $line1[$position_hash{$k0}];
				$tmp_line =~ tr/ //ds;
				my @line2=split(/:/,$tmp_line);
				if ($line2[0] eq "0|1") {
					$hash_ref->{$k0}->{$line1[1]}=join("\t",$line1[3],$line1[4]);
					#$altref_hash{$line1[1]}{$k0}="REF";
					
						$altref_hash{$line1[1]}{$k0}="REF";
					
				} elsif ($line2[0] eq "1|0") {
					$hash_ref->{$k0}->{$line1[1]}=join("\t",$line1[4],$line1[3]);
					#$altref_hash{$line1[1]}{$k0}="ALT";
					
						$altref_hash{$line1[1]}{$k0}="ALT";
				}
			}
		}
	}
}
close(FILEA);

for my $k1 (sort keys %$hash_ref) {
	my $outfile1=$out_dir."/".$outfile1_tag.".".$k1;
	open (OUTA,">",$outfile1) || die "Can't write down genotype file for $k1!\n";
	for my $k2 (sort keys %{$hash_ref->{$k1}} ) {
		print OUTA "chr$chr1\t$k2\t$hash_ref->{$k1}->{$k2}\n";
	}
	close(OUTA);
}
print STDOUT "all jobs for $infile1 is done!\n";

store \%altref_hash,"altref_hash.chr$chr1.hash";