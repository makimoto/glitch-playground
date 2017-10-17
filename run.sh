#!/bin/bash
TARGET_FILE=/data/`ls /data | head -n1`
convert $TARGET_FILE /tmp/origin.jpg
while true
do
  if [ -z "$FORMAT" ] ; then
    FORMAT=jpg
    cp /tmp/origin.jpg /tmp/data.jpg
    DATAPATH=/tmp/data.jpg
  else
    DATAPATH=/tmp/data.$FORMAT
    convert /tmp/origin.jpg $DATAPATH
  fi
  echo "Glitching $DATAPATH ..."

  FOO=`cat /dev/urandom | base64 | fold -w 1 | head -1`
  BAR=`cat /dev/urandom | base64 | fold -w 1 | head -1`
  cat $DATAPATH | sed -e "s/$FOO/$BAR/g" > /tmp/glitched.$FORMAT
  convert /tmp/glitched.$FORMAT jpg:- | ./imgcat
  echo "Replaced $FOO with $BAR..."
  read -p "Hit enter or file format (current format is $FORMAT): " INPUT_FORMAT < /dev/tty
  if [ ! -z "$INPUT_FORMAT" ]; then
    FORMAT=$INPUT_FORMAT
  fi
  clear
done
