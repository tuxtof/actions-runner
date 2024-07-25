FROM summerwind/actions-runner:ubuntu-22.04

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN sudo apt update -y \
    && sudo apt install -y gh wget python3-pip openssh-client \
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo wget https://github.com/mikefarah/yq/releases/download/v4.22.1/yq_linux_amd64 -O /usr/bin/yq \
    && sudo chmod +x /usr/bin/yq

# install Operator-sdk
RUN export VERSION=v1.22.2 &&\
    export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/v1.22.2/download &&\
    sudo curl -LO https://github.com/operator-framework/operator-sdk/releases/download/${VERSION}/operator-sdk_linux_amd64 &&\
    sudo chmod +x operator-sdk_linux_amd64 && sudo mv operator-sdk_linux_amd64 /usr/local/bin/operator-sdk

# install operator-manifest-tools
RUN sudo wget https://github.com/operator-framework/operator-manifest-tools/releases/download/v0.2.2/operator-manifest-tools_0.2.2_linux_amd64 &&\
    sudo mv operator-manifest-tools_0.2.2_linux_amd64 /usr/local/bin/operator-manifest-tools && sudo chmod 755 /usr/local/bin/operator-manifest-tools

# install OC CLI
RUN sudo wget https://mirror.openshift.com/pub/openshift-v4/amd64/clients/ocp/latest-4.11/openshift-client-linux.tar.gz &&\
    sudo tar xvzf openshift-client-linux.tar.gz oc kubectl && sudo rm openshift-client-linux.tar.gz &&\
    sudo mv oc kubectl /usr/local/bin/

# install Tekton CLI
RUN sudo wget https://github.com/tektoncd/cli/releases/download/v0.26.0/tektoncd-cli-0.26.0_Linux-64bit.deb &&\
    sudo dpkg -i tektoncd-cli-0.26.0_Linux-64bit.deb && sudo rm tektoncd-cli-0.26.0_Linux-64bit.deb

# Install Crane
# RUN curl -sL https://raw.githubusercontent.com/michaelsauter/crane/v3.6.0/download.sh | sudo bash && sudo mv crane /usr/local/bin/crane

# Install Skopeo
RUN sudo wget https://github.com/lework/skopeo-binary/releases/download/v1.9.2/skopeo-linux-amd64 &&\
    sudo mv skopeo-linux-amd64 /usr/local/bin/skopeo && sudo chmod 755 /usr/local/bin/skopeo
