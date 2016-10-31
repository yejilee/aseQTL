#!/usr/bin/perl -w

use strict;
use warnings;
use Storable;
use List::Util qw[min max];

my $gene1=$ARGV[0];
my $tss1=$ARGV[1];
my $cis1=$ARGV[2];


my $in_dir=$ARGV[3];
my $out_dir="beta_SNPs";

system("mkdir -p $out_dir");
system("grep $gene1 $in_dir/* > temp_$gene\_input");

my $s1=$tss1-$cis1;
my $s2=$tss1+$cis1;

my %tmp_result_hash;
LINE : for my $id1 (@id_list) {
    my $id2=$id1;   $id2 =~ s/M//;
	my $beta; my $se; my $total_read;
    my %tmp_hash;
    system("grep $gene1 $in_dir/$id1.txt > $out_dir/temp_$gene1\_$id1"); 
    if ( ! -z "$out_dir/temp_$gene1\_$id1") {
        print STDOUT "processing results for $id1 , $gene1 \n";
        open(FILEB,"<$out_dir/temp_$gene1\_$id1");
        while(<FILEB>) {
            chomp;
            my @line1=split(/\s+/,$_);
			$beta=$line1[7];
			$se=$line1[10];
			$total_read=$line1[4];
        }
        close(FILEB);
        
        open(FILEC,"</net/dumbo/home/yejilee/ASE/FUSION_f4/workdir/list_hetero/$chr1\_$id1\_list_hetero.txt");
        while(<FILEC>) {
            chomp;
            my @line2=split(/\s+/,$_);
            my $tmp_snpname=$chr2.":".$line2[1];	 $tmp_snpname =~ tr/ //ds;	
            if ( defined $snp_hash{$tmp_snpname} ) {
            
            
                if ($line2[2] eq $snp_hash{$tmp_snpname}{alt} && $line2[1]>=$s1 && $line2[1]<=$s2) {
                    $tmp_result_hash{$tmp_snpname}{$id1}{beta} = $beta ;
					$tmp_result_hash{$tmp_snpname}{$id1}{se}=$se;
					$tmp_result_hash{$tmp_snpname}{$id1}{total_read}=$total_read;
                } elsif ($line2[2] eq $snp_hash{$tmp_snpname}{ref} && $line2[1]>=$s1 && $line2[1]<=$s2) {
                    $tmp_result_hash{$tmp_snpname}{$id1}{beta} = -1*$beta;
					$tmp_result_hash{$tmp_snpname}{$id1}{se}=$se;
					$tmp_result_hash{$tmp_snpname}{$id1}{total_read}=$total_read;
                } else {
                    die "ref and alt is not matching for $id1 , $tmp_snpname !\n";
                }
            }
            }
            close(FILEC);
				
    } else {
        print STDOUT "no results from $id1 !\n";
    }
    system("rm $out_dir/temp_$gene1\_$id1");
}

open(OUTA,">$out_dir/beta_$gene1.txt");
for my $k3 (sort keys %tmp_result_hash) {
    for my $k4 (sort keys %{$tmp_result_hash{$k3}}) {

        print OUTA "$gene1\_$k3\t$k4\_$group_list{$k4}\t$tmp_result_hash{$k3}{$k4}{beta}\t$tmp_result_hash{$k3}{$k4}{se}\n";
    }
}
close(OUTA);

my $count1=`wc -l $out_dir/beta_$gene1.txt | cut -f1 -d' ' `;
my $count2=`cut -f2 $out_dir/beta_$gene1.txt | sort | uniq | wc -l | cut -f1 -d' ' `;
$count1 =~ tr / //ds; $count1=$count1+0;
$count2 =~ tr / //ds; $count2=$count2+0;
print STDOUT "$count1\t$count2\n";
if ($count1 == 0) {
	system("rm $out_dir/beta_$gene1.txt");
	print STDOUT "no results for $gene1! \n";
}

system("rm temp_$gene\_input");
print STDOUT "All jobs for $gene1 has been done! \n";
