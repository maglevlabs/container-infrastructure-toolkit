FROM registry.access.redhat.com/ubi8/ubi:latest

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

ENV AWS_IAM_AUTHENTICATOR_VERSION="0.5.2" \
    GITCRYPT_VERSION="0.6.0" \
    HELM_VERSION="3.5.2" \
    KD_VERSION="1.17.1" \
    KOPS_VERSION="1.19.1" \
    KUBECTL_VERSION="1.20.4" \
    TERRAFORM_VERSION="0.14.7" \
    TERRAGRUNT_VERSION="0.28.7"

RUN dnf install --assumeyes https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf install --assumeyes \
         git-crypt-${GITCRYPT_VERSION} \
         python3 \
         python3-pip \
         unzip \
    # Create symbolic link for pip
    && ln --symbolic /usr/bin/pip3 /usr/bin/pip \
    # AWS IAM Authenticator
    && curl --location https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 \
         --output /usr/local/bin/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator \
    # Helm
    && curl --location https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
         --output helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64 \
    # UKHomeOffice kd
    && curl --location https://github.com/UKHomeOffice/kd/releases/download/v${KD_VERSION}/kd_linux_amd64 \
         --output /usr/local/bin/kd \
    && chmod +x /usr/local/bin/kd \
    # Kops
    && curl --location https://github.com/kubernetes/kops/releases/download/v${KOPS_VERSION}/kops-linux-amd64 \
         --output /usr/local/bin/kops \
    && chmod +x /usr/local/bin/kops \
    # Kubectl
    && curl --location https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
         --output /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    # Terraform
    && curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
         --output terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/terraform \
    && rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    # Terragrunt
    && curl --location https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
         --output /usr/local/bin/terragrunt \
    && chmod +x /usr/local/bin/terragrunt \
    && dnf autoremove --assumeyes \
    && dnf clean all --assumeyes \
    && rm --recursive --force /var/cache/dnf

ENTRYPOINT [ "/bin/bash" ]
