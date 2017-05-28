#!/bin/sh
set -x

# Start smart card middleware
sudo /etc/init.d/pcscd start

# Start plugin for health insurance card
sudo /usr/local/src/mLNHIICC_Setup/mLNHIICC start

# install the new key
(sleep 5 && \
certutil -A -n "COMODO RSA Organization Validation Secure Server CA (SHA-2)" -t "TC,C,Tw" -i/usr/local/share/ca-certificates/comodorsaorganizationvalidationsecureserverca.crt \
    -d /home/firefox/.mozilla/firefox/*.default && \
certutil -A -n "Comodo RSA Domain Validation Secure Server CA" -t "TC,C,Tw" -i/usr/local/share/ca-certificates/comodorsadomainvalidationsecureserverca.crt \
    -d /home/firefox/.mozilla/firefox/*.default && \
    certutil -L -d /home/firefox/.mozilla/firefox/*.default
    ) &

firefox \
    -new-tab -url /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/hipki@chttl.com.tw.xpi \
    -new-tab -url https://rtn.tax.nat.gov.tw/ircweb/index.jsp \
    -new-tab -url https://iccert.nhi.gov.tw:7777

sudo /etc/init.d/pcscd stop
sudo /usr/local/src/mLNHIICC_Setup/mLNHIICC stop