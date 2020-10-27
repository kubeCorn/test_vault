FROM postgres:10.14

ENV POSTGRES_DB postgresdb
ENV POSTGRES_USER postgresadmin
ENV POSTGRES_PASSWORD admin123

COPY init_user_db.sh /docker-entrypoint-initdb.d/
RUN chown postgres:postgres /docker-entrypoint-initdb.d/*.s*
