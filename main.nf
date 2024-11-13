#!/usr/bin/env nextflow

/* 
* Author: Sereena Bhanji <sereena.bhanji@mail.mcgill.ca>
* Version: 0.0.0
* Year: 2024
*/

// params.input_vcf = file('./Panel/CAG_panel.bgl.phased.vcf.gz')

include { bcftools } from 'Users/sereenabhanji/bcftools'

process count_variants {
	debug true 
    
    input:
    path vcf_file
	
	output:
	path 'result.txt'

	script:
	""" 
	bcftools stats $vcf_file | awk '/^SN/' | awk '/number of records/ {print \$6}' > result.txt 
	"""

}


workflow {
    study_ch = Channel.fromPath(params.input_vcf, checkIfExists:true) \
    | map { file -> [ file.name.toString().tokenize('.').get(0), file, file + ".tbi"] }

	count_variants(params.input_vcf)
}