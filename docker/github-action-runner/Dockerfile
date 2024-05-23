FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
  locales \
   curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip \
   && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN adduser --disabled-password ghrunner
RUN mkdir ghrunner && chown ghrunner:ghrunner ghrunner
USER ghrunner

WORKDIR ghrunner

#that is plan b...
ADD --chown=ghrunner:ghrunner tmp-extracted .


RUN mkdir _work
ADD launch-helper.sh .
ENTRYPOINT [ "/bin/bash", "/ghrunner/launch-helper.sh" ]
#CMD [ /bin/bash ]
