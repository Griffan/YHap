set -beEx -o pipefail
##LOCATION OF LIB AND BASE
base=$(pwd)/../../data/
export LIB=$(pwd)/../../lib/    ##location of javalib 

filenamePrefix=$1
chr=$2
build="build37"
maxN=10000000
step=1
mem=900m

#HCC1143 build37  8 100000:1

defi=$(echo $plot | wc -c)
#echo "DEF " $defi
if [ $defi -le 1 ]
then
plot=0
fi




ls $LIB>lib_list
while read line; do
class=$class:"$LIB/$line"
done < lib_list
rm lib_list



plot=0

#echo $class

line="java -Xmx$mem -jar $LIB/ConvertVCFToZip.jar $filenamePrefix $build  $chr $maxN:$step"
#echo $line
$line

