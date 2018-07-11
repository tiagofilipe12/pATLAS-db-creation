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
    createdb $db_name_var
    /usr/bin/python3 db_create.py $db_name_var
    """

}

// 1) Download plasmid sequences from ncbi refseq ftp

// 2) Run MASHix.py

// 3)