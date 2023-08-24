#!/bin/sh

if [ -z "$1" ]; then
    echo "Missing argument: no command arguments to launch";
    exit 1;
fi

echo "Starting command: $@";

_term() {
  kill -TERM $CHILD 2>/dev/null
  wait $CHILD
}

trap _term TERM
trap _term SIGTERM
trap _term QUIT
trap _term SIGQUIT

while true; do
    $@ &
    CHILD=$!
    wait $CHILD

    STATUS=$?

    if [ $STATUS -ne 0 ]; then
        echo "Command exited with status code $STATUS, loop interrupted";
        exit $STATUS;
    fi
done
