#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: create_conf.py 
requirements:
  DockerRequirement:
    dockerPull: ifishlin324/gembs:1.1 
    dockerOutputDirectory: /opt
  #InitialWorkDirRequirement:
  #  listing:
  #    - $(inputs.csv)

inputs: 
  barcode:
    type: string[]
    inputBinding:
      prefix: -b
      position: 1
      itemSeparator: ","
  dataset:
    type: string[]
    inputBinding:
      prefix: -d
      position: 2
      itemSeparator: ","
  r1:
    type: File[] 
    inputBinding:
      prefix: -q
      position: 3
      itemSeparator: ","
  r2:
    type: File[] 
    inputBinding:
      prefix: -p
      position: 4 
      itemSeparator: ","
  reference:
    type: File
    inputBinding:
      prefix: -r
      position: 5

outputs: 
  - id: sample_csv
    type: File
    outputBinding:
      glob: "sample.csv"
  - id: sample_conf
    type: File
    outputBinding:
      glob: "IHEC_standard_instance.conf"      
