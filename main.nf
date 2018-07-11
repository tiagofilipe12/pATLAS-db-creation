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

// 1) Configure postgresql
process psql_config {

    tag {"configuring psql"}

    input:
    val db_name_var from IN_db_name

    """
    echo "Creating $db_name_var"
    cd /ngstools/bin/pATLAS/patlas/db_manager
    service postgresql start
    service postgresql status
    sudo -u postgres createuser -w -s root
    createdb $db_name_var
    python3 db_create.py $db_name_var
    """

}

// 2) Download plasmid sequences from ncbi refseq ftp
process download_fastas {

    tag {"downloading plasmids from ncbi refseq ftp"}

    """
    wget $params.ncbi_ftp
    gunzip plasmid.*.1.genomic.fna.gz
    """

}

// 3) Run MASHix.py

// 3.1) generate indexes for bowtie2 nd samtools using fasta retrieved by MASHix.py

// 3.2) generate index for mash retrieving it from MASHix.py

// 4) Run abricate

// 5) Run abricate2db.py

// 6) dump database to a file

