process BRACKEN {

    tag "$kraken_report.simpleName"

    publishDir "${params.outdir}/bracken", mode: 'copy'

    input:
    path kraken_report

    output:
    path "*.bracken.species.txt", emit: abundance
    path "*.bracken.report", emit: report

    script:

    def sample_id = kraken_report.baseName.replaceFirst(/\.kraken2$/, '')

    """
    bracken \
        -d ${params.kraken_db} \
        -i ${kraken_report} \
        -o ${sample_id}.bracken.species.txt \
        -w ${sample_id}.bracken.report \
        -r 100 \
        -l S
    """
}
