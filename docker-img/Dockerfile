FROM ubuntu:16.04
MAINTAINER Tiago F. Jesus, tiagojesus@medicina.ulisboa.pt

RUN apt-get update && apt-get -y install \
    wget \
    postgresql \
    git

WORKDIR /ngstools/bin/

# download mash
RUN wget https://github.com/marbl/Mash/releases/download/v2.0/mash-Linux64-v2.0.tar
# uncompress tar file
RUN tar -xvf mash-Linux64-v2.0.tar
# make mash accessible through PATH variable
ENV PATH="/ngstools/bin/mash-Linux64-v2.0:$PATH"

# install miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x Miniconda3-latest-Linux-x86_64.sh
RUN ./Miniconda3-latest-Linux-x86_64.sh -b -p /ngstools/bin/miniconda
ENV PATH="/ngstools/bin/miniconda/bin:$PATH"
# config conda channels
RUN conda config --add channels defaults
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda

# download and install abricate
RUN conda install abricate
RUN abricate --check && abricate --setupdb
# make virulencefinder database for abricate
RUN git clone https://bitbucket.org/genomicepidemiology/virulencefinder_db.git && cd /ngstools/bin/virulencefinder_db && cat *.fsa >> sequences
RUN cd /ngstools/bin/miniconda/db && mkdir virulencefinder && cp /ngstools/bin/virulencefinder_db/sequences virulencefinder/ && abricate --setupdb

# download patlas
RUN git clone https://github.com/tiagofilipe12/pATLAS
# install patlas dependencies
RUN pip install -r pATLAS/requirements.txt

# change workdir
WORKDIR /data/