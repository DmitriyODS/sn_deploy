#!/bin/sh

WDIR=./

# shellcheck disable=SC2164
cd $WDIR

exec docker compose exec -T db psql -U idon -d network -f ./db_init/db_init.sql
