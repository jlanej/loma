FROM ubuntu:22.04
# 22.04, jammy-20240227, jammy, latest
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get -y upgrade && \
apt-get install -y build-essential curl wget gnupg libcurl4-openssl-dev git r-base r-base-dev && \
apt-get clean && apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV VERSION=7.407


#https://github.com/ddiez/mafft/blob/master/Dockerfile
## Install MAFFT.
WORKDIR /tmp
RUN curl https://mafft.cbrc.jp/alignment/software/mafft-$VERSION-with-extensions-src.tgz > mafft-$VERSION-with-extensions-src.tgz \
    && tar zxvf mafft-$VERSION-with-extensions-src.tgz
    
RUN cd mafft-$VERSION-with-extensions/core && \
    sed -e "s/^PREFIX = \/usr\/local/PREFIX = \/opt/" Makefile > Makefile.tmp
    
RUN  mv Makefile.tmp Makefile && \
    make clean && make && make install
    
RUN cd /tmp && rm -rf mafft-$VERSION-with-extensions && \
    apt-get purge -y build-essential curl && \
    apt-get autoremove -y
    
ENV PATH /opt/bin:$PATH

# Prevent caching the git clone TODO this seems like it could be done differently 
ADD https://worldtimeapi.org/api/ip time.tmp

WORKDIR /app

RUN git clone https://github.com/lh3/minimap2
WORKDIR minimap2
RUN make
ENV PATH /app/minimap2:$PATH
WORKDIR /app
# Clone the repo to get all resources and history
RUN git clone https://github.com/jlanej/loma.git
WORKDIR loma
CMD ["/bin/bash"]
