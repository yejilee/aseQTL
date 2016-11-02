## Pipeline for estimating allele-specific expression QTL (eQTL)


### 1 : Input file
#### Expression data : sorted BAM format, separated by each individual. We assume that these files have been through comprehensive quality control steps.
#### Genotype data : VCF format with phasing information. Like expression data, We also assume that these files have been passed quality controls.

### 2 : Generating files having the list of heterozygous SNPs for each individual
We use a R program provided by asSeq (http://www.bios.unc.edu/~weisun/software/asSeq.htm) to specify haplotype-specific reads, which requires specific-format of list of heterozygous SNPs for each chromosome of each individual. 
Requiring format (example):
```
			chr1 1000000 A G
			chr1 1000340 T C
			chr1 1000453 A T
```

Files with the above format can be generated using (s2_generating_hetero_genotype.pl). As inputs on a command line, provide two arguments in the following orders : the location of compressed vcf file , tags for output files (ex. tag1). The output files (separated by each individual) are saved at "list_hetero" directory, in the name of tag1.ID .


### 3 : Generating haplotype-specific BAM files
For each BAM file and the corresponding genotype file generated from step 2, it is possible to separate haplotype-specific reads into 2 BAM files, using extractAsReads function provided from asSeq.

sample command (R)	
```
library(asSeq)
library(isoform)
sampleID="ID01"; chromo="chr1"
bamfile=paste0("bam_",chromo,"_",sampleID,".bam")
system(paste0("grep ",chromo," list_hetero/tag1.",sampleID," > temp.",sampleID,".",chromo))
snplist_file=paste0(temp.",sampleID,".",chromo);
extractAsReads(input=bamfile,snpList=snplist_file,outputTag=paste0("tag2.",sampleID,".",chromo))
```
Output files are saved in the current directory (you can assign the new directory by putting its patth in "tag2" part) in the name of "tag2.sampleID.chromo_hap1.bam" and "tag2.sampleID.chromo_hap2.bam".


### 4 : Counting number of reads for haplotype-specific BAM files
If you already have set-up pipeline, you can use that to count the reads.
For example, if you use htseq-count (http://www-huber.embl.de/users/anders/HTSeq/doc/count.html) , you can utilize the sample code I put in (s4_assemble_reads.pl)
For the next step, the required file format is as follows (4 columns):
```		
		Genename read_count_from_hap1 read_count_from_hap2 total_read_count
```

### 5 : Estimating the effect sizes of aseQTL for each gene at individual level
You can use the R code (s5_get_beta.R) to estimate the effect size of aseQTL at individual level.
Example of the command line would be like this :
```
Rscript s5_get_beta.R sampleID read_count_file output_file_name
```
s5_get_beta.R and ASE_indiv.R files are should be on the same directory.

### 6 : Estimating the effect size of aseQTL across individuals
Perl script (s6_beta_to_SNP.pl) will help you to estimate the effect size of aseQTL across individuals. This script requires the perl hash files generated from s1_generating_hetero_genotype.pl and R script meta.R to be in the same directory.

Input command would be something like this :
```
perl s6_beta_to_SNP.pl GENE1 1 1300000 directory_having_output_from_step5
```

Note : Fixed-effect meta analysis based on inverse-variance weights will be performed, so if you does not want this approach, you can delete the following part from the perl script.

```
system("Rscript meta.R $gene1 $out_dir/beta_$gene1.txt $out_dir/aseQTL_$gene1.txt");
```





