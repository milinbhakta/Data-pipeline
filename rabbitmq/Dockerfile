FROM rabbitmq:management

ADD --chown=rabbitmq ./definitions.json /etc/rabbitmq/

ENV RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS="-rabbitmq_management load_definitions \"/etc/rabbitmq/definitions.json\""