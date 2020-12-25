#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: BAT_mapping_stat
requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: ifishlin324/bat2
    dockerOutputDirectory: /opt
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

inputs:
  bam:
    type: File
    inputBinding:
      prefix: --bam
      position: 1
  excluded:
    type: File
    inputBinding:
      prefix: --excluded
      position: 2
  fastq:
    type: File
    inputBinding:
      prefix: --fastq
      position: 3
  stat_name:
    type: string
    inputBinding:
      prefix: ">"
      position: 4

outputs: 
   #pdf:
   #   type: File
   #   outputBinding:
   #     glob: "*.pdf"
   stat:
      type: File
      outputBinding:
        glob: "*.stat"
