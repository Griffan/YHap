# YHap


YHap is a tool to automatically assign haplogroup label to male human sample based on genotype data on Y chromosome.


* _Motivation_: Y haplogroup analyses are an important component of genealogical reconstruction, population genetic analyses, medical genetics and forensics. These fields are increasingly moving towards use of low-coverage, high throughput sequencing. While there have been methods recently proposed for assignment of Y haplogroups on the basis of high-coverage sequence data, assignment on the basis of low-coverage data remains challenging.


* _Results_: We developed a new algorithm, YHap, which uses an imputation framework to jointly predict Y chromosome genotypes and assign Y haplogroups using low coverage population sequence data. We use data from the 1000 genomes project to demonstrate that YHap provides accurate Y haplogroup assignment with less than 2x coverage. This method also is suitable for certain marker set based chip dataset.


* _Citation_: Zhang F, Chen R, Liu D, Yao X, Li G, Jin Y, et al. YHap: a population model for probabilistic assignment of Y haplogroups from re-sequencing data. BMC Bioinformatics [Internet]. 2013;14:331. Available from: http://www.ncbi.nlm.nih.gov/pubmed/24252171




* Input File: VCF format genotype file




## Installation


Download or git clone the repo:
```
git clone https://github.com/Griffan/YHap.git
cd YHap/rundir/
```
## Guide for beginners


There is a one stop running script:


```
sh prepare.data.and.run.sh VCFFilePath dataAlias
```
 
After the whole process done, you would find your result in 
 
```
YHap/rundir/dataAlias/YHap.assignment.dataAlias.txt
```
 
The format for YHap.assignment.dataAlias.txt is:
 
```
SampleID        Haplogroup
```


In case you have prepared data using "prepare.data.and.run.sh", and you want to rerun:
```
sh run.sh VCFFilePath dataAlias
```


In case you want to clean all these newly generated files, you can do:
```
sh rm.sh VCFFilePath dataAlias
```
following the prompt, if you are sure, you can delete them safely.


## For more advanced users
If you want to run YHap step by step:
rundir/ is the directory for running the program
lib/ contains the java libraries
data/ contains the data directories
Please also refer to run.sh in rundir/, especially 
```
echo "
perl ../prepare.dataset.pl $vcfDirLoc $dataAlias >data.csv
cp ../param.txt param.txt
cp ../split.txt split.txt
nohup perl ../autorun.advanced.pl ${dataAlias} newres_${dataAlias}_1_Y_0_25mb/mostLikelyState/${dataAlias}.txt
"|sh
```
to ease the cumbersome of generating data.csv file.


**RUNNING PROGRAM FOR FIRST TIME**


To run the program go into the rundir/test/ directory and type:
```
sh ../../singleStepRun.sh
```
##### _(you may need to make this executable first, and this script could be a template for customized purpose)_


The results will appear in a new directory
```
newres_1_Y_0_25mb/mostLikelyState
```
in which you will find the files:
```
YCC.txt
CHBYhapmap.txt
```
which contain the allocation of samples to haplogroups.




**MODIFYING THE PARAMETERS**


The parameters are contained in three files in rundir //_but most of the parameters you should not modify_ 


split.txt : This contains the coordinates of the region to include in the analysis


data.csv : 
This contains information on the different data sources, with one column per data source.  
- The name of the data source is contained in the first row.  
- The location of the data is specified in the third row, relative to the data directory (data/).  
- The only other row relevant is the 'phenoToInclude' row which specifies which samples to include in the analysis.  i.e. for CEUY, phenoToInclude is set to POP~CEU.  This is decoded via reference to the pheno.txt file in the relevant data directory.  In this way, CEUY, CHBY etc share a common data directory, but the pheno.txt file is used to extract subsets of
this file at run-time.


param.txt : This is the master parameter file, and specifies which data sources to include from data.csv, via the --include option.  The --useDataAsModel option is used to specify which haplogroups to include in the analysis. These parameters could also be specified via direct cmdline when using java -jar command.


**MAKING NEW DATA FILES FROM VCF FILES**


- Put the vcf file in the YHap/vcf/ directory
- Change into this directory and type
```
sh ../convertVCF.sh $filename $chr
```
where filename is the name of the file you wish to convert, and chr is
the chromosome in the chromosome column of the vcf (Y in this case).
After conversion, move the whole directory to YHap/data directory
```
cd YHap/
mv vcf data/
```
Notice that when specifying data.csv, the location should be adjusted accordingly. e.g. (in this case vcf/)


**MAKING NEW TREE FILES FROM YCC SNP INDEX**
- Prepare SNP index file, with the format being:
```
chr start_bp end_bp snpID rsID haplogroup ancestral_allele derived_allele is_ref_eq_ancestral
```
- Put the vcf file in the YHap/SNPIndex/ directory
- Change into this directory and type
```
sh ../convertYCCSNPindex.sh $outputPrefix $SNPIndex.tree.txt ../data/YCC_build37/tree.txt
```
where outputPrefix is the prefix of the name of generated zip file
After conversion, move the whole directory to YHap/data directory
```
cd ..
mv $outputPrefix.zip data/YCC_build37/Y.zip
```
Notice that when specifying data.csv, the location should be adjusted accordingly. Here I assume you replace the build37 version, you can also move $outputPrefix.zip to a different directory under data/, but you need to modify data location direcotry in data.csv accordingly.
## Contributing


1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D


## Bug Report


fanzhang@umich.edu

## LICENSE

The full YHap package is distributed under LGPL License.

