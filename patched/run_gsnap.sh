#!/bin/bash

echo "gsnap --gunzip -d $1 -D $2 -t 24 -O -A sam $3 $4 |samtools view -b -o $5.bam"
gsnap --gunzip -d $1 -D $2 -t 24 -O -A sam $3 $4 |samtools view -@ 12 -b -o $5.bam
