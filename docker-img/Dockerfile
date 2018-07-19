FROM ubuntu:16.04
MAINTAINER Tiago F. Jesus, tiagojesus@medicina.ulisboa.pt

RUN apt-get update && apt-get -y install \
    python3-pip \
    wget \
    git \
    gcc \
    libreadline6 libreadline6-dev \
    zlib1g zlib1g-dev

# change workdir for installers
WORKDIR /ngstools/bin/

# credits for the psql config code: https://www.endpoint.com/blog/2013/06/12/installing-postgresql-without-root
#download postgres and uncompress source code
RUN wget https://ftp.postgresql.org/pub/source/v10.1/postgresql-10.1.tar.gz
RUN gunzip postgresql-10.1.tar.gz
RUN tar xf postgresql-10.1.tar
RUN rm postgresql-10.1.tar

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


# Install postgres from source
WORKDIR /ngstools/bin/postgresql-10.1/
RUN ./configure --prefix=/ngstools/bin/postgres/ --with-python PYTHON=/usr/bin/python3
RUN make -j 3
RUN make install
WORKDIR /ngstools/bin/postgres
RUN mkdir /ngstools/bin/postgres/data
RUN useradd patlas
RUN chown -R patlas .
USER patlas
RUN /ngstools/bin/postgres/bin/initdb -D /ngstools/bin/postgres/data
# end of psql config
