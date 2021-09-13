#! /bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export softether`

enable=`dbus get softether_enable`
if [ -f "$KSROOT/softether/vpn_server.config" ];then
	tap=`cat vpn_server.config |grep "bool TapMode true"`
else
	tap=""
fi

if [ "$enable" == 1 ];then
	sh $KSROOT/softether/softether.sh stop
fi

cd /tmp
cp -rf /tmp/softether_vpn/softether $KSROOT
cp -rf /tmp/softether_vpn/scripts/* $KSROOT/scripts/
cp -rf /tmp/softether_vpn/webs/* $KSROOT/webs/
cp -rf /tmp/softether_vpn/res/* $KSROOT/res/

cp /tmp/webshell/uninstall.sh $KSROOT/scripts/uninstall_webshell.sh

# 为新安装文件赋予执行权限...
chmod 755 $KSROOT/softether/*
chmod 755 $KSROOT/scripts/softether*

sleep 1
rm -rf /tmp/softether* >/dev/null 2>&1

if [ "$enable" == 1 ] && [ -n "$tap" ];then
	sh $KSROOT/softether/softether.sh restart
fi
