FROM ubuntu:focal-20220801
LABEL maintainer="https://about.me/chihchun"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei

RUN sed -e s%http://archive.ubuntu.com/ubuntu/%http://free.nchc.org.tw/ubuntu% -i /etc/apt/sources.list

# Install Firefox, Chinese fonts, locales, tzdata, sudo, ca-certificates, pcscd ,pcsc-tools and setup it
# Setup for reading Health Insurance ID Card and the plugin for MOICA
# 健保卡網路服務註冊－環境檢測(Chrome、FireFox、Opera、Edge) - https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mEventesting.htm
# MOICA內政部憑證管理中心-跨平台網頁元件 - http://moica.nat.gov.tw/rac_plugin.html
RUN apt-get update \
 && apt-get install -y ca-certificates \
 && apt-get dist-upgrade -y \
 && apt-get install --no-install-recommends -y firefox ttf-wqy-microhei locales tzdata sudo pcscd pcsc-tools unbound-anchor \
 libboost-all-dev libssl-dev libnss3-tools wget p11-kit \
 && wget -O /dev/stdout https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mLNHIICC_Setup.20220110.tar.gz |tar zxvf - -C /usr/local \
 && cd /usr/local/mLNHIICC_Setup.20220530/ && ./Install \
 && cd .. && rm -rf /usr/local/mLNHIICC_Setup.* ._mLNHIICC_Setup.*\
 && wget -O /dev/stdout https://api-hisecurecdn.cdn.hinet.net/HiPKILocalSignServer/linux/HiPKILocalSignServerApp.tar.gz |tar zxvf - -C /usr/local \
 && chmod +x /usr/local/HiPKILocalSignServerApp/start.sh \
 && apt-get purge -y wget \
 && apt-get clean autoclean \
 && apt-get autoremove --yes \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/
 
# Setup locale
RUN locale-gen zh_TW zh_TW.UTF-8 zh_CN zh_CN.UTF-8 en_US.UTF-8 

# Setup Firefox
RUN echo 'pref("browser.startup.homepage", "https://efile.tax.nat.gov.tw/irxw/index.jsp");' >> /etc/firefox/syspref.js \
 && echo 'pref("privacy.cpd.passwords", true);' >> /etc/firefox/syspref.js \
 && echo 'pref("security.certerrors.permanentOverride", false);' >> /etc/firefox/syspref.js \
 && echo 'pref("toolkit.telemetry.reportingpolicy.firstRun", false);' >> /etc/firefox/syspref.js \
 && echo 'pref("security.enterprise_roots.enabled", true);' >> /etc/firefox/syspref.js
# Setup localtime
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime 

# Add NHIRootCA to firefox
ADD policies.json /etc/firefox/policies/policies.json

# Install driver for EZUSB
RUN mkdir -p /usr/lib/pcsc/drivers/ezusb.bundle/Contents/Linux
ADD https://github.com/chihchun/ez100pu/raw/master/driver_ezusb_v1.5.3_for_64_bit/drivers/ezusb.so  /usr/lib/pcsc/drivers/ezusb.bundle/Contents/Linux
ADD https://github.com/chihchun/ez100pu/raw/master/driver_ezusb_v1.5.3_for_64_bit/drivers/Info.plist /usr/lib/pcsc/drivers/ezusb.bundle/Contents

# Create firefox user
RUN useradd --create-home firefox \
 && echo "firefox ALL=NOPASSWD: /bin/su, /etc/init.d/pcscd, /usr/sbin/pcscd, /usr/local/share/NHIICC/mLNHIICC" >> /etc/sudoers.d/firefox \
 && mkdir -p /home/firefox/.mozilla/firefox/default \
 && chown -R 1000.1000 /home/firefox/

ADD start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh

# Run the final script
USER 1000
CMD /usr/local/bin/start.sh
