#!/bin/sh
set -x
sudo /etc/init.d/pcscd start
firefox \
    -new-tab -url /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/hipki@chttl.com.tw.xpi \
    -new-tab -url https://rtn.tax.nat.gov.tw/ircweb/index.jsp \
    -new-tab -url https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mEventesting.htm
sudo /etc/init.d/pcscd stop
