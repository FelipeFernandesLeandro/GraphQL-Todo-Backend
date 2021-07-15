#!/bin/bash

STATUS="$(git status | egrep '(Changes .*? commit(ted)?:)|(Your branch is behind)')"
if [ -n "$STATUS" ]; then
  echo "========> Existe arquivos alterados ou novos arquivos sem commit"
  exit 1;
fi

BRANCH=$1
if [ -z $BRANCH ]; then
  echo "========> Passe como parametro o nome do branch"
  exit 1;
fi

BRANCH_EXIST=$(git branch | grep "\b${branch}\b")
if [ -z "$BRANCH_EXIST" ]; then
  echo "========> Branch não existe"
  exit 1;
fi

git checkout $BRANCH

heroku login

HEROKU_APP_NAME="graphql-todo-$USER"
HEROKU_GIT_URL="https://git.heroku.com/$HEROKU_APP_NAME.git"

echo " "
echo "========> Adicionando git remote do heroku..."
git remote add heroku $HEROKU_GIT_URL

echo " "
echo "========> Atualizando o projeto no heroku..."
git push heroku $BRANCH:master

echo " "
echo "========> Ambiente atualizado com sucesso!"

heroku open --app $HEROKU_APP_NAME
git remote remove heroku
