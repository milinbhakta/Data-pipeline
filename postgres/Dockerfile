# base image
FROM postgres:13-alpine

# Copy initialization SQL script to container
COPY init.sql /docker-entrypoint-initdb.d/

# Install necessary dependencies
RUN apk update && \
    apk add --no-cache git make gcc libc-dev libxml2-dev alpine-sdk musl-dev postgresql-dev rabbitmq-c-dev

# Set working directory
WORKDIR /workdir

# Clone the repository
RUN git clone https://github.com/omniti-labs/pg_amqp.git .

# Set PG_CONFIG environment variable
ENV PG_CONFIG /usr/bin/pg_config

ARG AMQP_H=src/librabbitmq/amqp.h

RUN head -n 2 ${AMQP_H} > ${AMQP_H}.temp \
    && echo "#include <sys/types.h>" >>  ${AMQP_H}.temp \
    && cat ${AMQP_H} | sed -e '1,3d' >> ${AMQP_H}.temp \
    && mv ${AMQP_H}.temp ${AMQP_H}

# Build and install
RUN make && make install

# Start PostgreSQL with pg_amqp library loaded
CMD ["bash", "-c", "rm -rf /var/lib/postgresql/data/* && docker-entrypoint.sh postgres"]
