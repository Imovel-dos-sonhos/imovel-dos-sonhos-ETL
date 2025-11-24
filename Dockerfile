FROM postgres:15-alpine

COPY ./DataLayer/silver/ddl.sql /docker-entrypoint-initdb.d/ddl.sql

RUN chmod 755 /docker-entrypoint-initdb.d/ddl.sql
