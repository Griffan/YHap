#!/bin/bash

set -beEux -o pipefail

#make sure we are at YHap/rundir prior to running this script
vcf=$1
dataAlias=$2
mkdir $dataAlias
cd $dataAlias
filename=$(basename "$vcf")

if [ "${vcf:0:1}" = "/" ];then
	echo "
	ln -s $vcf
	sh ../../convertVCF.sh ${vcf##*/} Y
	"|sh
else
	echo "
	ln -s ../$vcf
	sh ../../convertVCF.sh ${vcf##*/} Y
	"|sh
fi


filename=$(basename "$vcf")
extension=$([[ "$filename" = *.* ]] && echo ".${filename##*.}" || echo '')
vcfout="${filename%.*}"
#vcfout=$filename

mv $vcfout ../../data/
vcfDirLoc="$vcfout"

echo "
perl ../prepare.dataset.pl $vcfDirLoc $dataAlias >data.csv
cp ../param.txt param.txt
cp ../split.txt split.txt
nohup perl ../autorun.advanced.pl ${dataAlias} newres_${dataAlias}_1_Y_0_25mb/mostLikelyState/${dataAlias}.txt
"|sh
