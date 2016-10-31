args=commandArgs(TRUE);
in_dir=args[1];

files=list.files(path=in_dir,pattern="*.txt",full.names=TRUE,recursive=FALSE)

	
lapply(files,function(x){
	name1=strsplit(x,split="[/_.]")[[1]][14]
	if (!file.exists(paste0("/net/dumbo/home/yejilee/ASE/FUSION_f4/workdir/results_201603/meta/combined_",name1,".txt"))) {
	out1=data.frame(gene=character(0),num_indiv=numeric(0),pi=numeric(0),beta=numeric(0),se=numeric(0),z=numeric(0),p=numeric(0))
	temp1=read.table(x,header=F)
	
	
	colnames(temp1)=c("gene","ID","beta","se")
	if ( is.factor(temp1$gene)) {
		temp1$gene=as.character(as.factor(temp1$gene))
	}
	
	gene_list=unique(temp1$gene)
	for (g1 in gene_list) {
		temp2=temp1[temp1$gene==g1,]
		temp2$wi=1/((temp2$se)^2)
		temp2$beta_wi=temp2$beta*temp2$wi
		temp_wi_sum=sum(temp2$wi)
		temp_se_total=sqrt(1/temp_wi_sum)
		temp_beta_total=sum(temp2$beta_wi)/temp_wi_sum
		temp_z=temp_beta_total/temp_se_total
		temp_p=2*(pnorm(-abs(temp_z)))
		temp_pi=exp(temp_beta_total)/(1+exp(temp_beta_total))
		
		out1=rbind(out1,cbind(g1,dim(temp2)[1],temp_pi,temp_beta_total,temp_se_total,temp_z,temp_p,deparse.level=0),deparse.level=0)
		
	}
	colnames(out1)=c("gene","num_indiv","pi","beta","se","z","p")
	write.table(out1,paste0("/net/dumbo/home/yejilee/ASE/FUSION_f4/workdir/results_201603/meta/combined_",name1,".txt"),row.names=F,quote=F)
	print(paste0("done for ",name1," !"))
	} else {
	print(paste0("already done for ",name1," !"))
	}
})

print("all jobs are done!")

### runnig temp1.pl first before running for ASE !!! ###

