FROM fedora

ENV PATH /root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/go/bin

#get basic tools to run the system
RUN sudo dnf update -y; \
    sudo dnf install git -y; \
    sudo dnf install unzip -y; \
    sudo dnf install libvirt-devel -y; \
    sudo dnf install wget -y; \
    sudo dnf install make -y; \
    sudo dnf install gcc -y; \
    sudo dnf install findutils -y; \
    sudo dnf install vim -y;

#create the init folder
RUN mkdir ./init; cd ./init;

# install terraform
RUN wget https://releases.hashicorp.com/terraform/0.14.2/terraform_0.14.2_linux_amd64.zip; \
    unzip terraform_0.14.2_linux_amd64.zip; \
    mv terraform /usr/bin/;

#install go
RUN wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz; \
    tar -C /usr/bin -xzf go1.15.6.linux-amd64.tar.gz; \
    export CGO_ENABLED="1"

#install libvirt provider
RUN git clone https://github.com/dmacvicar/terraform-provider-libvirt.git; \
    cd terraform-provider-libvirt; \
    git checkout v0.6.3; \
    make SHELL=/usr/bin/bash; \
    mkdir -p /usr/local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64; \
    mv ./terraform-provider-libvirt /usr/local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64;

#install ignition provider from Hashicorp
RUN mkdir -p /usr/local/share/terraform/plugins/registry.terraform.io/hashicorp/ignition/2.1.1/linux_amd64; \
    cd /usr/local/share/terraform/plugins/registry.terraform.io/hashicorp/ignition/2.1.1/linux_amd64; \
    wget https://github.com/community-terraform-providers/terraform-provider-ignition/releases/download/v2.1.1/terraform-provider-ignition_2.1.1_linux_amd64.zip; \
    unzip terraform-provider-ignition_2.1.1_linux_amd64.zip; \
    rm terraform-provider-ignition_2.1.1_linux_amd64.zip;

#get into a development environment
RUN mkdir /working/;

#set the start directory
WORKDIR /working
