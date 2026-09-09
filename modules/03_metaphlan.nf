process METAPHLAN {

    tag "$sample_id"

    publishDir "${params.outdir}/metaphlan", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}.metaphlan.txt", emit: profile
    path "${sample_id}.bowtie2.bz2", emit: bowtie2

    script:

    def r1 = reads.find { it.name.endsWith('_R1.clean.fastq.gz') }
    def r2 = reads.find { it.name.endsWith('_R2.clean.fastq.gz') }

    if (!r1 || !r2) {
        error "Could not identify R1/R2 files for sample ${sample_id}"
    }

    """
    metaphlan \
        ${r1},${r2} \
        --input_type fastq \
        --bowtie2db ${params.metaphlan_db} \
        --index ${params.metaphlan_index} \
        --bowtie2out ${sample_id}.bowtie2.bz2 \
        --nproc ${task.cpus} \
        -o ${sample_id}.metaphlan.txt
    """
}
