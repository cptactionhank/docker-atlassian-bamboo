FROM openjdk:8

# Setup useful environment variables
ENV BAMBOO_HOME     /var/atlassian/bamboo
ENV BAMBOO_INSTALL  /opt/atlassian/bamboo
ENV BAMBOO_VERSION  6.0.3
ENV SUPERVISOR_CONF /etc/supervisor/conf.d/supervisord.conf

# Install Atlassian Bamboo and helper tools and setup initial home
# directory structure.
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends xmlstarlet \
    && curl --silent https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install --quiet --yes --no-install-recommends git-lfs \
    && git lfs install \
    && apt-get install --quiet --yes --no-install-recommends -t jessie-backports libtcnative-1 \
    && apt-get install --quiet --yes --no-install-recommends supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/supervisor \
    && chmod -R 700           /var/log/supervisor \
    && chown -R daemon:daemon /var/log/supervisor \
    && mkdir -p /opt/run/supervisor \
    && chmod -R 700           /opt/run/supervisor \
    && chown -R daemon:daemon /opt/run/supervisor \
    && echo "[supervisord]" >> ${SUPERVISOR_CONF} \
    && echo "nodaemon=true" >> ${SUPERVISOR_CONF} \
    && echo "pidfile=/opt/run/supervisor/supervisord.pid" >> ${SUPERVISOR_CONF} \
    && echo "[program:bamboo]" >> ${SUPERVISOR_CONF} \
    && echo "command=/opt/atlassian/bamboo/bin/start-bamboo.sh -fg" >> ${SUPERVISOR_CONF} \
    && echo "directory=/var/atlassian/bamboo" >> ${SUPERVISOR_CONF} \
    && echo "user=daemon" >> ${SUPERVISOR_CONF} \
    && echo "autorestart=true" >> ${SUPERVISOR_CONF} \
    && chmod -R 700   /etc/supervisor/conf.d/supervisord.conf \
    && chown -R daemon:daemon /etc/supervisor/conf.d/supervisord.conf \
    && mkdir -p               "${BAMBOO_HOME}/lib" \
    && chmod -R 700           "${BAMBOO_HOME}" \
    && chown -R daemon:daemon "${BAMBOO_HOME}" \
    && mkdir -p               "${BAMBOO_INSTALL}" \
    && curl -Ls               "https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz" | tar -zx --directory  "${BAMBOO_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -Ls                "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz" | tar -xz --directory "${BAMBOO_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar" \
    && chmod -R 700           "${BAMBOO_INSTALL}" \
    && chown -R daemon:daemon "${BAMBOO_INSTALL}" \
    && sed --in-place         's/^# umask 0027$/umask 0027/g' "${BAMBOO_INSTALL}/bin/setenv.sh" \
    && xmlstarlet             ed --inplace \
        --delete              "Server/Service/Engine/Host/@xmlValidation" \
        --delete              "Server/Service/Engine/Host/@xmlNamespaceAware" \
                              "${BAMBOO_INSTALL}/conf/server.xml" \
    && touch -d "@0"          "${BAMBOO_INSTALL}/conf/server.xml"


# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
USER daemon:daemon

# Expose default HTTP and SSH ports.
EXPOSE 8085 54663

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/bamboo","/opt/atlassian/bamboo/logs"]

# Set the default working directory as the Bamboo home directory.
WORKDIR /var/atlassian/bamboo

COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run supervisor which starts Atlassian Bamboo as a foreground process by default. It also takes care of orphaned ssh processes.
CMD ["/usr/bin/supervisord", "--config=/etc/supervisor/conf.d/supervisord.conf"]
