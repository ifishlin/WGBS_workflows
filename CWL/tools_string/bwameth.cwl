cwlVersion: v1.0
class: CommandLineTool
id: '#bwameth'
label: bwameth
requirements:
  ShellCommandRequirement: {}
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 28000
inputs:
  file_dir: string
  threads:
    label: ''
    doc: ''
    type: int?
    inputBinding:
      position: 101
      prefix: --threads
      separate: true
  reference:
    label: ''
    doc: the reference fasta file location
    type: string
    inputBinding:
      position: 102
      prefix: --reference
      separate: true
  lib_type:
    doc: "Library type, directional or non-directional    \n"
    type: string
  read1:
    label: ''
    doc: the input fastq file with the first mate
    type: string
    inputBinding:
      position: 103
      separate: true
  read2:
    label: ''
    doc: the input fastq file with the second mate
    type: string
    inputBinding:
      position: 104
      separate: true
  alignment_filename: string
baseCommand: cd
arguments:
- position: 1
  valueFrom: $(inputs.file_dir)
- position: 2
  valueFrom: ;
- position: 100
  valueFrom: bwameth.py
- position: 200
  valueFrom: ${ if(inputs.lib_type=="directional"){ return null; }else{ return "--non-directional";
    } }
- position: 1001
  valueFrom: '>'
- position: 1002
  valueFrom: $(inputs.file_dir + "/" + inputs['alignment_filename']).sam
outputs:
  alignment:
    type: string
    outputBinding:
      outputEval: ${return inputs.file_dir + "/" + inputs['alignment_filename'] +
        ".sam";}

