# Data Pipeline Docker Compose Setup Documentation

This Docker Compose configuration orchestrates a data pipeline involving PostgreSQL, RabbitMQ, Logstash, and Elasticsearch. The primary objective is to automate the process of publishing messages from the PostgreSQL 'user table,' consuming these messages via Logstash from RabbitMQ, and indexing the data into Elasticsearch for further analysis.

## Project Overview

The project aims to establish a seamless data pipeline for real-time data processing and indexing using the following components:

### Components:

1. **PostgreSQL:** Serves as the primary data source with the 'usertable' acting as the source for data insertion.
2. **RabbitMQ:** Facilitates message queuing and acts as the intermediary for transmitting messages upon data insertion events in PostgreSQL.
3. **Logstash:** Consumes messages from RabbitMQ, processes them according to specified configurations, and prepares the data for indexing.
4. **Elasticsearch:** The indexed data storage where Logstash indexes the processed data for efficient querying and analysis.

## How the Data Pipeline Works

1. **Data Insertion:**
   - Data inserted into the 'usertable' triggers a message publication to RabbitMQ.
2. **Message Processing:**
   - Logstash, configured to consume messages from RabbitMQ, processes the received messages.
3. **Indexing:**
   - Logstash indexes the processed data into Elasticsearch for efficient querying.

## Testing the Data Pipeline

### Requirements:
- Docker and Docker Compose installed.
- Execute `docker-compose up` to ensure services are running.

### Testing Procedure:

1. **Insert Data into 'usertable':**
   - Insert data into the 'usertable' in PostgreSQL using your preferred method or client.
2. **Confirm Message Publication:**
   - Verify that a corresponding message has been published to RabbitMQ upon data insertion.
3. **Data Indexing Check:**
   - Access [http://localhost:9200/users/_search/?q=random](http://localhost:9200/users/_search/?q=random) to check for indexed data in Elasticsearch.
     - The URL queries Elasticsearch for indexed data under the 'users' index based on the 'random' query.

### Example Usage:

1. Insert data into the 'usertable' using PostgreSQL.
2. Visit [http://localhost:9200/users/_search/?q=random](http://localhost:9200/users/_search/?q=random) after inserting data to check for indexed results.

## Service Configuration and Customization

- Detailed configuration and setup for each service can be found in their respective directories (`./postgres`, `./rabbitmq`, `./logstash`, `./elasticsearch`).
- Modify configurations or add customizations based on specific application requirements within these service directories.

## Notes:

- Ensure that the data inserted into the 'usertable' adheres to the expected schema for seamless processing.
- Customizations and adjustments to the pipeline can be made within the service directories to fit unique project needs.

For further information or detailed configurations, refer to individual service directories and their respective configurations.
