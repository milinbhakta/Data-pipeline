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

# Define a build argument for the path to the amqp.h file
ARG AMQP_H=src/librabbitmq/amqp.h

# Run a series of commands to modify the amqp.h file
RUN \
    # Copy the first two lines of amqp.h to a temporary file
    head -n 2 ${AMQP_H} > ${AMQP_H}.temp \
    # Append an include directive to the temporary file
    && echo "#include <sys/types.h>" >>  ${AMQP_H}.temp \
    # Append the rest of amqp.h, excluding the first three lines, to the temporary file
    && cat ${AMQP_H} | sed -e '1,3d' >> ${AMQP_H}.temp \
    # Replace the original amqp.h file with the modified temporary file
    && mv ${AMQP_H}.temp ${AMQP_H}

# Build and install
RUN make && make install

# Start PostgreSQL with pg_amqp library loaded
CMD ["bash", "-c", "rm -rf /var/lib/postgresql/data/* && docker-entrypoint.sh postgres"]
