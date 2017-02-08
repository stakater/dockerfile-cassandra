FROM                stakater/java8-alpine

MAINTAINER          Ahmad Iqbal <ahmad@aurorasolutions.io>

ARG                 CASSANDRA_VERSION

ENV CASSANDRA_VER        $CASSANDRA_VERSION
ENV CASSANDRA_HOME       /usr/local/apache-cassandra-${CASSANDRA_VER}
ENV CASSANDRA_CONF       ${CASSANDRA_HOME}/conf
ENV CASSANDRA_DATA       ${CASSANDRA_HOME}/data
ENV CASSANDRA_LOGS       ${CASSANDRA_HOME}/logs

## default
ENV CASSANDRA_CLUSTER_NAME            'Test Cluster'
ENV CASSANDRA_DATA_FILE_DIRECTORIES   ["${CASSANDRA_DATA}/data"]
ENV CASSANDRA_COMMITLOG_DIRECTORY     ${CASSANDRA_DATA}/commitlog
ENV CASSANDRA_SAVED_CACHES_DIRECTORY  ${CASSANDRA_DATA}/saved_caches
ENV CASSANDRA_HINTS_DIRECTORY         ${CASSANDRA_DATA}/hints

ENV PATH       $PATH:${CASSANDRA_HOME}/bin

RUN set -x \
    && apk update \
    && apk --no-cache add \
        jemalloc \
        libc6-compat \
        python \
        su-exec

RUN wget -q http://www.apache.org/dist/cassandra/3.9/apache-cassandra-${CASSANDRA_VER}-bin.tar.gz \
    && tar -xzf apache-cassandra-${CASSANDRA_VER}-bin.tar.gz -C /usr/local \
    ## user/dir/permission
    && adduser -D  -g '' -s /sbin/nologin cassandra \
    ## cleanup
    && rm -rf \
        ${CASSANDRA_HOME}/bin/*.bat \
        ${CASSANDRA_HOME}/doc \
        ${CASSANDRA_HOME}/javadoc 

COPY entrypoint.sh  /usr/local/bin/

WORKDIR ${CASSANDRA_HOME}

VOLUME ["${CASSANDRA_HOME}"]

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160

ENTRYPOINT ["entrypoint.sh"]
CMD ["cassandra", "-f"]
