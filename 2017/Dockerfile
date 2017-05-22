FROM ubuntu:xenial-20170510
MAINTAINER https://about.me/chihchun

RUN sed -e s%http://archive.ubuntu.com/ubuntu/%mirror://mirrors.ubuntu.com/mirrors.txt% -i /etc/apt/sources.list
RUN apt-get update \
 && apt-get dist-upgrade -y

RUN apt-get install --no-install-recommends -y firefox ttf-wqy-microhei  default-java-plugin
# Setup locales for input methods.
RUN apt-get install -y locales \
 && locale-gen zh_TW zh_TW.UTF-8 zh_CN zh_CN.UTF-8 en

RUN apt-get install --no-install-recommends -y pcscd pcsc-tools
# setup sudo for pcscd
RUN apt-get install -y sudo \
 && echo "firefox ALL=NOPASSWD: /etc/init.d/pcscd, /bin/su" >> /etc/sudoers.d/firefox

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
ADD firefox.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/firefox.sh

USER 1000
# Install the HiPKI plugin. But the plugin is blocked by default.
RUN mkdir -p /home/firefox/.mozilla && \
    unzip -d /home/firefox/.mozilla/ /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/hipki\@chttl.com.tw.xpi plugins/*

# This approach does not work, the user still need to approve the extenstion manually.
# RUN mkdir -p /home/firefox/.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} \
#  && wget --no-check-certificate -O \
#        /home/firefox/.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/hipki@chttl.com.tw.xpi https://rtn.tax.nat.gov.tw/ircweb/include/npHiPKIClient-linux-etax64.xpi 

CMD /usr/local/bin/firefox.sh
