#!/bin/bash

STATUS="$(git status | egrep '(Changes .*? commit(ted)?:)|(Your branch is behind)')"
if [ -n "$STATUS" ]; then
  echo "========> Existem arquivos alterados ou novos arquivos sem commit"
  exit 1;
fi

BRANCH=$1
if [ -z $BRANCH ]; then
  echo "========> Passe como parâmetro o nome do branch"
  exit 1;
fi

BRANCH_EXIST=$(git branch | grep "\b${branch}\b")
if [ -z "$BRANCH_EXIST" ]; then
  echo "========> Branch não existe"
  exit 1;
fi

git checkout $BRANCH

heroku login

USER=`whoami`
HEROKU_APP_NAME="graphql-todo-$USER"
BASE_URL="https://$HEROKU_APP_NAME.herokuapp.com"

echo " "
echo "========> Apagando ambiente no heroku..."
heroku apps:destroy $HEROKU_APP_NAME --confirm $HEROKU_APP_NAME

echo " "
echo "========> Criando ambiente no heroku..."
heroku create $HEROKU_APP_NAME


echo " "
echo "========> Setting buildpacks..."
heroku buildpacks:add jontewks/puppeteer --app $HEROKU_APP_NAME
heroku buildpacks:add heroku/nodejs --app $HEROKU_APP_NAME


echo " "
echo "========> Enviando o projeto para o heroku..."
git push heroku $BRANCH:master


echo " "
echo "========> Escalando o ambiente no heroku..."
heroku ps:scale web=1 --app $HEROKU_APP_NAME
heroku ps:scale worker=1 --app $HEROKU_APP_NAME

echo " "
echo "========> Configurando variáveis de ambiente no heroku..."
heroku config:set \
  BASE_URL="$BASE_URL" \
  --app $HEROKU_APP_NAME

echo " "
echo "========> Ambiente criado com sucesso!"

heroku open --app $HEROKU_APP_NAME
git remote remove heroku
