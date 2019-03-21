FROM grzosdocker01.infonova.at/infonova/platform:2.0-SNAPSHOT

RUN mkdir /kubespray
WORKDIR /kubespray
RUN apt update -y && \
    apt install -y \
    libssl-dev python-dev sshpass apt-transport-https jq \
    ca-certificates curl gnupg2 software-properties-common python-pip
RUN  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
     add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable" \
     && apt update -y && apt-get install docker-ce -y
COPY . .
RUN /usr/bin/python -m pip install pip -U && /usr/bin/python -m pip install -r tests/requirements.txt && python -m pip install -r requirements.txt
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.11.3/bin/linux/amd64/kubectl \
    && chmod a+x kubectl && cp kubectl /usr/local/bin/kubectl

WORKDIR /ansible/com.infonova.opss.devopss/platform/2.0-SNAPSHOT/