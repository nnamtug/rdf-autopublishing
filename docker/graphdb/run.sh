#!/bin/bash
sudo docker run \
  --name graphdb-auto-publisher \
  --network auto-publisher \
  -d \
  --restart=unless-stopped \
  -p 7200:7200 \
  ontotext/graphdb:9.10.2-se
