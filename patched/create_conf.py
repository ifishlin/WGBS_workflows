#!/usr/bin/python3

import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('-b', type=str, required=True, help='barcode')
parser.add_argument('-d', type=str, required=True, help='dataset')
parser.add_argument('-q', type=str, required=True, help='read1')
parser.add_argument('-p', type=str, required=True, help='read2')
parser.add_argument('-r', type=str, required=True, help='reference')
parser.add_argument('--left_trim', type=int, default=5, required=False, help='IHEC left_trim default=5')
parser.add_argument('--right_trim', type=int, default=0, required=False, help='IHEC right_trim default=0')
parser.add_argument('--pbat', action='store_true')

args = parser.parse_args()

barcodes = args.b.split(",")
datasets = args.d.split(",")
read1 = args.q.split(",")
read2 = args.p.split(",")
ref = args.r
lt = str(args.left_trim)
rt = str(args.right_trim)
pbat = args.pbat

print(barcodes)
print(datasets)
print(read1)
print(read2)
print(ref)
print(lt)
print(rt)
print(pbat)

if(pbat):
    pbat_config = "#PBAT\\nnon-stranded = True\\nkeep_improper_pairs = True\\n"
else:
    pbat_config = "\n"

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

batcmd="sed 's/@reference/"+ ref + "/g; s/@left_trim/"+ lt + "/g; s/@right_trim/"+ rt + "/g; s/@PBAT/" + pbat_config  + "/g;' /IHEC_standard_template.conf"
result = subprocess.check_output(batcmd, shell=True)
f = open("IHEC_standard_instance.conf", "w")
encoding = 'utf-8'
content = str(result, encoding)
f.write(content)
f.close()
