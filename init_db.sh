#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -a  <<-EOSQL

\c commune;

CREATE TABLE IF NOT EXISTS commune_user (
    firebase_id VARCHAR(100) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    profile_picture_url VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS event (
    id VARCHAR(100) PRIMARY KEY,
    created_timestamp_utc TIMESTAMP NOT NULL,
    last_updated_timestamp_utc TIMESTAMP NOT NULL,
    firebase_owner_id VARCHAR(100) NOT NULL,
    starting_timestamp_utc TIMESTAMP NOT NULL,
    ending_timestamp_utc TIMESTAMP NOT NULL,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(1000) NOT NULL,
    CHECK (starting_timestamp_utc >= created_timestamp_utc AND ending_timestamp_utc > starting_timestamp_utc),
    CONSTRAINT fk_owner FOREIGN KEY(firebase_owner_id) REFERENCES commune_user(firebase_id)
);

CREATE TABLE IF NOT EXISTS friendship (
    requester VARCHAR(100) NOT NULL,
    recipient VARCHAR(100) NOT NULL,
    created_timestamp_utc TIMESTAMP NOT NULL,
    PRIMARY KEY(requester, recipient),
    CONSTRAINT fk_requester FOREIGN KEY(requester) REFERENCES commune_user(firebase_id),
    CONSTRAINT fk_recipient FOREIGN KEY(recipient) REFERENCES commune_user(firebase_id)
);

CREATE TYPE invitation_status_type AS ENUM ('ACCEPTED', 'DECLINED', 'PENDING');

CREATE TABLE IF NOT EXISTS invitation (
    id VARCHAR(100) PRIMARY KEY,
    created_timestamp_utc TIMESTAMP NOT NULL,
    last_updated_timestamp_utc TIMESTAMP NOT NULL,
    event_id VARCHAR(100) NOT NULL,
    sender_id VARCHAR(100) NOT NULL,
    recipient_id VARCHAR(100) NOT NULL,
    status invitation_status_type NOT NULL,
    expiration_timestamp_utc TIMESTAMP NOT NULL,
    CONSTRAINT fk_invitation_event FOREIGN KEY(event_id) REFERENCES event(id),
    CONSTRAINT fk_invitation_sender FOREIGN KEY(sender_id) REFERENCES commune_user(firebase_id),
    CONSTRAINT fk_invitation_recipient FOREIGN KEY(recipient_id) REFERENCES commune_user(firebase_id)
);


EOSQL
