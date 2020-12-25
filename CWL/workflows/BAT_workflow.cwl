#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
inputs:
  - id : reference
    type: File
    secondaryFiles:
      - .fai
      - .ctidx
      - .gaidx
  - id: query
    type: 'File[]'
  - id: mate_pair
    type: 'File[]'
  - id: path_outfiles
    type: 'string[]'
  - id: threads
    type: int
  - id: sample_id
    type: string

outputs:
  bam:
    type: File[]
    outputSource: mapping/bam
  mapping_log:
    type: File[]
    outputSource: mapping/log
#  pdf:
#    type: File[]
#    outputSource: mapping_stat/pdf
#  stat:
#     type: File[]
#     outputSource: mapping_stat/stat
  merged_bam:
    type: File
    outputSource: merging/bam_merged
  vcf_file:
    type: File
    outputSource: calling/vcf
  calling_log:
    type: File
    outputSource: calling/log
#  filtered_vcf:
#    type: File
#    outputSource: filtering/filtered
#  bedgraph:
#    type: File
#    outputSource: filtering/bedgraph

steps:
  mapping:
    run: "../tools/BAT_mapping.cwl"
    in:
      reference: reference
      query: query
      mate_pair: mate_pair
      prefix_db: reference
      path_outfiles: path_outfiles
      threads: threads
    out: 
       - bam
       - excluded_bam
       - log
    scatter:
       - query
       - mate_pair
       - path_outfiles
    scatterMethod: dotproduct

#  mapping_stat:
#    run: "../tools/BAT_mapping_stat.cwl"
#    in:
#      - id: bam
#        source: mapping/bam
#      - id: excluded 
#        source: mapping/excluded_bam 
#      - id: fastq 
#        source: query
#      - id: stat_name
#        source: path_outfiles
#        valueFrom: $("/opt/" + self + ".stat")
#    out: 
#      - id: stat
#    scatter:
#      - bam
#      - excluded
#      - fastq
#      - stat_name
#    scatterMethod: dotproduct

  merging:
    run: "../tools/samtools_merge.cwl"
    in:
      - id: output_name
        source: sample_id
        valueFrom: $(self + ".bam")
      - id: bams
        source:
          - mapping/bam
    out:
      - id: bam_merged

  index_bam:
    run: "../tools/samtools_index.cwl"
    in: 
      - id: bam_sorted
        source: merging/bam_merged
    out:
      - id: bam_sorted_indexed

  calling:
    run: "../tools/BAT_calling.cwl"
    in:
      reference: reference
      #query: merging/bam_merged
      query: index_bam/bam_sorted_indexed
    out: 
      - id: vcf
      - id: log

#  filtering:
#     run: "../tools/BAT_filter_vcf.cwl"
#     in:
#       - id: vcf
#         source:
#           - calling/vcf
#       - id: out
#         source: 
#           - calling/vcf
#         valueFrom: $(self.basename.replace(".vcf.gz","_CG.vcf.gz"))
         #valueFrom: "test_CG.vcf.gz"
#       - id: context
#         valueFrom: "CG"
#       - id: MDP_min
#         valueFrom: "10"
#       - id: MDP_max
#         valueFrom: "100"
#     out: 
#       - id: filtered
#       - id: bedgraph
