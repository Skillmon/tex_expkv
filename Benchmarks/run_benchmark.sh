#!/bin/zsh

## settings for this script
local results="benchmark_results.txt"
local tmp="benchmark_tmp"

## settings for benchmarks.tex
# target time of a single \benchmark:n
local target=1
# number of \benchmark:n calls per package
local repetitions=30

local predefs="\\def\\keytgt{$target}\\def\\keyrep{$repetitions}"
predefs+="\\newif\\ifbenchmark\\benchmarktrue"

function backup () {
}

function run_single () {
    local keyarg=" height = 6 "
    for (( j=2; j<=$1; j++ )); do
        keyarg+=", height = 6 "
    done
    pdflatex -jobname=$tmp \
        "$predefs\\def\\keyarg{$keyarg}\\input{benchmarks.tex}"
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

echo "\n\n\n### Results ###"
python3 read_results.py $results

rm expkv.sty expkv.tex expkv.log
rm $tmp.*
