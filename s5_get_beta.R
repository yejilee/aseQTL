args=commandArgs(TRUE);
id1=args[1];
infile1=args[2];
outfile1=args[3];
source("ASE_indiv.R");
library(methods);
library(stats4);

counts=read.table(infile1,header=F);
colnames(counts)=c("gene","h1","h2","total");
data_full=counts[counts$total>5,]
data_full$ID=rep(id1,dim(data_full)[1]);
data_full=data_full[,c("gene","ID","h1","h2","total")];

	theta_mle=optimize(theta_ll,interval=c(1e-10,1.5),data1=data_full)
	theta_est=theta_mle$minimum

ASE_result=ASE_indiv(data_in=data_full,theta_di=theta_est)
write.table(ASE_result,outfile1,quote=F,row.names=F)