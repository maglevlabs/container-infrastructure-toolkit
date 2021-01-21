FROM docker.io/alpine:3

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

ENV TOOL_AWS_IAM_AUTHENTICATOR="0.5.2" \
    TOOL_VERSION_GITCRYPT="0.6.0-r1" \
    TOOL_VERSION_KD="1.17.1" \
    TOOL_KOPS_VERSION="1.18.2" \
    TOOL_VERSION_KUBECTL="1.19.4" \
    TOOL_VERSION_TERRAFORM="0.14.4" \
    TOOL_VERSION_TERRAGRUNT="0.27.0"

RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://alpine.global.ssl.fastly.net|g' /etc/apk/repositories \ 
    && apk add --no-cache \
      bash \
      ca-certificates \
      curl \
      git-crypt=${TOOL_VERSION_GITCRYPT} \
      python3 \
      py3-pip \
    # AWS IAM Authenticator
    && curl -L https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${TOOL_AWS_IAM_AUTHENTICATOR}/aws-iam-authenticator_${TOOL_AWS_IAM_AUTHENTICATOR}_linux_amd64 \
      -o /usr/local/bin/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator \
    # kd
    && curl -L https://github.com/UKHomeOffice/kd/releases/download/v${TOOL_VERSION_KD}/kd_linux_amd64 \
      -o /usr/local/bin/kd \
    && chmod +x /usr/local/bin/kd \
    # kOps
    && curl -L https://github.com/kubernetes/kops/releases/download/v${TOOL_KOPS_VERSION}/kops-linux-amd64 \
      -o /usr/local/bin/kops \
    && chmod +x /usr/local/bin/kops \
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
    && chmod +x /usr/local/bin/terragrunt

ENTRYPOINT [ "/bin/bash" ]
