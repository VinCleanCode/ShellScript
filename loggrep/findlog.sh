#!/bin/bash
SCRIPT_PATH=$(dirname $(readlink -f $0))
cd ${SCRIPT_PATH}

show_help() {
cat << EOF

  Usage:
        ${0##*/} LogPath ItemNumber
        or
        ${0##*/} LogPath ItemNumber StoreID

  ex:   ./${0##*/} ES4-prd_e4-aggregator-21-1568873179 9SIA6V65J81010
  ex:   ./${0##*/} ES4-prd_e4-aggregator-21-1568873179 9SIA6V65J81010 1493

  Note: StoreID is optional parameter, default will search all stores

EOF
}

find(){
    zgrep "LoadKafkaBolt Successful" ./$LOGPATH/*/worker.log* | grep $ITEM 2>&1 | sudo tee $ITEM.log
    echo 
    echo "command:"
    echo "zgrep" \"LoadKafkaBolt Successful\" "./"$LOGPATH"/*/worker.log* | grep" $ITEM "2>&1 | sudo tee" $ITEM.log
}

findStore(){
    zgrep "LoadKafkaBolt Successful" ./$LOGPATH/*/worker.log* | grep $ITEM | grep $STORE 2>&1 | sudo tee $ITEM-$STORE.log
    echo
    echo "command:"
    echo "zgrep" \"LoadKafkaBolt Successful\" "./"$LOGPATH"/*/worker.log* | grep" $ITEM "| grep" $STORE "2>&1 | sudo tee" $ITEM-$STORE.log
}


if [ "$#" -lt "2" ]
then
    echo ""
    echo -e "  [ERROR]: Please inuput Path and ItemNumber!";
    show_help
elif [ "$#" -eq "2" ]
then
    LOGPATH=$1;
    ITEM=$2;
    find
elif [ "$#" -eq "3" ]
then
    LOGPATH=$1;
    ITEM=$2;
    STORE=$3;
    findStore
else
    show_help
fi
