# certsrv
This repo contains a method for automatic copying of the Windows based CA's public key

## Requirements
### Software:
openssl
### Accounts
Account in AD with permissions to view certsrv key
Local account with write permissions to $DESTINATION

## Methodology
Step 1: Quick validation that the remote copy of the known cert in $DESTINATION has not changed outside of this script

Step 2: Curl attempts ntlm authentication against the certificate authority to grab the public key

Step 3: Validate that the current public key does not expire in a defined amount of time

Step 4: Move cert into $DESTINATION

Step 5: Create HTTP-viewable .md5 for SALT to store/force updates

Step 6: Renew the MD5 log for Step 1 on the next pass

Step 7: Set permissions to group x to avoid a single account being stuck running this.

## Authors
Nathaniel Middleton
