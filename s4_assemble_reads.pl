#!/usr/bin/perl -w

use strict;
use warnings;

my $id1=$ARGV[0];
my $in_dir=$ARGV[1];
my $out_file=$ARGV[2];
my $gencode_file=$ARGV[3];
my %read_hash;

for (my $chr0=1;$chr0<=22;$chr0++) {
	my $chr1="chr".$chr0;	
    my $bamfile_h1="$in_dir/tag2.$id1.$chr1\_hap1.bam";
	my $bamfile_h2="$in_dir/tag2.$id1.$chr1\_hap2.bam";
    system("samtools view -bf 1 $bamfile_h1 > temp_$id1.$chr1\_hap1.bam");
    system("samtools view -bf 1 $bamfile_h2 > temp_$id1.$chr1\_hap2.bam");
	
	system("samtools view temp_$id1.$chr1\_hap1.bam | python -m HTSeq.scripts.count -a 255 -q - $gencode_file > temp_counts.$id1.$chr1.h1");
	system("samtools view temp_$id1.$chr1\_hap2.bam | python -m HTSeq.scripts.count -a 255 -q - $gencode_file > temp_counts.$id1.$chr1.h2");
	
    my $h1_file="temp_counts.$id1.$chr1.h1";
	my $h2_file="temp_counts.$id1.$chr1.h2";
    
	open(FILEA,"<$h1_file") || die "Can't open $h1_file for $id1 , $chr1 !\n";
	while(<FILEA>) {
		chomp;
		next if /^_/;
		my @line1=split(/\s+/,$_);
		if ( $line1[1] != 0 ) {
			if ( defined $read_hash{$line1[0]}{h1} ) {
				die "have read counts on two chromosomes for $line1[0] , h1 !\n";
			}
			$read_hash{$line1[0]}{h1}=$line1[1];
		}
	}
	close(FILEA);
	
	open(FILEB,"<$h2_file") || die "Can't open $h2_file for $id1 , $chr1 !\n";
	while(<FILEB>) {
		chomp;
		next if /^_/;
		my @line2=split(/\s+/,$_);
		if ( $line2[1] != 0 ) {
			if ( defined $read_hash{$line2[0]}{h2} ) {
				die "have read counts on two chromosomes for $line2[0] , h2 !\n";
			}
			$read_hash{$line2[0]}{h2}=$line2[1];
		}
	}
	close(FILEB);
     system("rm $bamfile_h1 $bamfile_h2");
	print STDOUT "All jobs for $chr1 , $id1 is done!\n";
}

open(OUTA,">$out_file") || die "Can't write down output file for $id1 !\n";
for my $k1 (sort keys %read_hash) {
	if ( !defined $read_hash{$k1}{h1} && defined $read_hash{$k1}{h2} ) {
		$read_hash{$k1}{h1}=0;
	} elsif ( !defined $read_hash{$k1}{h2} && defined $read_hash{$k1}{h1} ) {
		$read_hash{$k1}{h2}=0;
	}
		
	$read_hash{$k1}{total}=$read_hash{$k1}{h1}+$read_hash{$k1}{h2};
	print OUTA "$k1\t$read_hash{$k1}{h1}\t$read_hash{$k1}{h2}\t$read_hash{$k1}{total}\n";		
}
close(OUTA);

system("rm temp_$id1.$chr1\_hap*.bam temp_counts.$id1.$chr1.h*");

print STDOUT "All jobs for $id1 is done!\n";
