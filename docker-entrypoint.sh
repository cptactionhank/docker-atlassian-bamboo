#!/bin/bash

# check if the `server.xml` file has been changed since the creation of this
# Docker image. If the file has been changed the entrypoint script will not
# perform modifications to the configuration file.
if [ "$(stat -c "%Y" "${BAMBOO_INSTALL}/conf/server.xml")" -eq "0" ]; then
  if [ -n "${X_PROXY_NAME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8085"]' --type "attr" --name "proxyName" --value "${X_PROXY_NAME}" "${BAMBOO_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_PORT}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8085"]' --type "attr" --name "proxyPort" --value "${X_PROXY_PORT}" "${BAMBOO_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_SCHEME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8085"]' --type "attr" --name "scheme" --value "${X_PROXY_SCHEME}" "${BAMBOO_INSTALL}/conf/server.xml"
  fi
  if [ "${X_PROXY_SCHEME}" = "https" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8085"]' --type "attr" --name "secure" --value "true" "${BAMBOO_INSTALL}/conf/server.xml"
    xmlstarlet ed --inplace --pf --ps --update '//Connector[@port="8085"]/@redirectPort' --value "${X_PROXY_PORT}" "${BAMBOO_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PATH}" ]; then
    xmlstarlet ed --inplace --pf --ps --update '//Context/@path' --value "${X_PATH}" "${BAMBOO_INSTALL}/conf/server.xml"
  fi
fi

exec "$@"
