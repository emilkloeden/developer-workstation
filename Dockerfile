FROM ubuntu:jammy AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common sudo nano curl git build-essential wget unzip exa locales && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    sudo apt install -y python3.11 && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS personal
ARG TAGS
# RUN addgroup --gid 1000 emil
# RUN adduser --gecos emil --uid 1000 --gid 1000 --disabled-password emil

# Add user to sudoers
RUN  useradd dockeruser && echo "dockeruser:a" | chpasswd && adduser dockeruser sudo
RUN mkdir /home/dockeruser && chown -R dockeruser:dockeruser /home/dockeruser
# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
USER dockeruser
WORKDIR /home/dockeruser

FROM personal
COPY --chown=dockeruser:dockeruser . .
ENV PATH="~/bin:$PATH"
CMD ["ansible-playbook", "local.yml", "-e", "ansible_become_pass=a"]
