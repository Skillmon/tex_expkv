#!/bin/zsh

## settings for this script
local results="benchmark_results.txt"
local tmp="benchmark_tmp"
local versions="benchmark_filelist.txt"

## settings for benchmarks.tex
# target time of a single \benchmark:n
local target=1
# number of \benchmark:n calls per package
local repetitions=30

local predefs="\\def\\keytgt{$target}\\def\\keyrep{$repetitions}"
local benchtrue="\\newif\\ifbenchmark\\benchmarktrue"
local benchfalse="\\newif\\ifbenchmark"

function backup () {
}

function run_single () {
    local keyarg=" height = 6 "
    for (( j=2; j<=$1; j++ )); do
        keyarg+=", height = 6 "
    done
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

for (( i=1; i<=20; i++ )); do
    run_single $i
done

pdflatex -jobname=$tmp \
    "$predefs$benchfalse\\listfiles\\input{benchmarks.tex}"
local line_start=$(grep -m1 -n -x ' \*File List\*' $tmp.log | cut -d: -f1)
local line_end=$(grep -m1 -n -x ' \*\*\*\*\*\*\*\*\*\*\*' $tmp.log | cut -d: -f1)
sed -n "$line_start,$line_end p" $tmp.log > $versions

echo "\n\n\n### Results ###"
python3 read_results.py $results

rm expkv.sty expkv.tex expkv.log
rm $tmp.*
