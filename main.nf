#!/usr/local/bin

/* 
* Author: Sereena Bhanji <sereena.bhanji@mail.mcgill.ca>
* Version: 0.0.0
* Year: 2024
*/


process count_variants {
	//debug true 
    
    input:
    path vcf_file
	
	output:
	path 'result.txt'
	publishDir "results/", mode: "copy"

	script:
	""" 
	/Users/sereenabhanji/bcftools/bcftools stats $vcf_file | awk '/^SN/' > result.txt 
	"""
	// /Users/sereenabhanji/bcftools/bcftools stats $vcf_file | awk '/^SN/' > result.txt 

	// 	/Users/sereenabhanji/bcftools/bcftools stats $vcf_file | awk '/^SN/' | awk '/number of records/' > result.txt 

}


workflow {
    study_ch = Channel.fromPath(params.input_vcf, checkIfExists:true) \
    | map { file -> [ file.name.toString().tokenize('.').get(0), file, file + ".tbi"] }

	count_variants(file(params.input_vcf))

}