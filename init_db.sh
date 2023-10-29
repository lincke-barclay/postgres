#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -a  <<-EOSQL

\c communeo;

CREATE TABLE IF NOT EXISTS events (
    id serial PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    short_description VARCHAR(500) NOT NULL,
    long_description VARCHAR(500) NOT NULL,
    firebase_owner_id VARCHAR(100) NOT NULL,
    created_datetime_utc TIMESTAMP NOT NULL,
    starting_datetime_utc TIMESTAMP NOT NULL,
    ending_datetime_utc TIMESTAMP NOT NULL,
    CHECK (starting_datetime_utc > created_datetime_utc AND ending_datetime_utc > starting_datetime_utc)
);

CREATE TYPE friend_status_type AS ENUM ('accepted', 'pending');

CREATE TABLE IF NOT EXISTS friendships (
    requester VARCHAR(100) NOT NULL,
    recipient VARCHAR(100) NOT NULL,
    friend_status friend_status_type,
    PRIMARY KEY(requester, recipient)
);
EOSQL