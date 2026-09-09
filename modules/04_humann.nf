process HUMANN {

    tag "$sample_id"

    publishDir "${params.outdir}/humann", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}_combined_genefamilies.tsv", emit: genefamilies
    path "${sample_id}_combined_pathabundance.tsv", emit: pathabundance
    path "${sample_id}_combined_pathcoverage.tsv", emit: pathcoverage

    script:

    def r1 = reads.find { it.name.endsWith('_R1.clean.fastq.gz') }
    def r2 = reads.find { it.name.endsWith('_R2.clean.fastq.gz') }

    if (!r1 || !r2) {
        error "Could not identify R1/R2 files for sample ${sample_id}"
    }

    """
    zcat ${r1} ${r2} | gzip > ${sample_id}_combined.fastq.gz

    humann \
        -i ${sample_id}_combined.fastq.gz \
        -o . \
        --nucleotide-database ${params.humann_chocophlan} \
        --protein-database ${params.humann_uniref} \
        --threads ${task.cpus} \
        --metaphlan-options "--bowtie2db ${params.humann_metaphlan_db} --index ${params.humann_metaphlan_index}"
    """
}
