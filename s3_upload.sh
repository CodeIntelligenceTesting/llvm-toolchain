#!/usr/bin/env bash
# Upload a file to an s3 store using only curl.

set -euo pipefail

date=`date +%Y%m%d`
dateFormatted=`date -R`
s3Bucket="llvm"
fileName="$1"
relativePath="/${s3Bucket}/${fileName}"
contentType="application/octet-stream"
stringToSign="PUT\n\n${contentType}\n${dateFormatted}\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${S3_SECRET_KEY} -binary | base64`
curl -X PUT -T "${fileName}" \
    -H "Host: ${s3Bucket}.obs.eu-de.otc.t-systems.com" \
    -H "Date: ${dateFormatted}" \
    -H "Content-Type: ${contentType}" \
    -H "Authorization: AWS ${S3_ACCESS_KEY}:${signature}" \
    https://${s3Bucket}.obs.eu-de.otc.t-systems.com/${fileName}
