#!/bin/sh
set -x
sudo /etc/init.d/pcscd start

# Start plugin for health insurance card
sudo su -c "/tmp/health_insurance_card/mLNHIICC_Setup/mLNHIICC start"

# Check health insurance card plugin status
/tmp/health_insurance_card/mLNHIICC_Setup/mLNHIICC status

firefox \
    -new-tab -url /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/hipki@chttl.com.tw.xpi \
    -new-tab -url https://rtn.tax.nat.gov.tw/ircweb/index.jsp \
    -new-tab -url https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mEventesting.htm

sudo /etc/init.d/pcscd stop
