#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
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
  ShellCommandRequirement: {}

stdout: stderr
stderr: $(inputs.sample_id + ".nonstranded.gsnap.log")

baseCommand: ["gsnap", "--gunzip", "--mode=cmet-nonstranded","-O", "-A", "sam"]
arguments:
  - valueFrom: "|"
    position: 5
    shellQuote: false
  - valueFrom: samtools
    position: 6
  - valueFrom: view
    position: 7 
  - valueFrom: "-b"
    position: 8
  - prefix: "-o"
    valueFrom: $(inputs.sample_id).bam
    position: 9


inputs:
  - id: sample_id
    type: string
  - id: reference
    type: File
    inputBinding:
      position: 1
      prefix: "-d"
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
      prefix: -D
      position: 2
  - id: threads
    type: int  
    default: 1
    inputBinding:
      prefix: "-t"
      position: 1 
 
outputs: 
  - id: bam
    type: File
    outputBinding:
      glob: "*.bam"
  - id: gsnap_log
    type: stderr
