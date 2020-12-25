#!/usr/bin/python3

import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('-b', type=str, required=True, help='barcode')
parser.add_argument('-d', type=str, required=True, help='dataset')
parser.add_argument('-q', type=str, required=True, help='read1')
parser.add_argument('-p', type=str, required=True, help='read2')
parser.add_argument('-r', type=str, required=True, help='reference')

args = parser.parse_args()

barcodes = args.b.split(",")
datasets = args.d.split(",")
read1 = args.q.split(",")
read2 = args.p.split(",")
ref = args.r

print(barcodes)
print(datasets)
print(read1)
print(read2)
print(ref)

def basename(name):
    if name.rfind('/') == -1:
        name = name
    else:
        name = name[name.rfind('/')+1:]
    return name

ref = basename(ref)

f = open("sample.csv", "w")
f.write("Barcode,Dataset,File1,File2\n")
for i in range(len(barcodes)):
    r1 = basename(read1[i])
    r2 = basename(read2[i])
    f.write(','.join([barcodes[i], datasets[i], r1, r2]))
    f.write('\n')
f.close()

import subprocess

batcmd="sed 's/@reference/"+ ref + "/g' /IHEC_standard_template.conf"
result = subprocess.check_output(batcmd, shell=True)
f = open("IHEC_standard_instance.conf", "w")
encoding = 'utf-8'
content = str(result, encoding)
f.write(content)
f.close()
