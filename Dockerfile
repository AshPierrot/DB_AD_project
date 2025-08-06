FROM postgres:latest

# Works only locally 
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydatabase

COPY ddl.sql /docker-entrypoint-initdb.d/ddl.sql
COPY test_data.sql /docker-entrypoint-initdb.d/test_data.sql

EXPOSE 5432
CMD ["postgres"]
