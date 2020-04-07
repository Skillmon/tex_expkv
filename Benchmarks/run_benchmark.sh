#!/bin/zsh

## settings for this script
local results="benchmark_results.txt"
local tmp="benchmark_tmp"
local versions="benchmark_filelist.txt"
# step from $keys_start to $keys_end for number of keys
local keys_start=1
local keys_end=20
# space separated list of additional numbers of keys
local keys_additional=(0 100)

## settings for the python script, leave blank to not use the feature. You have
## to set both if you want to use it.
# interpolate only on values with a bigger key-val pair count 
local num_min=1
# interpolate only on values with a smaller key-val pair count 
local num_max=20

## settings for benchmarks.tex
# target time of a single \benchmark:n
local target="1"
# number of \benchmark:n calls per package
local repetitions=10
# target time for the \benchmark:n call that only serves to get the CPU hot
local preheat="0"

local predefs="\\def\\keypre{$preheat}"
      predefs+="\\def\\keytgt{$target}"
      predefs+="\\def\\keyrep{$repetitions}"
local benchtrue="\\newif\\ifbenchmark\\benchmarktrue"
local benchfalse="\\newif\\ifbenchmark"

function run_single () {
    if [[ $1 == 0 ]]; then
        local keyarg=""
    else
        local keyarg=" height = 6 "
        for (( j=2; j<=$1; j++ )); do
            keyarg+=", height = 6 "
        done
    fi
    pdflatex -jobname=$tmp \
        "$predefs$benchtrue\\def\\keyarg{$keyarg}\\input{benchmarks.tex}"
    echo "Number of Keys: $1" >> $results
    grep -A$repetitions '^=== Benchmarking' $tmp.log >> $results
}

## back up the old results
mv $results $results.$(date +%y-%m-%d_%H:%M:%S).bak

cp ../expkv.dtx .
pdftex expkv.dtx
rm expkv.dtx

for (( i=$keys_start; i<=$keys_end; i++ )); do
    run_single $i
done
for i in $keys_additional; do
    run_single $i
done

pdflatex -jobname=$tmp \
    "$predefs$benchfalse\\listfiles\\input{benchmarks.tex}"
local line_start=$(grep -m1 -n -x ' \*File List\*' $tmp.log | cut -d: -f1)
local line_end=$(grep -m1 -n -x ' \*\*\*\*\*\*\*\*\*\*\*' $tmp.log | cut -d: -f1)
sed -n "$line_start,$line_end p" $tmp.log > $versions

echo "\n\n\n### Results ###"
if [[ -n $num_min && -n $num_max ]];then
    python3 read_results.py $results $num_min $num_max
else
    python3 read_results.py $results
fi

rm expkv.sty expkv.tex expkv.log
rm $tmp.*
