FROM ubuntu:xenial-20180417
LABEL maintainer="https://about.me/chihchun"

RUN sed -e s%http://archive.ubuntu.com/ubuntu/%mirror://mirrors.ubuntu.com/mirrors.txt% -i /etc/apt/sources.list
RUN apt-get update \
 && apt-get dist-upgrade -y

# Install Firefox, Chinese fonts
RUN apt-get install --no-install-recommends -y firefox ttf-wqy-microhei

# Setup locales for input methods.
RUN apt-get install -y locales \
 && locale-gen zh_TW zh_TW.UTF-8 zh_CN zh_CN.UTF-8 en

# Setup timezone
RUN apt-get install -y tzdata \
 && ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime

RUN apt-get install --no-install-recommends -y pcscd pcsc-tools
# setup sudo for pcscd
RUN apt-get install -y sudo \
 && echo "firefox ALL=NOPASSWD: /bin/su, /etc/init.d/pcscd, /usr/sbin/pcscd, /usr/local/share/NHIICC/mLNHIICC" >> /etc/sudoers.d/firefox

RUN echo 'pref("browser.startup.homepage", "https://efile.tax.nat.gov.tw/irxw/index.jsp");' >> /etc/firefox/syspref.js \
 && echo 'pref("privacy.cpd.passwords", true);' >> /etc/firefox/syspref.js \
 && echo 'pref("toolkit.telemetry.reportingpolicy.firstRun", false);' >> /etc/firefox/syspref.js

RUN apt-get install --no-install-recommends -y wget unzip
# MOICA內政部憑證管理中心-跨平台網頁元件 - http://moica.nat.gov.tw/rac_plugin.html
RUN wget -O /dev/stdout http://moica.nat.gov.tw/download/File/HiPKILocalSignServer/linux/HiPKILocalSignServerApp.tar.gz | tar zxvf - -C /usr/local

# Setup for reading Health Insurance ID Card
# 健保卡網路服務註冊－環境檢測(Chrome、FireFox、Opera、Edge) - https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mEventesting.htm
RUN wget --no-check-certificate -P /tmp https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mLNHIICC_Setup.Ubuntu.zip \
 && unzip -d /tmp /tmp/mLNHIICC_Setup.Ubuntu.zip mLNHIICC_Setup.Ubuntu16.tar.gz \
 && tar zxvf /tmp/mLNHIICC_Setup.Ubuntu16.tar.gz -C /usr/local \
 && cd /usr/local/mLNHIICC_Setup/ && ./Install

# clean up
RUN apt-get remove --purge -y wget unzip \
 && apt-get autoremove -y \
 && apt-get clean -y
RUN rm -rf /tmp/* /var/tmp/*

ADD start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh

RUN useradd --create-home firefox
USER 1000

# Run the final script
CMD /usr/local/bin/start.sh