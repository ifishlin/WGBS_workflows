#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: BAT_filter_vcf
requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: ifishlin324/bat
    dockerOutputDirectory: /opt

inputs:
  vcf:
    type: File
    inputBinding:
      prefix: --vcf
      position: 1
  out:
    type: string
    inputBinding:
      prefix: --out
      position: 2
  context:
    type: string
    inputBinding:
      prefix: --context
      position: 3
  MDP_min:
    type: string
    inputBinding:
      prefix: --MDP_min
      position: 4
  MDP_max:
    type: string
    inputBinding:
      prefix: --MDP_max
      position: 5

outputs:
   filtered:
     type: File
     outputBinding:
        glob: $("*.vcf.gz")
   bedgraph:
     type: File
     outputBinding:
        glob: $("*.bedgraph")
