#!/bin/bash

echo " "
echo "========> Iniciando ambiente..."
docker-compose up -d && STATUS=0 || STATUS=1

if [[ $STATUS -ne 0 ]]; then
  echo " "
  echo "========> Erro ao iniciar ambiente!"
  docker-compose down
  exit 1
fi

docker-compose exec app npm install

./scripts/server.sh
