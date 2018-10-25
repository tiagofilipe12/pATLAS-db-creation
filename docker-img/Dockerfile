FROM ubuntu:16.04
MAINTAINER Tiago F. Jesus, tiagojesus@medicina.ulisboa.pt

RUN apt-get update && apt-get -y install \
    python3-pip \
    wget \
    postgresql \
    git \
    sudo

# change workdir for installers
WORKDIR /ngstools/bin/

# download mash
RUN wget https://github.com/marbl/Mash/releases/download/v2.0/mash-Linux64-v2.0.tar
# uncompress tar file
RUN tar -xvf mash-Linux64-v2.0.tar
# make mash accessible through PATH variable
ENV PATH="/ngstools/bin/mash-Linux64-v2.0:$PATH"

# download patlas
RUN git clone https://github.com/tiagofilipe12/pATLAS
# install patlas dependencies
RUN pip3 install -r pATLAS/requirements.txt

WORKDIR /ngstools/bin

#place patlas scripts in path
ENV PATH="/ngstools/bin/pATLAS/patlas/:/ngstools/bin/pATLAS/patlas/db_manager:$PATH"

# change workdir to update submodule
WORKDIR /ngstools/bin/pATLAS/patlas
RUN git submodule update --init --recursive

WORKDIR /ngstools/bin

# install diamond
RUN wget http://github.com/bbuchfink/diamond/releases/download/v0.9.22/diamond-linux64.tar.gz
RUN tar xzf diamond-linux64.tar.gz
RUN rm diamond-linux64.tar.gz *.pdf LICENSE

ENV PATH="/ngstools/bin/:$PATH"

# ADD BacMet database
#RUN mkdir /NGStools/bacmet
WORKDIR /NGStools/bacmet
RUN wget http://bacmet.biomedicine.gu.se/download/BacMet2_EXP_database.fasta
# makes diamond db
RUN diamond makedb --in BacMet2_EXP_database.fasta -d bacmet

# change workdir to store files
WORKDIR /data/

# get card entries to get aro accessions
RUN wget https://card.mcmaster.ca/download/0/broadstreet-v2.0.2.tar.gz
RUN tar xvjf broadstreet-v2.0.2.tar.gz
RUN rm *.fasta *.txt *.json aro_categories* broadstreet-v2.0.2.tar.gz