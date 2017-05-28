FROM ubuntu:xenial-20170510
MAINTAINER https://about.me/chihchun

RUN sed -e s%http://archive.ubuntu.com/ubuntu/%mirror://mirrors.ubuntu.com/mirrors.txt% -i /etc/apt/sources.list
RUN apt-get update \
 && apt-get dist-upgrade -y

RUN apt-get install --no-install-recommends -y firefox ttf-wqy-microhei  default-java-plugin
# Setup locales for input methods.
RUN apt-get install -y locales \
 && locale-gen zh_TW zh_TW.UTF-8 zh_CN zh_CN.UTF-8 en

# Setup timezone
RUN apt-get install -y tzdata \
 && ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime

RUN apt-get install --no-install-recommends -y pcscd pcsc-tools
# setup sudo for pcscd
RUN apt-get install -y sudo \
 && echo "firefox ALL=NOPASSWD: /etc/init.d/pcscd, /bin/su, /usr/local/src/mLNHIICC_Setup/mLNHIICC" >> /etc/sudoers.d/firefox

# vim for debug purpose.
# RUN apt-get install -y vim

RUN useradd --create-home firefox
RUN echo 'pref("browser.startup.homepage", "https://rtn.tax.nat.gov.tw/ircweb/index.jsp");' >> /etc/firefox/syspref.js \
 && echo 'pref("plugin.load_flash_only", false);' >> /etc/firefox/syspref.js \
 && echo 'pref("xpinstall.signatures.required", false);' >> /etc/firefox/syspref.js  \
 && echo 'pref("extensions.enabledAddons", "hipki%40chttl.com.tw:1.5.1.2479,%7B972ce4c6-7e08-4474-a285-3208198ce6fd%7D:53.0.2");' >> /etc/firefox/syspref.js  \
 && echo 'pref("privacy.cpd.passwords", true);' >> /etc/firefox/syspref.js \
 && echo 'pref("dom.disable_open_during_load", false);' >> /etc/firefox/syspref.js

# Setup Firefox extensions
RUN apt-get install --no-install-recommends -y wget unzip
RUN mkdir -p /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} \
 && wget --no-check-certificate -O \
        /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/hipki@chttl.com.tw.xpi https://rtn.tax.nat.gov.tw/ircweb/include/npHiPKIClient-linux-etax64.xpi

# Setup for reading Health Insurance ID Card
# Install script for plugin of Health Insurance ID Card will use killall command
RUN apt-get install --no-install-recommends -y libnss3-tools psmisc \
 && wget --no-check-certificate -P /tmp https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mLNHIICC_Setup.Ubuntu.zip \
 && unzip -d /tmp /tmp/mLNHIICC_Setup.Ubuntu.zip \
 && tar zxvf /tmp/mLNHIICC_Setup.Ubuntu16.tar.gz -C /usr/local/src \
 && cd /usr/local/src/mLNHIICC_Setup/ && ./Install \
 && sed -i '2i. /lib/lsb/init-functions' /usr/local/src/mLNHIICC_Setup/mLNHIICC \
 && rm -rf /tmp/*

# Install COMODO RSA Organization Validation Secure Server CA (SHA-2) for the NHIICC daemon.
RUN wget -O /usr/local/share/ca-certificates/comodorsaorganizationvalidationsecureserverca.crt https://support.comodo.com/index.php?/Knowledgebase/Article/GetAttachment/968/821025 \
 && wget -O /usr/local/share/ca-certificates/comodorsadomainvalidationsecureserverca.crt https://support.comodo.com/index.php?/Knowledgebase/Article/GetAttachment/970/821027 \
 && update-ca-certificates

ADD start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh

USER 1000
# Install the HiPKI plugin. But the plugin is blocked by default.
RUN mkdir -p /home/firefox/.mozilla && \
    unzip -d /home/firefox/.mozilla/ /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/hipki\@chttl.com.tw.xpi plugins/*

# This approach does not work, the user still need to approve the extenstion manually.
# RUN mkdir -p /home/firefox/.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} \
#  && wget --no-check-certificate -O \
#        /home/firefox/.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/hipki@chttl.com.tw.xpi https://rtn.tax.nat.gov.tw/ircweb/include/npHiPKIClient-linux-etax64.xpi

CMD /usr/local/bin/start.sh
