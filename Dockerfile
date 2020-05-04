FROM python:3.6-slim
ENV PYTHONUNBUFFERED 1

# set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  git \
  libc-dev && \
  pip3 install --upgrade pip && \
  git clone https://github.com/polkascan/polkascan-pre-harvester.git . && \
  git checkout 49d2d4d46c3b41b26108e8d09178637693daddf7 && \
  git submodule update --init && \
  pip3 install -r requirements.txt && \
  apt-get purge --auto-remove -y \
  build-essential \
  git \
  libc-dev && \
  useradd -m -u 1000 -U -s /bin/sh -d /home/harvester harvester && \
	mkdir -p /home/harvester && \
	chown -R harvester:harvester /home/harvester /usr/src/app

USER harvester
COPY ./scripts/start.sh /usr/src/app/start.sh
ENTRYPOINT ["/usr/src/app/start.sh"]
