# Use the rabbitmq management image as the base
FROM rabbitmq:management

# Add the definitions file to the rabbitmq configuration directory
# The --chown option changes the owner of the added file to rabbitmq
ADD --chown=rabbitmq ./definitions.json /etc/rabbitmq/

# Set an environment variable to load the definitions file on server start
# This allows us to pre-configure the rabbitmq server
ENV RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS="-rabbitmq_management load_definitions \"/etc/rabbitmq/definitions.json\""