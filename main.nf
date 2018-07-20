#!/usr/bin/env nextflow

import Helper

if (params.help) {
    Help.print_help(params)
    exit(0)
}

if (params.db_name instanceof String) {
    IN_db_name = Channel.value(params.db_name)
} else {
    println("Variable db_name isn't a string and should be a string.")
}

if (params.sequencesRemove == true) {
    IN_sequences_removal = Channel.value("--search-sequences-to-remove")
} else {
    IN_sequences_removal = Channel.value("")
}

// Download plasmid sequences from ncbi refseq ftp
process downloadFastas {

    tag {"downloading plasmids from ncbi refseq ftp"}

    output:
    file "plasmid.*.1.genomic.fna" into downloadedFastas
    //file "plasmid.*.1.genomic.fna" into downloadedFastas

    """
    wget $params.ncbi_ftp
    gunzip plasmid.*.1.genomic.fna.gz
    """

}

// Run MASHix.py
process runMASHix {

    tag {"Running MASHix"}

    publishDir "results/MAHSix/"

    input:
    file fastas from downloadedFastas
    val db_name_var from IN_db_name
    val sequencesToRemove from IN_sequences_removal

    output:
    file "${db_name_var}/*.fas" into masterFasta
    file "${db_name_var}/results/*.json" into patlasJson
    file "*.json" into taxaTree
    file "*sql" into sqlFileMashix
    file "${db_name_var}/*json" into lenghtJson
    file "${db_name_var}/reference_sketch/${db_name_var}_reference.msh" into mashIndex
    file "${db_name_var}/*.txt" into actualRemovedSequences

    """
    echo "Configuring psql and creating $db_name_var"
    service postgresql start
    service postgresql status
    sudo -u postgres createuser -w -s root
    createdb $db_name_var
    db_create.py $db_name_var
    echo "Downloading ncbi taxonomy"
    wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
    tar -xvzf taxdump.tar.gz
    echo "Running MASHix.py"
    MASHix.py -i ${fastas} -o ${db_name_var} -t ${task.cpus} -non nodes.dmp \
    -nan names.dmp -rm ${sequencesToRemove} -db ${db_name_var}
    echo "Dumping to database file"
    pg_dump ${db_name_var} > ${db_name_var}.sql
    rm *.dmp *.prt *.txt *.tar.gz
    """

}

// executes abricate for the fasta with pATLAS database
process abricate {

    tag {"running abricate"}

    input:
    file masterFastaFile from masterFasta
    each db from params.abricateDatabases

    output:
    file "*.tsv" into abricateOutputs

    """
    abricate --db ${db} ${masterFastaFile} > abr_${db}.tsv
    """

}

// dump abricate results to database
process abricate2db {

    tag {"sending abricate to database"}

    publishDir "results/sql_file/"

    input:
    file abricate from abricateOutputs.collect()
    file sqlFile from sqlFileMashix
    val db_name_var from IN_db_name

    output:
    file "*final.sql" into FinalDbSql

    """
    echo ${abricate}
    echo "Configuring psql and creating $db_name_var"
    service postgresql start
    service postgresql status
    sudo -u postgres createuser -w -s root
    createdb $db_name_var
    psql -d ${db_name_var} -f ${db_name_var}.sql
    echo "Dumping into database - resistance"
    abricate2db.py -i abr_card.tsv abr_resfinder.tsv -db resistance \
    -id ${params.abricateId} -cov ${params.abricateCov} -csv ${params.cardCsv} \
    -db_psql ${db_name_var}
    echo "Dumping into database - plasmidfinder"
    abricate2db.py -i abr_plasmidfinder.tsv -db plasmidfinder \
    -id ${params.abricateId} -cov ${params.abricateCov} -csv ${params.cardCsv} \
    -db_psql ${db_name_var}
    echo "Dumping into database - virulence"
    abricate2db.py -i abr_vfdb.tsv -db virulence \
    -id ${params.abricateId} -cov ${params.abricateCov} -csv ${params.cardCsv} \
    -db_psql ${db_name_var}
    echo "Writing to sql file"
    pg_dump ${db_name_var} > ${db_name_var}_final.sql
    """

}

// Generate indexes for bowtie2 nd samtools using fasta retrieved by MASHix.py
process bowtieIndex {

    tag {"creating bowtie2 index"}

    publishDir "results/bowtie_samtools_indexes/"

    input:
    file masterFastaFile from masterFasta

    output:
    file "*bowtie2_index.*" into bowtieIndexChannel
    file "*.fai" into samtoolsIndexChannel

    """
    echo "Creating bowtie2 index"
    bowtie2-build -q ${masterFastaFile} --threads ${task.cpus} \
    patlas_bowtie2_index
    echo "Creating samtools index"
    samtools faidx ${masterFastaFile}
    """

}
