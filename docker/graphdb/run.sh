#!/bin/bash
sudo docker run \
  --name graphdb-autopublisher-example \
  --network autopublisher-example \
  ontotext/graphdb:9.10.2-se
