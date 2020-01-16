#!/usr/bin/python3

from sys import argv
import numpy as np
import re

def read_results(name, block_size=None):
    """
    read_results(<file name>) will read a results file as generated by
    'run_benchmark.sh' and return two objects, num and ops.

    If type(ops) == type(None) something went terribly wrong.

    If type(num) == type(None) the list of key=value pair counts wasn't equal
    for each package listed in <file name>. If that's the case ops will be a
    dictionary which contains a list of two lists for each key, the first list
    being the numbers of key=value pairs, the second the number of operations
    needed.

    If type(num) != type(None) num is an np.array of the numbers of key=value
    pairs for each package listed in <file name>. Also ops is a dictionary
    containing only the operation counts for each package as np.array.
    """
    num_line = re.compile("^Number of Keys: (\d+)$")
    pkg_line = re.compile("^=== Benchmarking (.*) ===$")
    ops_line = re.compile("^\d\S* seconds \((\d\S*) ops\)$")
    data = {}
    with open(name, 'r') as fp:
        while True:
            line = fp.readline()
            if line == '': break
            elif None != (match := num_line.match(line)):
                try:
                    num = int(match.group(1))
                except:
                    raise ValueError("Could not convert" + match.group(1))
            elif None != (match := pkg_line.match(line)):
                pkg = match.group(1)
            elif None != (match := ops_line.match(line)):
                if pkg not in data: data[pkg] = [[],[]]
                data[pkg][0].append(num)
                try:
                    data[pkg][1].append(float(match.group(1)))
                except:
                    raise ValueError("Could not convert" + match.group(1))
        data_keys = iter(data)
        num = data[next(data_keys)][0]
        for i in data_keys:
            if num != data[i][0]: return None, data
        num = np.array(num)
        ops = {}
        for i in data:
            ops[i] = np.array(data[i][1])
        return num, ops
    return None, None

def print_polycoeffs(num, ops):
    print("  degree=1", np.polyfit(num, ops, 1))
    p2 = np.polyfit(num, ops, 2)
    print("  degree=2", p2)
    print("  p2/p1   ", p2[0]/p2[1])

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage:", argv[0], "<filename>")
        quit(1)
    num, ops = read_results(argv[1])
    if type(ops) == type(None):
        print("Something bad happened")
        quit(2)
    if type(num) == type(None):
        for i in ops:
            print(i)
            print_polycoeffs(ops[i][0], ops[i][1])
    else:
        for i in ops:
            print(i)
            print_polycoeffs(num, ops[i])
