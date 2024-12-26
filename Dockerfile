# Base image
FROM postgres:latest

# Set environment variables
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydatabase

# Copy SQL files to the container
COPY ddl.sql /docker-entrypoint-initdb.d/ddl.sql
COPY test_data.sql /docker-entrypoint-initdb.d/test_data.sql

# Expose the PostgreSQL port
EXPOSE 5432

# Command to run the PostgreSQL server
CMD ["postgres"]