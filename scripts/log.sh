#!/bin/bash

USER=`whoami`
HEROKU_APP_NAME="graphql-todo-$USER"

echo " "
echo "========> Exibindo log do heroku..."
heroku logs -t --app $HEROKU_APP_NAME
