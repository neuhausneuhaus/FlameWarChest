-- DROP TABLE IF EXISTS users, topics, comments;
DROP DATABASE IF EXISTS flame_forum;
CREATE DATABASE flame_forum;

\c flame_forum;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  fname VARCHAR NOT NULL,
  lname VARCHAR NOT NULL,
  handle VARCHAR NOT NULL,
  email VARCHAR NOT NULL UNIQUE,
  password VARCHAR NOT NULL,
  date_joined TIMESTAMP NOT NULL,
  bio VARCHAR,
  user_img_url VARCHAR,
  user_karma INTEGER DEFAULT 0,
  is_admin BOOL NOT NULL DEFAULT 'F'
  -- +friends
);

CREATE TABLE topics (
  id SERIAL PRIMARY KEY,
  topic_creator_id INTEGER REFERENCES users(id), --(see tweeter/db/schema.sql)
    --^^foreign key^^
  topic_title VARCHAR NOT NULL,
  topic_subtitle VARCHAR NOT NULL,
  topic_created_date TIMESTAMP NOT NULL,
  topic_karma INTEGER DEFAULT 0

  -- +hashes
  -- +subscribers
  -- +participants?
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  comment_created_date TIMESTAMP NOT NULL,
  parent_topic_id INTEGER NOT NULL REFERENCES topics(id),
    --^^foreign key^^
  comment_creator_id INTEGER NOT NULL REFERENCES users(id),
    --^^foreign key^^
  comment_content VARCHAR NOT NULL,
  comment_counter INTEGER DEFAULT 1,
  comment_karma INTEGER DEFAULT 0
);

CREATE TABLE karma (
  id SERIAL PRIMARY KEY,
  voter_id INTEGER NOT NULL REFERENCES users(id), 
  topic_id INTEGER NOT NULL REFERENCES topics(id),
  vote_value INTEGER NOT NULL DEFAULT 0 CHECK(vote_value <= 1 and vote_value >= -1) 
);
