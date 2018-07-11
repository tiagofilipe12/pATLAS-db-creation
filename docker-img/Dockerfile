FROM ubuntu:16.04
MAINTAINER Tiago F. Jesus, tiagojesus@medicina.ulisboa.pt

RUN apt-get update && apt-get -y install \
    python3-pip \
    wget \
    postgresql \
    git \
    sudo

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
RUN pip install -r pATLAS/requirements.txt

# change workdir
WORKDIR /data/