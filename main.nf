#!/usr/bin/env nextflow

/* 
* Author: Sereena Bhanji <sereena.bhanji@mail.mcgill.ca>
* Version: 0.0.0
* Year: 2024
*/

params.reference_panel = "/Users/sereenabhanji/Downloads/CAG_Panel_2/CAG_panel"

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
}

process run_snp2hla {
	
	input:
	val array_data

	output:
	path "imputed_results.bgl.phased.vcf.gz"
	publishDir "results/", mode: "copy"

	script:
	"""
	dir=\${PWD}
	cd ${projectDir}/bin/HLA-TAPAS/
	python3 -m SNP2HLA --target $array_data --out \$dir/imputed_results --reference ${params.reference_panel} 
	"""

}

process PRINT_PATH {
  debug true
  output:
    stdout
  script:
  """
  echo $PATH
  """
}

process test {

	output:
	stdout
	//path 'output.txt'
	//publishDir "results/", mode: "copy"

	script:
	"""
	var=\${PWD}
	echo \$var
	"""
}


workflow {
    plink_files = Channel.fromPath(params.array+'/*.{bed,bim,fam}', checkIfExists:true)
			.map {file -> params.array + '/' + file.baseName}
			.unique()
			.view()
	

	//println(file.baseName)
	//def input_data = Channel.fromPath(params.array)


	//input_data = file(params.array)
	run_snp2hla(plink_files)
	//test | view
	//count_variants(file(params.reference_panel))

	//PRINT_PATH()

}