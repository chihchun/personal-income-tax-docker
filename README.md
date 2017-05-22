# Docker image for accessing Web-based Personal income text reporting system of Ministry of Finance, Taiwan.

## Introduction / 介紹

This is a docker image help Linux Desktop Users setup their enviromenet to access to the [Web-based Personal income text reporting system. (綜合所得稅電子結算申報繳稅系統)](https://rtn.tax.nat.gov.tw/ircweb/index.jsp)

There are some requirements for access to the web system, and it can be a confusing technical challenges due to 

* The  required components has security limitation, which blocked most of the access of the Java Web Browser Plugin by default.
* The system requires a unsigned FIrefox extenstion, the user need to use the advanced settings before actaully install the plugin.

This container image offers preinstallation of the system / 本容器鏡像提供以下預裝軟體

* Preinstalled Firefox 53.0.2
    * allow unsigned extenstion 
    * does not save your password
    * allow pop up window for the information notice by the system.
* OpenJDK 8 and IcedTea
*  Chinese fonts and locale settings with input method support. 
* pcscd for SmartCard access.

This image is only tested on 64 bit/amd64 Ubuntu 16.04. Please report if you can not use the image on the other distro.

## Usage / 使用方法

### System requirements / 基本需求

* 64 bit / amd64 Linux 
* Xorg (any X11-based Desktop Enviroement can do the work, does not support Wayland. 各種桌面環境都可以，除了 Wayland)
* Chinese Input method / 中文輸入法 (如 fictix)
* Docker Engine

### How to start / 執行方式
    # You must have docker installed on your machine.
    # 請先確保你已經安裝 docker
    sudo apt-get install docker.io
    # If you like to access to Smart Card (自然人憑證/健保卡), please make sure you stop your pcscd on your host
    # 你需要先停掉系統上的 pcscd. 把 USB 裝置讓給 docker 使用。
    sudo /etc/init.d/pcscd stop
    wget https://raw.githubusercontent.com/chihchun/personal-income-tax-docker/master/2017/run.sh
    sh -x run.sh
    
-  系統第一次啟動，會問你安裝一次 HiPKI Addons, 請安裝後，選擇重新啟動。
- 自動重新啟動後預設就會進入報稅網站界面，請記得接下來跳出的視窗都要選取允取 Java 執行。系統才能正確安裝


    
