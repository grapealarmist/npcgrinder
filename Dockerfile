FROM microsoft/powershell:latest

COPY . /srv/npcgrinder

RUN chmod u+x /srv/npcgrinder/run.sh

WORKDIR /srv/npcgrinder

ENTRYPOINT ["/srv/npcgrinder/run.sh"]
