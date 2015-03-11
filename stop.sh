#!/bin/bash -x

if [ -z "$JEKYLL_ROOT" ]; then
    export JEKYLL_ROOT=/var/www/deweing.github.io/;
fi

if [ -z "$JEKYLL_LOG_ROOT" ]; then
    export JEKYLL_LOG_ROOT=/var/logs/;
fi

ps auxf|grep "jekyll serve"|grep -v grep|awk {'print $2'}|xargs kill -9

echo "wait for jekyll to exit...."
echo "done"
cd ${JEKYLL_ROOT}>/dev/null

