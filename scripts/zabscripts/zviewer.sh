#/bin/bash
if [ $# -eq 0 ] ; then echo 'FAIL: Params not defined.' && echo 'Usage: zbxviewer.sh Token Subject Message' && exit 1 ; fi

if wget -V >/dev/null 2>&1 ; then
    #use wget
    wget -q "https://zbx.vovanys.com/push/sendPush.php?token=$1&title=$2&desc=$3"
else
    #if wget not found, use curl
    curl -kdG "https://zbx.vovanys.com/push/sendPush.php?token=$1&title=$2&desc=$3"
fi
