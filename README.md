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

## Notes

* The docker entrypoint will upgrade operating system at each startup.