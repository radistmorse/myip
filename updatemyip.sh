#!/bin/bash

function valid_ip {
  local  ip=$1
  local  stat=1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
       && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return $stat
}

cd $(dirname $(realpath $0))
if [ ! -f config.sh ]; then
  echo "config file not found, will create one"
  echo "please, enter the username:"
  read username
  echo "please, enter the password:"
  read password
cat << EOF > config.sh
username="$username"
password="$password"
EOF
fi

curip=$(wget -q -O - http://ipinfo.io/ip)

if ! valid_ip $curip; then
  echo "Invalid IP: $curip"
  exit 0
fi

previp=$(head -n 1 currentip)

if [ "$curip" != "$previp" ]; then
  echo "updating IP to $curip"
  echo $curip > currentip
  git add currentip
  git commit -m "$(date)"
  repo=$(git remote -v | grep -oP "(?<=https:\/\/)[\S]*(?= \(push\))")

  source config.sh

  git push https://$username:$password@$repo
fi
