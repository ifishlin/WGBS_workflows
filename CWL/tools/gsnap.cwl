#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_gsnap.sh
requirements:
  DockerRequirement:
    dockerPull: ifishlin324/gsnap
    dockerOutputDirectory: /opt
  InitialWorkDirRequirement:
    listing:
      - $(inputs.r1)
      - $(inputs.r2)
      - $(inputs.reference)
      - $(inputs.ref)
  InlineJavascriptRequirement: {}

stdout: $(inputs.sample_id + ".gsnap.log")

inputs:
  - id: sample_id
    type: string
    inputBinding:
      position: 5
  - id: reference
    type: File
    inputBinding:
      position: 1
      #prefix: -d
      valueFrom: $(self.basename)
  - id: r1
    type: File
    inputBinding:
      position: 3
  - id: r2
    type: File
    inputBinding:
      position: 4
  - id: ref
    type: Directory
    inputBinding:
      #prefix: -D
      position: 2
    
outputs: 
  - id: bam
    type: File
    outputBinding:
      glob: "*.bam"
  - id: gsnap_log
    type: stdout
