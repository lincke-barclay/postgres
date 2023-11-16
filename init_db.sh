#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -a  <<-EOSQL

\c communeo;

CREATE TABLE IF NOT EXISTS commune_user (
    firebase_id VARCHAR(100) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS event (
    id VARCHAR(100) PRIMARY KEY,
    created_timestamp_utc TIMESTAMP NOT NULL,
    last_updated_timestamp_utc TIMESTAMP NOT NULL,
    firebase_owner_id VARCHAR(100) NOT NULL,
    starting_timestamp_utc TIMESTAMP NOT NULL,
    ending_timestamp_utc TIMESTAMP NOT NULL,
    title VARCHAR(100) NOT NULL,
    short_description VARCHAR(200) NOT NULL,
    long_description VARCHAR(1000) NOT NULL,
    CHECK (starting_timestamp_utc >= created_timestamp_utc AND ending_timestamp_utc > starting_timestamp_utc),
    CONSTRAINT fk_owner FOREIGN KEY(firebase_owner_id) REFERENCES commune_user(firebase_id)
);



CREATE TYPE friend_status_type AS ENUM ('ACCEPTED', 'PENDING');

CREATE TABLE IF NOT EXISTS friendship (
    requester VARCHAR(100) NOT NULL,
    recipient VARCHAR(100) NOT NULL,
    friend_status friend_status_type,
    created_timestamp_utc TIMESTAMP NOT NULL,
    last_updated_timestamp_utc TIMESTAMP NOT NULL,
    PRIMARY KEY(requester, recipient),
    CONSTRAINT fk_requester FOREIGN KEY(requester) REFERENCES commune_user(firebase_id),
    CONSTRAINT fk_recipient FOREIGN KEY(recipient) REFERENCES commune_user(firebase_id)
);


EOSQL
