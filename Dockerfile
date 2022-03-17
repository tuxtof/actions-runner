FROM summerwind/actions-runner:latest

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN sudo apt update -y \
  && sudo apt install -y gh \
  && sudo rm -rf /var/lib/apt/lists/*

RUN sudo wget https://github.com/mikefarah/yq/releases/download/v4.22.1/yq_linux_amd64 -O /usr/bin/yq \
    && sudo chmod +x /usr/bin/yq

# install Operator-sdk
RUN export ARCH=$(case $(arch) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(arch) ;; esac) &&\
      export OS=$(uname | awk '{print tolower($0)}') &&\
      export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/latest/download &&\
      sudo curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH} &&\
      # gpg --keyserver keyserver.ubuntu.com --recv-keys 052996E2A20B5C7E &&\
      sudo curl -LO ${OPERATOR_SDK_DL_URL}/checksums.txt &&\
      sudo curl -LO ${OPERATOR_SDK_DL_URL}/checksums.txt.asc &&\
      # gpg -u "Operator SDK (release) <cncf-operator-sdk@cncf.io>" --verify checksums.txt.asc &&\
      # grep operator-sdk_${OS}_${ARCH} checksums.txt | sha256sum -c - &&\
      sudo chmod +x operator-sdk_${OS}_${ARCH} && sudo mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk

# install OC CLI
RUN sudo wget https://mirror.openshift.com/pub/openshift-v4/amd64/clients/ocp/latest-4.8/openshift-client-linux.tar.gz &&\
    sudo tar xvzf openshift-client-linux.tar.gz oc kubectl && sudo rm openshift-client-linux.tar.gz &&\
    sudo mv oc kubectl /usr/local/bin/

# install Tekton CLI
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA &&\
    echo "deb http://ppa.launchpad.net/tektoncd/cli/ubuntu eoan main"|sudo tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list &&\
    sudo apt update && sudo apt install -y tektoncd-cli
