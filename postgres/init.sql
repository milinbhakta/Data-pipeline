-- Adjust PostgreSQL configuration to enable logical replication
ALTER SYSTEM SET wal_level = logical;

-- Change the password for the 'postgres' user
ALTER USER postgres WITH PASSWORD 'postgres';

-- Create the 'amqp' extension
CREATE EXTENSION IF NOT EXISTS amqp;

-- Alter the table 'amqp.broker' to add a column
ALTER TABLE amqp.broker ADD COLUMN name VARCHAR(32) NOT NULL;

-- Insert values into the 'amqp.broker' table
INSERT INTO amqp.broker (name, host, port, vhost, username, password)
VALUES ('rabbit1', 'rabbitmq', 5672, '/', 'guest', 'guest');

-- Create the function PUBLISH_USER_INSERTION()
CREATE OR REPLACE FUNCTION PUBLISH_USER_INSERTION() 
RETURNS TRIGGER AS $$
BEGIN
    PERFORM amqp.publish(
        1, -- Broker ID
        'PostgresExchange', -- Exchange name
        'userInserted', -- Routing key
        row_to_json(NEW)::text -- Message
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop the table 'USERS' if it exists
DROP TABLE IF EXISTS USERS;

-- Create the table 'USERS'
CREATE TABLE USERS (
  USER_ID SERIAL PRIMARY KEY,
  USERNAME VARCHAR(50) UNIQUE NOT NULL,
  USER_EMAIL VARCHAR(255) UNIQUE NOT NULL,
  USER_FIRST_NAME VARCHAR(20) NOT NULL,
  USER_LAST_NAME VARCHAR(20) NOT NULL,
  USER_BIRTHDATE DATE NOT NULL,
  CREATED_ON TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  LAST_UPDATE TIMESTAMP
);

-- Create the trigger 'USER_INSERTION_AMQP_PUBLISH'
CREATE TRIGGER USER_INSERTION_AMQP_PUBLISH 
    AFTER INSERT ON USERS 
    FOR EACH ROW 
    EXECUTE FUNCTION PUBLISH_USER_INSERTION();

-- Insert values into the 'USERS' table
INSERT INTO USERS (
  USERNAME,
  USER_EMAIL,
  USER_FIRST_NAME,
  USER_LAST_NAME,
  USER_BIRTHDATE,
  CREATED_ON,
  LAST_UPDATE
) VALUES 
(
  'cwenga',
  'cwenga@carml.ai',
  'carmel',
  'wenga',
  '1990-09-20',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  'smenguope',
  'smenguope@carml.ai',
  'suzie',
  'menguope',
  '1992-11-13',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  'cdiogni',
  'cdiogni@carml.ai',
  'christian',
  'diogni',
  '1992-10-13',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
);
