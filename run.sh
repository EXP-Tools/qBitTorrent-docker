#!/bin/bash
# 运行 qBitTorrent 服务
#------------------------------------------------
# 命令执行示例：
# ./run.sh -u admin -p 123456
#------------------------------------------------

USERNAME="admin"
PASSWORD="123456"

set -- `getopt u:p: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -u) USERNAME="$2"
        shift ;;
    -p) PASSWORD="$2"
        shift ;;
  esac
  shift
done

username=${USERNAME} pass_md5=${PASSWORD} docker-compose up -d
