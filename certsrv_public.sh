#!/bin/bash
#Configs
DESTINATION=/path/to/destination
SCRIPT_LOCATION=/path/to/this/script.sh
MD5=/usr/bin/md5sum
SERVERNAME=certsrv_server
CERTNAME=certificate.cer
USERNAME=username
PASSWORD=password
MD5LOG=certs.md5
HOSTNAME=$(/usr/bin/hostname)
DAY=86400
WEEK=604800
MONTH=2628288
YEAR=31536000

cd $SCRIPT_LOCATION

# Check for changes outside of this script
if [ -e $DESTINATION/$CERTNAME.md5 ]; then
        $MD5 --quiet -c $MD5LOG
fi

# Make the DESTINATION
if ! [ -d $DESTINATION ]; then
        mkdir $DESTINATION
fi

# Grab cert
curl --http1.1 --silent -o $CERTNAME --user $USERNAME:$PASSWORD --ntlm "https://$SERVERNAME/certsrv/certnew.cer?ReqID=CACert&Renewal=5&Mode=inst&Enc=b64"

# Check if expiration is within $DAY/$WEEK/$MONTH/$YEAR
if ! openssl x509 -checkend $MONTH -noout -in $CERTNAME >/dev/null; then
        echo "Root Certificate is either expired, missing, or will expire within 30 days"
        echo "This check is running on $HOSTNAME"
fi

# Move Cert to HTTP exportable destination
cp $CERTNAME $DESTINATION

# Help the future admins
echo "This location managed on $HOSTNAME" > $DESTINATION/readme.txt

# Create .md5 for salt
$MD5 $DESTINATION/$CERTNAME > $DESTINATION/$CERTNAME.md5

# Calculate MD5
$MD5 $CERTNAME $DESTINATION/$CERTNAME > $MD5LOG

# Ensure sysadmin can change file
chgrp groupname $CERTNAME $MD5LOG
