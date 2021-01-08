#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_gembs.sh
requirements:
  DockerRequirement:
    dockerPull: ifishlin324/gembs #:1.1 
    dockerOutputDirectory: /opt
  InitialWorkDirRequirement:
    listing:
      - $(inputs.conf)
      - $(inputs.csv)
      - $(inputs.r1)
      - $(inputs.r2)
      - $(inputs.reference)

inputs: 
  conf:
    type: File
    doc: configuration
    inputBinding:
       position: 1
  csv:
    type: File
    doc: list of inputs datasets
    inputBinding:
      position: 2
  r1:
    type: 'File[]'
  r2:
    type: 'File[]'
  reference:
    type: File

outputs:
  report:
    type:
      type: array
      items: Directory
    outputBinding:
      glob: "report"
  mapping:
    type:
      type: array
      items: Directory
    outputBinding:
      glob: "mapping"
  calls:
    type:
      type: array
      items: Directory
    outputBinding:
      glob: "calls"
  extract:
    type:
      type: array
      items: Directory
    outputBinding:
      glob: "extract" 
  indexes:
    type:
      type: array
      items: Directory
    outputBinding:
      glob: "indexes"