# #maf_array=c(0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.2,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.3,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.4,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.5);
# #theta_array=c("1e-04","5e-04","0.001","0.005","0.01","0.05","0.1","0.5");
# theta_array=c("1e-04","0.001","0.005","0.01","0.05","0.1","0.5");
# mix_array=c(0.7,0.8)
# #for (m1 in 1:length(maf_array)) {
	# #maf1=maf_array[m1];
	# #print(paste0("maf : ",maf1))
	# for (t1 in 1:length(theta_array)) {
	# theta1=theta_array[t1];
	# print(paste0("theta : ",theta1))
	# for (mix0 in 1:2) {
	# mix1=mix_array[mix0]
	# print(paste0("mix : ",mix1))
	
	# temp_ase=read.table(gzfile(paste0("/net/dumbo/home/yejilee/ASE/simul/beta_ASE_new/ase_",pi_1,"/all_",pi_1,"_",maf1,"_",theta1,"_",mix1,".txt.gz")),header=T)
	# temp_ase=temp_ase[temp_ase$theta_set==theta1,]
	# colnames(temp_ase)[6]="id"
	# if(is.factor(temp_ase$id)) {
		# temp_ase$id=as.character(as.factor(temp_ase$id))
	# }
	# if(is.factor(temp_ase$gene)) {
		# temp_ase$gene=as.character(as.factor(temp_ase$gene))
	# }
	# if(is.factor(temp_ase$genotype)) {
		# temp_ase$genotype=as.numeric(as.factor(temp_ase$genotype))
	# }
	
	# temp_ase_null=read.table(gzfile(paste0("/net/dumbo/home/yejilee/ASE/simul/beta_ASE_new/ase_0.5/all_",0.5,"_",maf1,"_",theta1,"_",mix1,".txt.gz")),header=T)
	# colnames(temp_ase_null)[6]="id"
	# if(is.factor(temp_ase_null$id)) {
		# temp_ase_null$id=as.character(as.factor(temp_ase_null$id))
	# }
	# if(is.factor(temp_ase_null$gene)) {
		# temp_ase_null$gene=as.character(as.factor(temp_ase_null$gene))
	# }
	# if(is.factor(temp_ase_null$genotype)) {
		# temp_ase_null$genotype=as.numeric(as.factor(temp_ase_null$genotype))
	# }
	
	# ### matrix to save meta-analysis results ###
	# output_mat1=data.frame(matrix(rep(NA,13*20000),ncol=13))
	    # #colnames(output_mat1)=c("gene","type","beta_set","maf_set","beta_ase","se_ase","z_ase","p_ase","q_ase","sig_fdr_ase")
    # colnames(output_mat1)=c("gene","type","pi_set","maf_set","theta_set","beta_ase","se_ase","z_ase","p_ase","q_ase","sig_fdr_ase")
	# output_mat1$type[1:10000]=rep("ASE",10000)
	# output_mat1$type[10001:20000]=rep("ASE_null",10000)
	# output_mat1$pi_set[1:10000]=rep(pi_1,10000)
	# output_mat1$pi_set[10001:20000]=rep(0.5,10000)
	# output_mat1$theta_set=rep(theta1,20000)
	# output_mat1$pi_fdr=rep(pi_1,20000)
	# output_mat1$mix_set=rep(mix1,20000)
	# output_mat1$maf_set=rep(maf1,20000)
	
	# #temp_ase_all=data.frame(rbind(temp_ase,temp_ase_null))
	
	# ### fixed-effect meta-analysis
	# for (g1 in 1:10000) {
		# gene1=paste0("GENE",g1)
		# #print(paste0("gene & ASE : ",gene1))
		# output_mat1$gene[g1]=gene1
		
		# temp_gene=temp_ase[temp_ase$gene==gene1,c("id","gene","beta","beta_se_pl")]
		# if (dim(temp_gene)[1]==0) {
			# print(paste0("no indiv for ",gene1," ASE!"))
			# next
		# } else {
			# temp_gene$wi=1/((temp_gene$beta_se_pl)^2)
			# temp_gene$beta_wi=temp_gene$beta*temp_gene$wi
			# temp_wi_sum=sum(temp_gene$wi)
			# temp_se_total=sqrt(1/temp_wi_sum)
			# temp_beta_total=sum(temp_gene$beta_wi)/temp_wi_sum
			# temp_z=temp_beta_total/temp_se_total
			# temp_p=2*(pnorm(-abs(temp_z)))
			
			# output_mat1$beta_ase[g1]=temp_beta_total
			# output_mat1$se_ase[g1]=temp_se_total
			# output_mat1$z_ase[g1]=temp_z
			# output_mat1$p_ase[g1]=temp_p	
            # #print(paste0(gene1," : ",output_mat1$p_ase[g1]))	
		# }
	# }
	
	# for (g1 in 1:10000) {
		# g2=g1+10000
		# gene1=paste0("GENE",g1)
		# #print(paste0("gene & ase_null: ",gene1))
		# output_mat1$gene[g2]=gene1
		
		# temp_gene=temp_ase_null[temp_ase_null$gene==gene1 ,c("id","gene","beta","beta_se_pl")]
		# if (dim(temp_gene)[1]==0) {
			# print(paste0("no indiv for ",gene1," ASE_null !"))
			# next
		# } else {
			# temp_gene$wi=1/((temp_gene$beta_se_pl)^2)
			# temp_gene$beta_wi=temp_gene$beta*temp_gene$wi
			# temp_wi_sum=sum(temp_gene$wi)
			# temp_se_total=sqrt(1/temp_wi_sum)
			# temp_beta_total=sum(temp_gene$beta_wi)/temp_wi_sum
			# temp_z=temp_beta_total/temp_se_total
			# temp_p=2*(pnorm(-abs(temp_z)))
			
			# output_mat1$beta_ase[g2]=temp_beta_total
			# output_mat1$se_ase[g2]=temp_se_total
			# output_mat1$z_ase[g2]=temp_z
			# output_mat1$p_ase[g2]=temp_p	
            # #print(paste0(gene1," : ",output_mat1$p_ase[g2]))	
		# }
	# }
	
	# ### fdr control
	# output_mat1=output_mat1[!is.na(output_mat1$p_ase),]
	# #print(paste0("min :",min(output_mat1$p_ase)))
	# #print(paste0("max :",max(output_mat1$p_ase)))
	# temp_qval=qvalue(output_mat1$p_ase,fdr.level=0.05)
	# output_mat1$q_ase=temp_qval$qvalues
	# output_mat1$sig_fdr_ase=temp_qval$significant
	# write.table(output_mat1,paste0("/net/dumbo/home/yejilee/ASE/simul/beta_ASE_new/ase_",pi_1,"/fdr_",pi_1,"_",maf1,"_",theta1,"_",mix1,".txt"),row.names=F,quote=F)
	# print(paste0("all jobs are done for ",maf1," , ",pi_1," , ",theta1," , ",mix1," !"))
	# }
	# }
# #}

# print(paste0("all jobs are done for ",pi_1,",",maf1," !"))
