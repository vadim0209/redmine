#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag redmine vadim0209/redmine:latest
docker push vadim0209/redmine
