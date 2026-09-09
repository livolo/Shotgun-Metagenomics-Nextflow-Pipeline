process KRAKEN2 {

    tag "$sample_id"

    publishDir "${params.outdir}/kraken2", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}.kraken2.output"), emit: classification
    path "${sample_id}.kraken2.report", emit: report

    script:

    def r1 = reads.find { it.name.endsWith('_R1.clean.fastq.gz') }
    def r2 = reads.find { it.name.endsWith('_R2.clean.fastq.gz') }

    if (!r1 || !r2) {
        error "Could not identify R1/R2 files for sample ${sample_id}"
    }

    """
    kraken2 \
        --db ${params.kraken_db} \
        --threads ${task.cpus} \
        --paired \
        --gzip-compressed \
        --report ${sample_id}.kraken2.report \
        --output ${sample_id}.kraken2.output \
        ${r1} ${r2}
    """
}
