#! /bin/bash

echo This is a automatic script that deploys service to heroku based on alpine,novnc

heroku create

echo Type your application name:
read appname

echo If your name is correct, you can get it via https://$appname.heroku.com when it completes.

heroku container:login

heroku container:push web --app $appname

heroku container:release web --app $appname

echo Everything's done, https://$appname.herokuapp.com GO! , passwd presets by default is alpinelinux.
