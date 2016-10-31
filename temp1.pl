#!/usr/bin/perl -w

use strict;
use warnings;

# my @maf_vec=(0.02,0.05,0.1,0.15,0.2,0.25);
# my @fold_vec=(1,1.1,1.2,1.3,1.4,1.5,1.6,1.7);

# # open(OUTA,">generate_data.txt");
# # for my $maf1 (@maf_vec) {
	# # print OUTA "Rscript /net/dumbo/home/yejilee/ASE/simulation_new/codes/generate_data_3.R $maf1\n";
# # }
# # close(OUTA);

# # open(OUTA,">running_ASE.txt");
# # for my $maf1 (@maf_vec) {
# # for (my $i1=1; $i1<=100; $i1++) {
	# # print OUTA "Rscript /net/dumbo/home/yejilee/ASE/simulation_new/codes/running_ASE.R $i1 $maf1\n";
# # }
# # }
# # close(OUTA);


# # open(OUTA,">running_eQTL.txt");
# # for my $maf1 (@maf_vec) {
# # for my $fold1 (@fold_vec) {
	# # print OUTA "Rscript /net/dumbo/home/yejilee/ASE/simulation_new/codes/running_eQTL.R $fold1 $maf1\n";
# # }
# # }
# # close(OUTA);

# # open(OUTA,">meta.txt");
# # for my $maf1 (@maf_vec) {
	# # print OUTA "Rscript /net/dumbo/home/yejilee/ASE/simulation_new/codes/meta.R $maf1\n";
# # }
# # close(OUTA);

# for my $m1 (@maf_vec) {
	# for my $f1 (@fold_vec) {
		# system("cut -f2,7 -d' ' /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/fold_$f1/maf_$m1/all_results.txt | sort | uniq > /net/dumbo/home/yejilee/ASE/simulation_new/results_ASE_indiv/theta_$f1\_$m1.txt");
	# }
# }

my @vec1=(1..100);

open(OUTA,">logs_ASE/jobs_ASE_rare.txt");
for my $t1 (@vec1) {
	#print OUTA "Rscript /net/dumbo/home/yejilee/ASE/simulation_new/codes/running_eQTL_mixed_glm.nb.R $t1 > logs_glm.nb_$t1\n";
	print OUTA "Rscript /net/dumbo/home/yejilee/ASE/simulation_new/codes/running_ASE_mixed.R $t1 > logs_ASE_rare_$t1\n";
}
close(OUTA);