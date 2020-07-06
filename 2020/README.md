# 綜合所得稅申報系統 Docker Image

此 Docker Image 預裝線上報稅所需工具，無須手動安裝內政部憑證或健保卡元件。

本容器鏡像提供以下預裝軟體
* Firefox 66.0.3
* 中文字型與輸入法設定
* 智慧卡預裝工具 (pcscd)
* 內政部憑證憑證管理中心-跨平台網頁元件 - http://moica.nat.gov.tw/rac_plugin.html
* 健保卡網路服務註冊元件 https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mEventesting.htm

這個鏡像檔只在 Ubuntu 16.04/18.04/20.04 64 位元版本測試過，如果在其他 Linux 版本有使用問題敬請提報。

## 使用方法

### 基本需求

* 64 位元 Linux 
* Xorg (各種 X11 桌面環境都可以，除了 Wayland)
* 中文輸入法 (如 fctix)
* Docker Engine

### 執行方式
    # 請先確保你已經安裝 docker，並確保用戶加入 docker 群組。
    sudo apt-get install docker.io
    sudo usermod -a -G docker $USER
    # 以下命令執行後，會要求你輸入個人密碼，並以 sudo 關閉 pcscd, scdaemon 等佔用讀卡機的軟體。
    wget https://raw.githubusercontent.com/chihchun/personal-income-tax-docker/master/2019/run.sh
    bash run.sh

- 如果要使用健保卡來認証的話，請移到第 2 個分頁或打開 <https://iccert.nhi.gov.tw:7777/> 頁面。
    - **需先執行** 健保卡網路服務註冊－環境說明 "設定伺服器為可信任服務"
    - 第一次使用請按申請密碼，需要使用到健保卡和讀卡機還有戶口名簿上的戶號作為申請的依據。
    - 並填寫信箱，接著要設一組認証密碼，就是之後報稅系統使用健保卡登入要輸入的。
    - 申請成功後會在信箱收到認証信，點選認証連結完成認証就行了，認証的時候健保卡一樣要插在讀卡機中。
- 如果需要儲存報表，預設路徑會是你桌面環境的下載目錄。 可執行以下命令開啟 gnome-open $(xdg-user-dir DOWNLOAD) 

# Docker image for accessing Web-based Personal income tax reporting system of Ministry of Finance, Taiwan.

## Introduction

This is a docker image help Linux Desktop Users setup their enviromenet to access to the [Web-based Personal income tax reporting system. (綜合所得稅電子結算申報繳稅系統)](https://efile.tax.nat.gov.tw/irxw/index.jsp)

There are some requirements for access to the web system, and it can be a confusing technical challenges due to 

* The required components has security limitation, which blocked most of the access of the Java Web Browser Plugin by default.
* The system requires a unsigned FIrefox extenstion, the user need to use the advanced settings before actaully install the plugin.

This container image offers preinstallation of the system

* Firefox 59.0.2
    * Disabled remember password
* Chinese font and input method
* pcscd for smartcard access.
* MOICA RAC - http://moica.nat.gov.tw/rac_plugin.html
* MHI Cloud Component - https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mEventesting.htm

This image is only tested on 64 bit/amd64 Ubuntu 16.04. Please report if you can not use the image on the other distro.

## Contributor / 貢獻者

* Rex Tsai.
