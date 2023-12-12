FROM docker.elastic.co/logstash/logstash:8.7.0

# Copy the PostgreSQL JDBC driver to the external library folder of Logstash
COPY ./bin/ /usr/share/logstash/logstash-core/lib/jars/

# Copy all your pipelines to the Logstash config folder
COPY config/ /usr/share/logstash/config/

# Set the default Logstash configuration file
CMD ["logstash", "-f", "/usr/share/logstash/config/usersync.conf"]
