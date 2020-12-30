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
  - id: threads
    type: string
 
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
       - gsnap_log
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
      - id: picard_markdup_log
      - id: picard_markdup_stat
    scatter:
      - bam_sorted
    scatterMethod: dotproduct

  - id: addRG
    run: "../tools/picard_addRG.cwl"
    in:
      - id: bam_withoutRG
        source: dedup/bam_duprem
      - id: ID
        source: sample_id
    out:
      - id: bam_withRG
      - id: picard_withRG_log
    scatter:
      - bam_withoutRG
      - ID
    scatterMethod: dotproduct

  - id: indexes
    run: "../tools/samtools_index.cwl"
    in: 
      - id: bam_sorted
        source: addRG/bam_withRG
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
  #bam_duprem:
  #  type: File[]
  #  outputSource: dedup/bam_duprem
  bam_withRG:
    type: File[]
    outputSource: addRG/bam_withRG
  bam_sorted_indexed:
    type: File[]
    outputSource: indexes/bam_sorted_indexed
  #gsnap_log:
  #  type: File[]
  #  outputSource: mapping/gsnap_log 
  #picard_markdup_log:
  #  type: File[]
  #  outputSource: dedup/picard_markdup_log
  #picard_withRG_log:
  #  type: File[]
  #  outputSource: addRG/picard_withRG_log
  picard_markdup_stat:
    type: File[]
    outputSource: dedup/picard_markdup_stat
