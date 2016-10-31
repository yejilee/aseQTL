### columns of data0
### ID gene genotype h1 total
library(methods);
library(stats4);
library(stats);

fac_to_char=function(x) {
	if (is.factor(x)) {
		x=as.character(as.factor(x))
	}
	return(x)
}

fac_to_num=function(x) {
	if (is.factor(x)) {
		x=as.numeric(as.character(as.factor(x)))
	}
	return(x)
}

theta_ll=function(x,data1) {			
	pi1=0.5;
	attach(data1)
	ll1=0;
		for (i in 1:length(total)) {
			vec1=0:max(0,(h1[i]-1)) ;	
			vec2=0:max(0,(total[i]-h1[i]-1)) ; 
			vec3=1:(total[i]-1) ; 
			c1=log(pi1+vec1*x);
			c2=log(1-pi1+vec2*x);
			c3=log(1+vec3*x)
			ll1=ll1+sum(c1)+sum(c2)-sum(c3)
		}
	detach(data1)
	return(-ll1)
}


pi_ll=function(y,theta1,x=c(0,0)) {
	vec1=0:max(0,(x[1]-1)) ;
	vec2=0:max(0,(x[2]-x[1]-1)) ;
	vec3=1:(x[2]-1) ;
			
	c1=log(y+vec1*theta1);
	c2=log(1-y+vec2*theta1);
	c3=log(1+vec3*theta1)

	ll1=sum(c1)+sum(c2)-sum(c3)
	return(-ll1)
}

se_from_fisher=function(pi_est,theta1,x=c(0,0)) {
	vec1=0:max(0,(x[1]-1)) ;
	vec2=0:max(0,(x[2]-x[1]-1)) ;

	c1=-(1/(pi_est+vec1*theta1))^2;
	c2=-(1/(1-pi_est+vec2*theta1))^2;
	fi1=-(sum(c1)+sum(c2))
	se1=sqrt(1/(fi1*((pi_est)^2)*((1-pi_est)^2)))
	
	return(se1)
}

ASE_indiv=function(data_in,max_theta=10,alpha.level=0.05,theta_di=NA) {
	data1=data_in
	data1$ID=fac_to_char(data1$ID)
	data1$gene=fac_to_char(data1$gene)
	data1$h1=fac_to_num(data1$h1)
	data1$total=fac_to_num(data1$total)

	if ("genotype" %in% colnames(data1)) {
		data1$genotype=fac_to_num(data1$genotype)
		data1=data1[data1$total>5 & data1$genotype==1,]
	} else {
		data1=data1[data1$total>5,]
	}
	
	n_g=length(unique(data1$gene))
	thres_value=qchisq((1-alpha.level),1)/2
	
	if (is.na(theta_di)) {
		theta_mle0=optimize(theta_ll,interval=c(0,max_theta))
		theta_est0=theta_mle0$minimum
	} else {
		theta_est0=theta_di
	}
	data1$theta_0=rep(theta_est0,dim(data1)[1])

	mle_list=apply(data1[,c("h1","total")],1,function(x) mle(pi_ll,start=list(y=0.5),fixed=list(theta1=theta_est0,x=x),lower=0.0000001,upper=0.999999,method="L-BFGS-B"))
	

	data1$pi_est=as.vector(sapply(mle_list,function(x) coef(x)[1]))
	data1$beta=log(data1$pi_est/(1-data1$pi_est))
	
	chisq_list=apply(data1[,c("h1","total","pi_est")],1,function(x) -2*(pi_ll(y=x[3],theta1=theta_est0,x=c(x[1],x[2]))-pi_ll(y=0.5,theta1=theta_est0,x=c(x[1],x[2]))))

	data1$ll_test=sapply(chisq_list,function(x) 1-pchisq(x,1))

	data1$min_nll=apply(data1[,c("h1","total","pi_est")],1,function(x) pi_ll(y=x[3],theta1=theta_est0,x=c(x[1],x[2])))

	data1$beta_se_fi=apply(data1[,c("h1","total","pi_est")],1,function(x) se_from_fisher(pi_est=x[3],theta1=theta_est0,x=c(x[1],x[2])))

	return(data1)
}