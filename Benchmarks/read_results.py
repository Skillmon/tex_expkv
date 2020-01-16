#!/usr/bin/python3

from sys import argv
import numpy as np
import re

def read_results(name, block_size=None):
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

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage:", argv[0], "<filename>")
        quit(1)
    num, ops = read_results(argv[1])
    if ops == None:
        print("Some bad error happened")
        quit(2)
    if num == None:
        for i in ops:
            print(i)
            print("  grad=1", np.polyfit(ops[i][0], ops[i][1], 1))
            print("  grad=2", np.polyfit(ops[i][0], ops[i][1], 2))
    else:
        for i in ops:
            print(i)
            print("  grad=1", np.polyfit(num, ops[i], 1))
            print("  grad=2", np.polyfit(num, ops[i], 2))
