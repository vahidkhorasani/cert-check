#!/bin/bash

json_file="./body.json"
bearer="YOUR_BEARER_TOKEN_SITS_HERE"
webhook="YOUR_WEBHOOK_SITS_HERE"
domain=$(curl --insecure -vvI https://YOUR_DOMAIN_SITS_HERE 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'  | grep subject | cut -d"=" -f2)

sday=$(curl --insecure -vvI https://YOUR_DOMAIN_SITS_HERE 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep -i "start date" | cut -d":" -f2 | cut -d" " -f3)
smonth=$(curl --insecure -vvI https://YOUR_DOMAIN_SITS_HERE 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep -i "start date" | cut -d":" -f2 | cut -d" " -f2)
syear=$(curl --insecure -vvI https://YOUR_DOMAIN_SITS_HERE 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep -i "start date" | cut -d":" -f4 | cut -d" " -f2)
start=$(date -d"$sday $smonth $syear" +%Y-%m-%d)


day=$(curl --insecure -vvI https://YOUR_DOMAIN_SITS_HERE 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep expire | cut -d":" -f2 | cut -d" " -f3)
month=$(curl --insecure -vvI https://YOUR_DOMAIN_SITS_HERE 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep expire | cut -d":" -f2 | cut -d" " -f2)
year=$(curl --insecure -vvI https://YOUR_DOMAIN_SITS_HERE 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep expire | cut -d":" -f4 | cut -d" " -f2)
end=$(date -d"$day $month $year" +%Y-%m-%d)

expire_date=$(date -d"$day $month $year" +%Y%m%d)

now=$(date +%Y%m%d)
let ddiff=(`date +%s -d $expire_date`-`date +%s -d $now`)/86400

cat <<- EOF > $json_file
    {
    "domain" : "$domain",
    "start_date" : "$start",
    "end_date" : "$end"
    "message": "expiration will happen in $ddiff days"
    }
EOF

if [ $ddiff -lt 30 ]; then
    curl -X POST -H "Content-Type: application/json" --data @body.json --header "authorization: Bearer $bearer" $webhook
fi

