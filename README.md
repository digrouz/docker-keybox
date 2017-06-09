# docker-keybox
Installs KeyBox into a Linux container

![KeyBox](http://sshkeybox.com/img/keybox_40x40.png)

## Description

KeyBox is an open-source web-based SSH console that centrally manages administrative access to systems.

A bastion host for administrators with features that promote infrastructure security, including key management and auditing

http://sshkeybox.com

## Usage

    docker create --name=keybox  \
      -v /etc/localtime:/etc/localtime:ro \
      -v <path to db>:/db \
      -e DOCKUID=<UID default:10020> \
      -e DOCKGID=<GID default:10020> \
      -p 8443:8443 ndgconsulting/docker-keybox

## Environment Variables

When you start the `keybox` image, you can adjust the configuration of the `keybox` instance by passing one or more environment variables on the `docker run` command line.

### `DOCKUID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `10020`.

### `DOCKGID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `10020`.

All possible environment variables with their default values are listed below.

### `resetApplicationSSHKey`

set to true to regenerate and import SSH keys. It has default value `false`

### `sshKeyType`

SSH key type 'dsa', 'rsa', or 'ecdsa' for generated keys. It has default value `rsa`

### `sshKeyLength`

SSH key length for generated keys. 2048 => 'rsa','dsa'; 521 => 'ecdsa'. It has default value `2048`

### `privateKey`

private ssh key, leave blank to generate key pair.

### `publicKey`

public ssh key, leave blank to generate key pair.

### `defaultSSHPassphrase`

default passphrase, leave blank for key without passphrase. It has default value `${randomPassphrase}`

### `enableInternalAudit`

enable audit. It has default value `false`

### `deleteAuditLogAfter`

keep audit logs for in days. It has default value `90`

### `serverAliveInterval`

The number of seconds that the client will wait before sending a null packet to the server to keep the connection alive. It has default value `60`

### `websocketTimeout`

default timeout in minutes for websocket connection (no timeout for <=0). It has default value `0`

### `agentForwarding`

enable SSH agent forwarding. It has default value `false`

### `oneTimePassword`

enable two-factor authentication with a one-time password - 'required', 'optional', or 'disabled'. It has default value `optional`

### `keyManagementEnabled`

set to false to disable key management. If false, the KeyBox public key will be appended to the authorized_keys file (instead of it being overwritten completely). It has default value `true`

### `forceUserKeyGeneration`

set to true to generate keys when added/managed by users and enforce strong passphrases set to false to allow users to set their own public key. It has default value `true`

### `authKeysRefreshInterval`

authorized_keys refresh interval in minutes (no refresh for <=0). It has default value `120`

### `passwordComplexityRegEx`

Regular expression to enforce password policy. It has default value `((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*()+=]).{8\,20})`

### `passwordComplexityMsg`

Password complexity error message. It has default value `Passwords must be 8 to 20 characters\, contain one digit\, one lowercase\, one uppercase\, and one special character`

### `clientIPHeader`

HTTP header to identify client IP Address - 'X-FORWARDED-FOR'.

### `jaasModule`

Specify a external authentication module (ex: ldap-ol, ldap-ad). Edit the `jaas.conf` to set connection details.

### `dbPath=`

Path to the H2 DB file. Leave Blank to use default location. It has default value `../WEB-INF/classes/keydb`

### `maxActive`

Max connections in the connection pool. It has default value `25`

### `testOnBorrow`

When true, objects will be validated before being returned by the connection pool. It has default value `true`

### `minIdle`

The minimum number of objects allowed in the connection pool before spawning new ones. It has default value `2`

### `maxWait`

The maximum amount of time (in milliseconds) to block before throwing an exception when the connection pool is exhausted. It has default value `15000`

## Notes

* The docker entrypoint will upgrade operating system at each startup.