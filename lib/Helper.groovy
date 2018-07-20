class Help{

    static def print_help(params) {
        println("\n===========================================================")
        println("               pATLAS database generator")
        println("===========================================================\n")
        println("Version: 1.5.2\n")
        println("--help - prints this help")
        println("--db_name - A string with the database name to create and dump")
        println("--abricateDatabases - A list of databases to use by abricate. Default: ['resfinder', 'card', 'plasmidfinder', 'vfdb', 'virulencefinder']")
        println("--ncbi_ftp - The link to the plasmid sequences from ncbi refseq. Default: 'ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.*.1.genomic.fna.gz'")
        println("--abricateId - The identity percentage for blast searches (abricate). Default: 90")
        println("--abricateCov - The coverage percentage for blast searches (abricate). Default: 80")
        println("--sequencesRemove - A variable that allows to only generate the fasta file and stop the script. Default: false")
    }

}
