#!/bin/sh

MYUSER="keybox"
MYGID="10020"
MYUID="10020"
OS=""

DectectOS(){
  if [ -e /etc/alpine-release ]; then
    OS="alpine"
  elif [ -e /etc/os-release ]; then
    if grep -q "NAME=\"Ubuntu\"" /etc/os-release ; then
      OS="ubuntu"
    fi
    if grep -q "NAME=\"CentOS Linux\"" /etc/os-release ; then
      OS="centos"
  fi
}

AutoUpgrade(){
  if [ "${OS}" == "alpine" ]; then
    apk --no-cache upgrade
    rm -rf /var/cache/apk/*
  elif [ "${OS}" == "ubuntu" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -y --no-install-recommends dist-upgrade
    apt-get -y autoclean
    apt-get -y clean
    apt-get -y autoremove
    rm -rf /var/lib/apt/lists/*
  elif [ "${OS}" == "centos" ]; then
    yum upgrade -y
    yum clean all
    rm -rf /var/cache/yum/*
  fi
}

ConfigureUser () {
  # Managing user
  if [ -n "${DOCKUID}" ]; then
    MYUID="${DOCKUID}"
  fi
  # Managing group
  if [ -n "${DOCKGID}" ]; then
    MYGID="${DOCKGID}"
  fi
  local OLDHOME
  local OLDGID
  local OLDUID
  if grep -q "${MYUSER}" /etc/passwd; then
    OLDUID=$(id -u "${MYUSER}")
    OLDGID=$(id -g "${MYUSER}")
    if [ "${DOCKUID}" != "${OLDUID}" ]; then
      OLDHOME=$(grep "$MYUSER" /etc/passwd | awk -F: '{print $6}')
      deluser "${MYUSER}"
      logger "Deleted user ${MYUSER}"
    fi
    if /bin/grep -q "${MYUSER}" /etc/group; then
      local OLDGID=$(/usr/bin/id -g "${MYUSER}")
      if [ "${DOCKGID}" != "${OLDGID}" ]; then
        delgroup "${MYUSER}"
      else
        groupdel "${MYUSER}"
      fi
        logger "Deleted group ${MYUSER}"
      fi
    fi
  fi
  if ! grep -q "${MYUSER}" /etc/group; then
    if [ "${OS}" == "alpine" ]; then
      addgroup -S -g "${MYGID}" "${MYUSER}"
  fi
  if ! grep -q "${MYUSER}" /etc/passwd; then
    adduser -S -D -H -s /sbin/nologin -G "${MYUSER}" -h "${OLDHOME}" -u "${MYUID}" "${MYUSER}"
  fi
  if [ -n "${OLDUID}" ] && [ "${DOCKUID}" != "${OLDUID}" ]; then
    find / -user "${OLDUID}" -exec chown ${MYUSER} {} \;
  fi
  if [ -n "${OLDGID}" ] && [ "${DOCKGID}" != "${OLDGID}" ]; then
    find / -group "${OLDGID}" -exec chgrp ${MYUSER} {} \;
  fi
}

DectectOS
AutoUpgrade
ConfigureUser

if [ "$1" = 'keybox' ]; then
  echo resetApplicationSSHKey=${resetApplicationSSHKey:-false} > /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo sshKeyType=${sshKeyType:-rsa} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo sshKeyLength=${sshKeyLength:-2048} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo privateKey=${privateKey:-} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo publicKey=${publicKey:-} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo defaultSSHPassphrase=${defaultSSHPassphrase:-'${randomPassphrase}'} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo enableInternalAudit=${enableInternalAudit:-false} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo deleteAuditLogAfter=${deleteAuditLogAfter:-90} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo serverAliveInterval=${serverAliveInterval:-60} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo websocketTimeout=${websocketTimeout:-0} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo agentForwarding=${agentForwarding:-false} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo oneTimePassword=${oneTimePassword:-optional} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo keyManagementEnabled=${keyManagementEnabled:-true} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo forceUserKeyGeneration=${forceUserKeyGeneration:-true} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo authKeysRefreshInterval=${authKeysRefreshInterval:-120} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo passwordComplexityRegEx=${passwordComplexityRegEx:-'((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*()+=]).{8\,20})'} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo passwordComplexityMsg=${passwordComplexityMsg:-'Passwords must be 8 to 20 characters\, contain one digit\, one lowercase\, one uppercase\, and one special character'} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo clientIPHeader=${clientIPHeader:-} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo jaasModule=${jaasModule:-} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties

  echo dbPath=${dbPath:-} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo maxActive=${maxActive:-25} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo testOnBorrow=${testOnBorrow:-true} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo minIdle=${minIdle:-2} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties
  echo maxWait=${maxWait:-15000} >> /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/KeyBoxConfig.properties


  #link database directory
  rm -rf /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/keydb
  ln -sf /a/keydb /opt/KeyBox-jetty/jetty/keybox/WEB-INF/classes/

  exec cd /opt/KeyBox-jetty/jetty/ && java -Xmx1024m -jar start.jar
fi

exec "$@"
