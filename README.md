# pATLAS-db-creation
This repository is a wrapper for the creation of pATLAs database. It
will not make the pATLAS service run but will create the necessary files
to construct [pATLAS](www.patlas.site), including:

* JSON file for the initial load of pATLAS (devel session)
* sql file to migrate the database between machines.
* JSON files that are used to populate the drop down menus of pATLAS.
* Fasta file with all the sequences available in pATLAS
    * indexes for bowtie2 and samtools (required by pATLASflow)
    * index for mash (required by pATLASflow)

[pATLAS source code](https://github.com/tiagofilipe12/pATLAS)

## Usage

```
--help - prints this help
--db_name - A string with the database name to create and dump
--abricateDatabases - A list of databases to use by abricate. Default: ['resfinder', 'card', 'plasmidfinder', 'vfdb', 'virulencefinder']
--ncbi_ftp - The link to the plasmid sequences from ncbi refseq. Default: 'ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.*.1.genomic.fna.gz'
--abricateId - The identity percentage for blast searches (abricate). Default: 90
--abricateCov - The coverage percentage for blast searches (abricate). Default: 80
--sequencesRemove - A variable that allows to only generate the fasta file and stop the script. Default: false
```
