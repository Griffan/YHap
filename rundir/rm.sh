#!/bin/bash

#set -beEux -o pipefail

#make sure we are at YHap/rundir prior to running this script
vcf=$1
dataAlias=$2

filename=$(basename "$vcf")

#if [ "${vcf:0:1}" = "/" ];then
#	echo "
#	ln -s $vcf
#	sh ../../convertVCF.sh ${vcf##*/} Y
#	"|sh
#else
#	echo "
#	ln -s ../$vcf
#	sh ../../convertVCF.sh ${vcf##*/} Y
#	"|sh
#fi


filename=$(basename "$vcf")
extension=$([[ "$filename" = *.* ]] && echo ".${filename##*.}" || echo '')
vcfout="${filename%.*}"
#vcfout=$filename

#mv $vcfout ../../data/
echo "Make sure your are at YHap/rundir/
      If you want to clean newly generated data, type:"
echo "rm -r ../data/$vcfout"
echo "rm -r  $dataAlias"

