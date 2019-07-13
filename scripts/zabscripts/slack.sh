#!/bin/bash
KEY="https://hooks.slack.com/services/"
TO="$1"
SUB="$2"
MESS="$3"

if [[ $SUB == 'PROBLEM' ]]
then
	ICON=":scream:"
elif [[ $SUB == 'OK' ]]
then
	ICON=":ok_hand:"
else
	ICON=":point_up_2:"
fi

/usr/local/bin/curl -X POST --data-urlencode "payload={\"channel\": \"$TO\", \"username\": \"TradeNarK\", \"text\": \"$ICON $SUB\n$MESS\"}" $KEY


# settings to zabbix-server
# {ALERT.SENDTO}
# {ALERT.SUBJECT}
# {ALERT.MESSAGE}
