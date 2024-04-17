#!/bin/sh

WDIR=./

# shellcheck disable=SC2164
cd $WDIR

exec docker compose exec -T crmDB psql -U idon -d crm -f ./db_init/db_init.sql
