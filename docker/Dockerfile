FROM ubuntu

MAINTAINER Oleg Boslovyak <example@gmail.com>

RUN apt-get update && apt-get install -y cowsay && ln -s /usr/games/cowsay /usr/bin/cowsay

ENTRYPOINT ["cowsay"]
