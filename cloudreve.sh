#!/bin/bash
VER="1.0.0"
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
cloudreve_dir="/root/.cloudreve"
download_path="/root/downloads"
aria2_conf_dir="/root/.cloudreve/.aria2"
cloudreve_dir="/root/.cloudreve"
download_path="/root/downloads"
aria2_conf="${aria2_conf_dir}/aria2.conf"

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}




menu() {
    echo -e "
           Cloudreve.sh    |   Cloudreve 一键脚本
                   Powered By Akiker  ${Red_font_prefix}${VER}${Font_color_suffix}
      bash <(curl -sL https://raw.githubusercontents.com/akiker233/cloudreve-script/main/cloudreve.sh)
     ========================================================
      ${Green_font_prefix}1.${Font_color_suffix} 安装从机节点
      ${Green_font_prefix}2.${Font_color_suffix} 卸载从机节点
      ${Green_font_prefix}3.${Font_color_suffix} 更新从机节点
      ————————————————-
      ${Green_font_prefix}4.${Font_color_suffix} 启动程序
      ${Green_font_prefix}5.${Font_color_suffix} 停止程序
      ${Green_font_prefix}6.${Font_color_suffix} 重启程序
      ${Green_font_prefix}7.${Font_color_suffix} 查看运行状态
      ————————————————-
      ${Green_font_prefix}8.${Font_color_suffix} 更新脚本
      ————————————————-
      ${Green_font_prefix}0.${Font_color_suffix} 退出脚本
      "
      
    read -p "请输入选项:" menuNum
	case "$menuNum" in
		1) Install_app ;;
		2) Uninstall_app ;;
		3) Update_app ;;
		4) Start_app ;;
		5) Stop_app ;;
		6) Restart_app ;;
		7) Status_app ;;
		8) Update_menu ;;
		0) exit 0 ;;
		*) echo -e "${Red_font_prefix}请输入正确的数字${Font_color_suffix}"
	esac 
}


Install_app() {
    bash <(curl -sL https://raw.githubusercontents.com/akiker233/cloudreve-script/main/cloudreve-install.sh)
}
Uninstall_app() {
    systemctl stop cloudreve
    systemctl stop aria2
    systemctl disable aria2
    systemctl disable cloudreve
    rm -rf /etc/systemd/system/aria2.service
    rm -rf /usr/lib/systemd/system/cloudreve.service
    rm -rf $cloudreve_dir
    green "卸载成功"
}
Update_app() {
    cloudreve_new_ver=$(
        {
            wget -t2 -T3 -qO- "https://api.github.com/repos/cloudreve/Cloudreve/releases/latest" ||
                wget -t2 -T3 -qO- "https://gh-api.p3terx.com/repos/cloudreve/Cloudreve/releases/latest"
        } | grep -o '"tag_name": ".*"' | head -n 1 | cut -d'"' -f4
    )

    systemctl stop cloudreve
    echo "正在更新Cloudreve..."
    echo "正在检测最新版本..."
    echo "最新版本为 ${cloudreve_new_ver}"
    echo "开始下载最新版本..."
    wget -O $cloudreve_dir/cloudreve.tar.gz https://github.com/cloudreve/Cloudreve/releases/download/${cloudreve_new_ver}/cloudreve_${cloudreve_new_ver%_*}_linux_amd64.tar.gz
    tar -zxvf $cloudreve_dir/cloudreve.tar.gz && rm -rf $cloudreve_dir/cloudreve.tar.gz
    mv -f cloudreve $cloudreve_dir/
    systemctl start cloudreve
    systemctl status cloudreve
}
Start_app() {
    systemctl start cloudreve
    systemctl start aria2
    systemctl status cloudreve
    systemctl status aria2
}
Stop_app() {
    systemctl stop cloudreve
    systemctl stop aria2
}
Restart_app() {
    systemctl restart cloudreve
    systemctl restart aria2
    systemctl status cloudreve
    systemctl status aria2
}
Status_app() {
    systemctl status cloudreve
    systemctl status aria2
}
menu