#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
inputs:
  - id: barcode
    type: string[]
  - id: dataset
    type: string[]
  - id: r1
    type: 'File[]'
  - id: r2
    type: 'File[]'
  - id: reference
    type: File
  - id: left_trim
    type: int
  - id: right_trim
    type: int

steps:
  - id: create_conf
    in:
        - id: barcode
          source: barcode
        - id: dataset
          source: dataset
        - id: r1
          source: r1
        - id: r2
          source: r2
        - id: reference
          source: reference
        - id: left_trim
          source: left_trim
        - id: right_trim
          source: right_trim
    out:
        - id: sample_csv
        - id: sample_conf
    run: "../tools/gembs_create_conf.cwl"

  - id: gembs_main
    in: 
        - id: conf
          source: create_conf/sample_conf
        - id: csv
          source: create_conf/sample_csv 
        - id: r1
          source: r1
        - id: r2
          source: r2
        - id: reference
          source: reference
    out:
        - id: mapping
        - id: calls
        - id: report
        - id: extract
        - id: indexes
    run: "../tools/gembs_main.cwl"

outputs: 
  sample_csv:
    type: File
    outputSource: create_conf/sample_csv
  sample_conf:
    type: File
    outputSource: create_conf/sample_conf
  mapping:
    type:
      type: array
      items: Directory
    outputSource: gembs_main/mapping
  calls:
    type:
      type: array
      items: Directory
    outputSource: gembs_main/calls
  report:
    type:
      type: array
      items: Directory
    outputSource: gembs_main/report
  extract:
    type:
      type: array
      items: Directory
    outputSource: gembs_main/extract
  indexes:
    type:
      type: array
      items: Directory
    outputSource: gembs_main/indexes

