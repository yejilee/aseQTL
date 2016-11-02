#!/usr/bin/perl -w

use strict;
use warnings;
use Storable;

my $gene1=$ARGV[0]; my $chr1=$ARGV[1]; my $tss1=$ARGV[2]; my $beta_dir=$ARGV[3];
my %altref_hash = %{retrieve("altref_hash.chr$chr1.hash")};

my $cis1=100000;
my $out_dir="beta_SNPs";


system("mkdir -p $out_dir");
system("grep -wh $gene1 $beta_dir/* > temp_$gene1\_input");

my $s1=$tss1-$cis1;
my $s2=$tss1+$cis1;


for my $k1 (sort keys %altref_hash) {
	if ($k1 <$s1 || $k1 >$s2 ) {
		delete $altref_hash{$k1};
	}
}

my %tmp_result_hash; my @idlist;

open(FILEA,"<temp_$gene1\_input") || die "Can't open aseQTL results for $gene1!\n";;
while(<FILEA>) {
	chomp;
	my @line1=split(/\s+/,$_);
	$tmp_result_hash{$line1[1]}{SE}=$line1[10];
	$tmp_result_hash{$line1[1]}{TOTAL_READS}=$line1[4];
	$tmp_result_hash{$line1[1]}{BETA}=$line1[7];
	push(@idlist,$line1[1]);
}
close(FILEA);

my $temp_beta;
open(OUTA,">$out_dir/beta_$gene1.txt");
print OUTA "GENE\tCHR\tSNP_POS\tID\tBETA\tSE\tTOTAL_READS\n";
for my $id1 (@idlist) {
	for my $k2 (sort keys %altref_hash) {
		if (defined $altref_hash{$k2}{$id1}) {
			if ($altref_hash{$k2}{$id1} eq "REF") {
				$temp_beta=-1*$tmp_result_hash{$id1}{BETA};
			} elsif ($altref_hash{$k2}{$id1} eq "ALT") {
				$temp_beta=$tmp_result_hash{$id1}{BETA};
			} else {
				$temp_beta="NA";
			}
			print OUTA "$gene1\t$chr1\t$k2\t$id1\t$temp_beta\t$tmp_result_hash{$id1}{SE}\t$tmp_result_hash{$id1}{TOTAL_READS}\n";
		}

	}
}
close(OUTA);

system("Rscript meta.R $gene1 $out_dir/beta_$gene1.txt $out_dir/aseQTL_$gene1.txt");

system("rm temp_$gene1\_input");
print STDOUT "All jobs for $gene1 has been done! \n";
