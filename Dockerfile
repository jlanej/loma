FROM ubuntu:22.04
# 22.04, jammy-20240227, jammy, latest
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get -y upgrade && \
apt-get install -y wget gnupg libcurl4-openssl-dev git r-base r-base-dev && \
apt-get clean && apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Prevent caching the git clone TODO this seems like it could be done differently 
ADD https://worldtimeapi.org/api/ip time.tmp

# Clone the repo to get all resources and history
RUN git clone https://github.com/jlanej/loma.git
WORKDIR loma
RUN ./SETUP.sh
CMD ["/bin/bash"]
