#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
inputs:
  - id: sample_id
    type: string[]
  - id: reference
    type: File
  - id: r1
    type: 'File[]'
  - id: r2
    type: 'File[]'
  - id: ref
    type: Directory
 
steps:
  - id: mapping
    run: "../tools/gsnap.cwl"
    in: 
       sample_id: sample_id 
       reference: reference
       r1: r1
       r2: r2
       ref: ref
    out: 
       - bam
    scatter:
       - sample_id
       - r1 
       - r2
    scatterMethod: dotproduct

  - id: sorting
    run: "../tools/samtools_sort.cwl"
    in:
       - id: bam_unsorted
         source: mapping/bam
    out:
       - id: bam_sorted
    scatter:
       - bam_unsorted
    scatterMethod: dotproduct

  - id: dedup
    run: "../tools/picard_markdup.cwl"
    in:
      - id: bam_sorted
        source: sorting/bam_sorted
    out:
      - id: bam_duprem
    scatter:
      - bam_sorted
    scatterMethod: dotproduct

  - id: indexes
    run: "../tools/samtools_index.cwl"
    in: 
      - id: bam_sorted
        source: dedup/bam_duprem
    out:
      - id: bam_sorted_indexed
    scatter: 
      - bam_sorted
    scatterMethod: dotproduct

outputs: 
  #bam:
  #  type: File[]
  #  outputSource: mapping/bam
  #bam_sorted:
  #  type: File[]
  #  outputSource: sorting/bam_sorted
  bam_duprem:
    type: File[]
    outputSource: dedup/bam_duprem
  bam_sorted_indexed:
    type: File[]
    outputSource: indexes/bam_sorted_indexed
