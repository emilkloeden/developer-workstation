FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common sudo nano curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS personal
ARG TAGS
# RUN addgroup --gid 1000 emil
# RUN adduser --gecos emil --uid 1000 --gid 1000 --disabled-password emil

# Add user to sudoers
RUN  useradd dockeruser && echo "dockeruser:temppassword" | chpasswd && adduser dockeruser sudo
RUN mkdir /home/dockeruser && chown -R dockeruser:dockeruser /home/dockeruser
USER dockeruser
WORKDIR /home/dockeruser

FROM personal
COPY --chown=dockeruser:dockeruser . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
