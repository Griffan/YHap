rundir/ is the directory for running the program
lib/ contains the java libraries
data/ contains the data directories

##RUNNING PROGRAM FOR FIRST TIME#########

To run the program go into the rundir/ directory and type:

../runYhap.sh
(you may need to make this executable first)


The results will appear in a new directory

newres_1_Y_0_25mb/mostLikelyState

in which you will find the files:

YCC_i_6.txt
CHBYhapmap_i_4_i_[POP, CHB].txt
CHBY_i_4_i_[POP, CHB].txt 

which contain the allocation of samples to haplogroups.


#####MODIFYING THE PARAMETERS#############

 The parameters are contained in
 three files in rundir/ Most of the parameters you should not
 modify.  

split.txt : this contains the co-ordinates of the region to include in the analysis

data.csv : this contains information on the different data
 sources, with one column per data source.  The name of the data
 source is contained in the first row.  The location of the data 
is specified in the third row, relative to the data directory 
(data/).  The only other row relevant is the 'phenoToInclude' row
which specifies which samples to include in the analysis.  
I.e. for CEUY, phenoToInclude is set to POP~CEU.  This is
 decoded via reference to the pheno.txt file in the relevant 
data directory.  In this way, CEUY, CHBY etc share a common data 
directory, but the pheno.txt file is used to extract sub-sets of
this file at run-time.

param.txt : This is the master parameter file, and specifies
which data sources to include from data.csv, via the --include 
option.  The --useDataAsModel option is used to specify which 
haplogroups to include in the analysis.

#####MAKING NEW DATA FILES FROM .vcf files#####

- Put the vcf file in the vcf/ directory
- Change into this directory and type

../convertVCF.sh $filename $chr

where filename is the name of the file you wish to convert, and chr is
the chromosome in the chromosome column of the vcf (Y in this case).
