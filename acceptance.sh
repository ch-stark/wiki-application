#!/usr/bin/env sh

./wiki &
WIKI_ID=$!

cleanup() {
    kill -9 $WIKI_ID
}
trap cleanup 0 INT

curl 'http://localhost:8080/save/doc'
curl 'http://localhost:8080/save/doc'  -H 'Content-Type: application/x-www-form-urlencoded'    --data 'body=hellotestbenchwashere'

if ! [ -x "$(command -v ab)" ]; then
    echo installing ab
    apt-get update
    apt-get install apache2-utils
fi

ACCEPTENCE_RATE=1000
CURRENT_RATE=$(printf  %.0f `ab -k  -T 'application/x-www-form-urlencoded'    -n 1000 -c 1 'http://localhost:8080/view/doc' | grep 'Requests per second' | grep -oE [0-9]+.[0-9]+ `)
if [ $CURRENT_RATE -gt $ACCEPTENCE_RATE ]
then
    echo Current Rate: $CURRENT_RATE
    echo PASS
else
   echo Acceptance Criteria Failed: $ACCEPTENCE_RATE
   echo Current Rate: $CURRENT_RATE
   exit 1
fi

