#!/usr/bin/perl -w

use strict;
use warnings;


	# first : aggregate ASE data to each individual

	# my @fold_vec=(1,1.1,1.2,1.3,1.4,1.5,1.6,1.7);
	# my @maf_vec=(0.02,0.05,0.1,0.15,0.2,0.25);
		# # # my @fold_vec=(1); my @maf_vec=(0.05);
# for my $maf1 (@maf_vec) {
# for my $fold1 (@fold_vec) {	

	# system("mkdir -p /net/dumbo/home/yejilee/ASE/simulation_new/data_indiv/fold_$fold1/maf_$maf1");
	# system("head -1 /net/dumbo/home/yejilee/ASE/simulation_new/data/fold_$fold1/maf_$maf1/GENE1.txt > /net/dumbo/home/yejilee/ASE/simulation_new/data/fold_$fold1/maf_$maf1/temp_head");
	# system("cat /net/dumbo/home/yejilee/ASE/simulation_new/data/fold_$fold1/maf_$maf1/GENE*.txt | grep -v total | cat /net/dumbo/home/yejilee/ASE/simulation_new/data/fold_$fold1/maf_$maf1/temp_head - > /net/dumbo/home/yejilee/ASE/simulation_new/data/fold_$fold1/maf_$maf1/all_data.txt");
	# system("rm /net/dumbo/home/yejilee/ASE/simulation_new/data/fold_$fold1/maf_$maf1/temp_head");
	# for (my $i1=1; $i1<=100; $i1++) {
		# my $id1="ID".$i1;
		# system("grep -w $id1 /net/dumbo/home/yejilee/ASE/simulation_new/data/fold_$fold1/maf_$maf1/all_data.txt > /net/dumbo/home/yejilee/ASE/simulation_new/data_indiv/fold_$fold1/maf_$maf1/$id1.txt");
	 # }
# }
# }


	# # my @try_vec=(1..25);
	# my @try_vec=(1..8);
	# for my $try_n (@try_vec) {
	
			# system("mkdir -p /net/dumbo/home/yejilee/ASE/simulation_new/data_indiv/mixed/set_$try_n");
				# system("head -1 /net/dumbo/home/yejilee/ASE/simulation_new/data/mixed/set_$try_n/GENE1.txt > /net/dumbo/home/yejilee/ASE/simulation_new/data/mixed/temp_head");
				# system("cat /net/dumbo/home/yejilee/ASE/simulation_new/data/mixed/set_$try_n/GENE*.txt | grep -v total | cat /net/dumbo/home/yejilee/ASE/simulation_new/data/mixed/temp_head - > /net/dumbo/home/yejilee/ASE/simulation_new/data/mixed/set_$try_n/all_data.txt");
				# for (my $i1=1; $i1<=100; $i1++) {
					# my $id1="ID".$i1;
					# system("grep -w $id1 /net/dumbo/home/yejilee/ASE/simulation_new/data/mixed/set_$try_n/all_data.txt > /net/dumbo/home/yejilee/ASE/simulation_new/data_indiv/mixed/set_$try_n/$id1.txt");
				# }
				# system("rm /net/dumbo/home/yejilee/ASE/simulation_new/data/mixed/temp_head");
				 
	# }
	 
# # # # # second : aggregate ASE results to each gene

 # for my $maf1 (@maf_vec) {
 # for my $fold1 (@fold_vec) {	

		# # ### delete later !!!
	# # system("mv /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$fold1/maf_$maf1/all_results.txt /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/old_20160202/all_results_$fold1\_$maf1.txt");

# #system("mkdir -p /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_gene/fold_$fold1/maf_$maf1");
# system("head -1 /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$fold1/maf_$maf1/ID1.txt > /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$fold1/maf_$maf1/temp_head");
# system("cat /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$fold1/maf_$maf1/ID*.txt | grep -v total | cat /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$fold1/maf_$maf1/temp_head - > /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$fold1/maf_$maf1/all_results.txt");
# system("rm /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$fold1/maf_$maf1/temp_head");
# }
# }
# # for (my $i1=1; $i1<=10000; $i1++) {
	# # my $gene1="GENE".$i1;
	# # system("grep -w $gene1 /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/all_results.txt > /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_gene/$gene1.txt");
# # }

	my @try_vec=(1..8);
	for my $try_n (@try_vec) {
		 system("head -1 /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/mixed/set_$try_n/ID1.txt > /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/mixed/temp_head");
		system("cat /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/mixed/set_$try_n/ID*.txt | grep -v total | cat /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/mixed/temp_head - > /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/mixed/set_$try_n/all_results.txt");
		system("rm /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/mixed/temp_head");
		}