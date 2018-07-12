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

// 2) Download plasmid sequences from ncbi refseq ftp
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

// 3) Run MASHix.py
process runMASHix {

    tag {"Running MASHix"}

    publishDir "/results"

    input:
    file fastas from downloadedFastas
    val db_name_var from IN_db_name

    output:
    file "new_db/*.fas" into masterFasta
    file "new_db/results/*.json" into patlasJson
    file "*.json" into taxaTree

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
    MASHix.py -i ${fastas} -o new_db -t ${task.cpus} -non nodes.dmp \
    -nan names.dmp -rm -db ${db_name_var}
    pg_dump ${db_name_var} > ${db_name_var}.sql
    rm *.dmp *.prt *.txt *.tar.gz
    """

}

// 3.1) generate indexes for bowtie2 nd samtools using fasta retrieved by MASHix.py

process bowtieIndex {

    tag {creating bowtie2 index}

    input:
    file masterFastaFile from masterFasta

    """
    echo $masterFasta
    """

}

// 3.2) generate index for mash retrieving it from MASHix.py

// 4) Run abricate

// 5) Run abricate2db.py

// 6) dump database to a file

