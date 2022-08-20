#!/bin/sh
set -x

# Start smart card middleware
sudo pcscd -d -f | tee /tmp/pcscd.log &

# Start RAC Plugin
cd /usr/local/HiPKILocalSignServerApp && ./start.sh &

# Start plugin for health insurance card
sudo /usr/local/share/NHIICC/mLNHIICC &
sudo /usr/local/share/NHIICC/nhiicc --CertFile /usr/local/share/NHIICC/cert/NHIServerCert.crt --PrivateFileKey /usr/local/share/NHIICC/cert/NHIServerCert.key &

firefox \
    --profile ${HOME}/.mozilla/firefox/default \
    https://github.com/chihchun/personal-income-tax-docker/blob/master/README.md \
    https://efile.tax.nat.gov.tw/irxw/index.jsp \
    https://localhost:7777 \
    https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/webtesting/SampleY.aspx
    
