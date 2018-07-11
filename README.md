# pATLAS-db-creation
This repository is a wrapper for the creation of pATLAs database. It
will not make the pATLAS service run but will create the necessary files
to construct pATLAS, including:

* JSON file for the initial load of pATLAS (devel session)
* sql file to migrate the database between machines.
* JSON files that are used to populate the drop down menus of pATLAS.
* Fasta file with all the sequences available in pATLAS
    * indexes for bowtie2 and samtools (required by pATLASflow)
    * index for mash (required by pATLASflow)
