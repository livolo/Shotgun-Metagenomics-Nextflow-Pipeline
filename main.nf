nextflow.enable.dsl=2

include { KRAKEN2 }   from './modules/01_kraken2.nf'
include { BRACKEN }   from './modules/02_bracken.nf'
include { METAPHLAN } from './modules/03_metaphlan.nf'
include { HUMANN }    from './modules/04_humann.nf'

workflow {

    reads_ch = channel.fromFilePairs(
        "${params.reads}/*_{R1,R2}.clean.fastq.gz",
        checkIfExists: true
    )

    // 01_kraken
    KRAKEN2(reads_ch)
    
    // 02_braken
    BRACKEN(KRAKEN2.out.report)
   
    // 03_metaplan
    METAPHLAN(reads_ch)

    // 04-humann
    HUMANN(reads_ch)
}
