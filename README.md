# Установка GIT
Для того, чтобы работать с репозиториями, необходимо первоначально установить git. 
На последних версиях операционной системы ubuntu этот инструмент у вас уже может быть установлен, проверить это можно с помощью команды:

    git --version

Если вы получили вывод с номером версии git, значит он уже установлен на вашем компьютере.

Однако, если вывода не было, то его необходимо установить

Для начала необходимо воспользоваться командой для обновления индекса пакетов: 

    sudo apt update

После можно устанавливать git с помощью команды: 

    sudo apt install git

# Установка Docker

Для работы с работы с данным репозиторием нам необходимо установить Docker и docker-compose

Сначала обновим индекс пакетов:

    sudo apt update

Затем установим несколько необходимых пакетов, которые позволяют apt использовать пакеты через HTTPS:

    sudo apt install apt-transport-https ca-certificates curl software-properties-common

Добавим ключ GPG для официального репозитория Docker в нашу систему:

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

Добавьте репозиторий Docker в источники APT:

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

Потом обновите базу данных пакетов и добавьте в нее пакеты Docker из недавно добавленного репозитория:

    sudo apt update

После этого установим Docker:

    sudo apt install docker-ce

# Установка docker-compose

Запускаем команду для установки последней версии docker-compose:

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

Делаем файл запускаемым:

    sudo chmod +x /usr/local/bin/docker-compose

Проверяем установку с помощью команды:

    docker-compose --version

# Клонирование репозитория

После проделанных действий мы можем скачать данный репозиторий

Для этого воспользуемся командой:

    git clone https://github.com/vadim0209/redmine.git

Данная команда создаст точную копию данного репозитория на вашем компьютере


# Работа с репозиторием

После скачивания репозитория, у нас появилась директория redmine, перейдем в нее с помощью команды

    cd redmine/

В данной директории создадим файл .env, в котором будут описаны параметры окружения,со следующим содержанием

    MYSQL_DATABASE: db
    MYSQL_ROOT_PASSWORD=12345678
    DB_PATH=./databases

где:

MYSQL_DATABASE - имя базы mariadb, которая будет создана

MYSQL_ROOT_PASSWORD - пароль от базы

DB_PATH - директория, для локального хранения базы данных mariadb

Далее создадим файл docker-compose.yml со следующим содержанием:

    version: '3'

    services:
    nginx:
        image: nginx
        restart: always
        ports:
            - 60:80   
            
            
    mariadb:
        image: mariadb
        restart: always
        environment: 
            MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
            MYSQL_DATABASE: ${MYSQL_DATABASE}
        volumes: 
            - ${DB_PATH}:/var/lib/mysql

    redmine:
        image: redmine
        restart: always
        ports:
            - 6080:3000
            
Стоит обратить внимание на пункт ports, где изначально пишется локальный порт и порт в контейнере, вы можете запускать сервисы на любом свободном локальном порту вашей системы.

После проделанных действий мы можем запустить данный репозиторий с помощью команды 

    sudo docker-compose up

# Проверка работы

Для проверки переходим в браузер и пишем

    http://ip-адрес сервера:6080

Или же пишем команду

    http://localhost:6080

В результате выполнения данной команды мы перейдем на домашнюю страницу Redmine

# Выкладываем проект на GitHub

Для начала выполним команду для отслеживания измененных или добавленных файлов с помощью команды:

    git add .
    
Далее сделаем коммит

    git commit -m "имя коммита"

Также можем добавить файл .git ignore, чтобы git не отслеживал определенные файлы в данной директории

После проделанных действий выполняем команду

    git push origin

После выполнения данной команды у вас спросят логин и пароль учетной записи github
    
# Работа с Travis CI

Первоначально необходимо в нашем проекте создать файл .travis.yml со следующим содержанием

    language: bash

    servises:
    - docker

    script:
    - docker-compose --file ./docker-compose.yml up --detach 
    - docker-compose images

    deploy:
    provider: script
    script: bash push.sh
     on:
      branch: main
  
  Так же создаем файл для скрипта со следующим содержанием:
  
    #!/bin/bash
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker tag nginx vadim0209/nginx:latest
    docker push vadim0209/nginx
    docker tag mariadb vadim0209/mariadb:latest
    docker push vadim0209/mariadb
    docker tag redmine vadim0209/redmine:latest
    docker push vadim0209/redmine
  
  Далее мы переходим на сайт https://docs.travis-ci.com и синхронизируем свой аккаунт с аккаунтом GitHub, после чего мы увидим в Travis CI наш репозиторий
  
  Перед выполнением build мы заходим в настройки нашего проекта в Travis CI и добавляем необходимые переменные, где:
  
  DOCKER_USERNAME - наш логин от DockerHub
  
  DOCKER_PASSWORD - пароль от DockerHub
  
  После проделанных действий мы можем выполнить build, в результате наши образы будут выложены на DockerHub
  
