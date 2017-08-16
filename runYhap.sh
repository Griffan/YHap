set -beEx -o pipefail
mem=3900m

pop=$1
model=$2

##LOCATION OF LIB AND BASE
base=$(pwd)/../../data/
export LIB=$(pwd)/../../lib/    ##location of javalib 

defi=$(echo $plot | wc -c)
#echo "DEF " $defi
if [ $defi -le 1 ]
then
plot=0
fi




ls $LIB>lib_${pop}_list
while read line; do
class=$class:"$LIB/$line"
done < lib_${pop}_list
rm lib_${pop}_list



plot=0

echo $class

line="java -Xmx$mem  -server -cp $class lc1.dp.appl.CNVHap --baseDir $base --paramFile param.txt --plot $plot --numIt 1 --include YCC_build37:$pop  --useDataAsModel \"$model\" --experiment newres_${pop}"
echo $line
$line
