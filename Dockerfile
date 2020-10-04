FROM docker.io/centos:7

ARG BUILD_CREATED
ARG BUILD_REVISION
ARG BUILD_VERSION

LABEL org.opencontainers.image.authors="Platforms and Infrastructure (platformsandinfrastructure@maglevlabs.com)" \
      org.opencontainers.image.vendor="Maglev Labs" \
      org.opencontainers.image.title="infrastructure-toolkit" \
      org.opencontainers.image.description="Infrastructure Toolkit Container" \
      org.opencontainers.image.source="https://github.com/maglevlabs/container-infrastructure-toolkit" \
      org.opencontainers.image.licenses="MIT License" \
      org.opencontainers.image.created="${BUILD_CREATED}" \
      org.opencontainers.image.revision="${BUILD_REVISION}" \
      org.opencontainers.image.version="${BUILD_VERSION}"

ENV TOOL_VERSION_ANSIBLE="2.10.0" \
    TOOL_VERSION_AWSCLI="2.0.54" \
    TOOL_VERSION_GITCRYPT="0.6.0" \
    TOOL_VERSION_KD="1.16.0" \
    TOOL_VERSION_KUBECTL="1.19.0" \
    TOOL_VERSION_TERRAFORM="0.13.4" \
    TOOL_VERSION_TERRAGRUNT="0.25.2"

RUN yum install -y \
      python3 \
      unzip \
    # Ansible
    && pip3 install --no-cache-dir \
      ansible==${TOOL_VERSION_ANSIBLE} \
      ansible-base==${TOOL_VERSION_ANSIBLE} \
    # AWS CLI
    && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${TOOL_VERSION_AWSCLI}.zip \
      -o awscli-exe-linux-x86_64-${TOOL_VERSION_AWSCLI}.zip \
    && unzip awscli-exe-linux-x86_64-${TOOL_VERSION_AWSCLI}.zip \
    && bash aws/install \
    && rm -rf \
      awscli-exe-linux-x86_64-${TOOL_VERSION_AWSCLI}.zip \
      aws \
    # Git Crypt
    && yum install -y https://cbs.centos.org/kojifiles/packages/git-crypt/${TOOL_VERSION_GITCRYPT}/1.el7/x86_64/git-crypt-${TOOL_VERSION_GITCRYPT}-1.el7.x86_64.rpm \
    # kd
    && curl -L https://github.com/UKHomeOffice/kd/releases/download/v${TOOL_VERSION_KD}/kd_linux_amd64 \
      -o /usr/local/bin/kd \
    && chmod +x /usr/local/bin/kd \
    # Kubectl
    && curl -L https://storage.googleapis.com/kubernetes-release/release/v${TOOL_VERSION_KUBECTL}/bin/linux/amd64/kubectl \
      -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    # Terraform
    && curl https://releases.hashicorp.com/terraform/${TOOL_VERSION_TERRAFORM}/terraform_${TOOL_VERSION_TERRAFORM}_linux_amd64.zip \
      -o terraform_${TOOL_VERSION_TERRAFORM}_linux_amd64.zip \
    && unzip terraform_${TOOL_VERSION_TERRAFORM}_linux_amd64.zip \
    && mv terraform /usr/local/bin/terraform \
    && rm -rf terraform_${TOOL_VERSION_TERRAFORM}_linux_amd64.zip \
    # Terragrunt
    && curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v${TOOL_VERSION_TERRAGRUNT}/terragrunt_linux_amd64 \
      -o /usr/local/bin/terragrunt \
    && chmod +x /usr/local/bin/terragrunt \
    # Clean Yum
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rpm --rebuilddb