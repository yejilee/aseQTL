args=commandArgs(TRUE)
gene1=args[1]
file1=args[2]
file2=args[3]

temp_ase=read.table(file1,header=T)
snp_list=unique(temp_ase$SNP_POS)

output_mat1=data.frame(matrix(rep(NA,5*length(snp_list)),ncol=5))
colnames(output_mat1)=c("GENE","SNP","BETA","SE","NUM_INDIV")
output_mat1$GENE=rep(gene1,length(snp_list))

for (i in 1:length(snp_list)) {
	snp1=snp_list[i]
	temp_snp=temp_ase[temp_ase$SNP_POS==snp1,]
	if (dim(temp_snp)[1]==0) {
		print(paste0("no aseQTL results for ",snp1,"!"))
		next
	} else {
		temp_snp$wi=1/((temp_snp$SE)^2)
		temp_se_total=sqrt(1/sum(temp_snp$wi))
		temp_snp$beta_wi=temp_snp$BETA*temp_snp$wi
		temp_beta_total=sum(temp_snp$beta_wi)/sum(temp_snp$wi)
	
		output_mat1$SNP[i]=snp1
		output_mat1$BETA[i]=temp_beta_total
		output_mat1$SE[i]=temp_se_total
		output_mat1$NUM_INDIV[i]=dim(temp_snp)[1]
	}
}

write.table(output_mat1,file2,row.names=F,quote=F)