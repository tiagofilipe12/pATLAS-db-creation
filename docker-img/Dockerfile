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
RUN git checkout backend_1.6.0
# install patlas dependencies
RUN pip3 install -r pATLAS/requirements.txt

#place patlas scripts in path
ENV PATH="/ngstools/bin/pATLAS/patlas/:/ngstools/bin/pATLAS/patlas/db_manager:$PATH"

# change workdir to update submodule
WORKDIR /ngstools/bin/pATLAS/patlas
RUN git submodule update --init --recursive

# change workdir to store files
WORKDIR /data/

RUN wget https://card.mcmaster.ca/download/0/broadstreet-v2.0.2.tar.gz

RUN tar xvjf broadstreet-v2.0.2.tar.gz

RUN rm *.fasta *.txt *.json aro_categories* broadstreet-v2.0.2.tar.gz
