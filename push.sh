#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag nginx vadim0209/redmine:latest
docker push vadim0209/redmine
docker tag mariadb vadim0209/redmine:latest
docker push vadim0209/redmine
docker tag redmine vadim0209/redmine:latest
docker push vadim0209/redmine

