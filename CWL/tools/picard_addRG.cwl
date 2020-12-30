#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 20000
    tmpdirMin: 10000
  DockerRequirement:
    dockerPull: kerstenbreuer/picard_tools:2.17.4
  
baseCommand: ["java", "-jar"]
arguments:
  - valueFrom: "AddOrReplaceReadGroups"
    position: 2
  - valueFrom: $(inputs.bam_withoutRG.nameroot + "_withRG.bam")
    prefix: "O="
    separate: false
    position: 13
    # log file
  - valueFrom: "VALIDATION_STRINGENCY=SILENT"
    position: 15
  - valueFrom: "SORT_ORDER=coordinate"
    position: 16
  - valueFrom: $(inputs.ID)
    prefix: "ID="
    separate: false
    position: 4

stdout: $(inputs.bam_withoutRG.nameroot + ".picard_addRG.stdout")

inputs:
  bam_withoutRG:
    type: File
    inputBinding:
      prefix: "I="
      position: 11
  path_to_picards:
    type: string
    default: "/bin/picard.jar"
    inputBinding:
      position: 1
  ID:
    type: string
  LB:
    type: string
    default: "readGroup_name"
    inputBinding:
      prefix: "LB="
      separate: false
      position: 4
  PL:
    type: string
    default: "illumina"      
    inputBinding:
      prefix: "PL="
      separate: false
      position: 5
  PU:
    type: string
    default: "run"
    inputBinding:
      prefix: "PU="
      separate: false
      position: 6
  SM:
    type: string
    default: "sample_name"
    inputBinding:
      prefix: "SM="
      separate: false
      position: 7

outputs:
  bam_withRG:
    type: File
    outputBinding:
      glob: $(inputs.bam_withoutRG.nameroot + "_withRG.bam")
  picard_withRG_log:
    type: stdout
    
