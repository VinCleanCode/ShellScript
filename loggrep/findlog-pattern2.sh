#!/bin/bash
SCRIPT_PATH=$(dirname $(readlink -f $0))
cd ${SCRIPT_PATH}

show_help() {
cat << EOF

  Usage:
        ${0##*/} TransactionNumber
        or
        ${0##*/} TransactionNumber all

  ex:   ${0##*/} 19737057
  ex:   ${0##*/} 19737057 all

  Note: all is optional parameter, default will search log in ./logs/ folder
        all will search for all history log, may cost much time.

EOF
}

find(){
    echo "Find log for TransactionNumber:" $TN
    zgrep 'Topic:EC_EVENT_SALE_STORE' ./logs/*-eventsalestore-restful* | zgrep $TN 2>&1 | sudo tee $TN.log
    echo "Execute command: zgrep 'Topic:EC_EVENT_SALE_STORE' ./logs/*-eventsalestore-restful* | zgrep "$TN
}

findr(){
    echo "Find log for TransactionNumber:" $TN
    zgrep 'Topic:EC_EVENT_SALE_STORE' ./logs/*/*-eventsalestore-restful* | zgrep $TN 2>&1 | tee $TN.log
    echo "Execute command: zgrep 'Topic:EC_EVENT_SALE_STORE' ./logs/*-eventsalestore-restful* | zgrep "$TN
}

if [ "$#" -lt "1" ]
then
    echo ""
    echo -e "  [ERROR]: Please inuput TransactionNumber!";
    show_help
elif [ "$#" -eq "1" ]
then
    TN=$1;
    find
elif [ "$#" -eq "2" ] && [ "$2" == "all" ]
then
    TN=$1;
    findr
else
    show_help
fi