#!/bin/bash

# functions to help with using colours in a terminal for your ouput

showcolours()
{
	local text="the quick brown fox jumped over the lazy dog"
	local text2=`tr a-z A-Z <<< "$text"`
	for ii in 0 1 ; do
		for i in `seq 30 37` ; do
			echo "[${ii};${i}m $i $ii : $text $text2 [0m"
		done
	done
}

setColours()
{
  E=""
  BLK="$E[30m"
  RED="$E[31m"
  GRN="$E[32m"
  YLW="$E[33m"
  BLU="$E[34m"
  MAG="$E[35m"
  CYN="$E[36m"
  WHT="$E[37m"
  BRT="$E[1m"
  NRM="$E[0m"

  alias _BLK='echo -n $BLK'
  alias _RED='echo -n $RED'
  alias _GRN='echo -n $GRN'
  alias _YLW='echo -n $YLW'
  alias _BLU='echo -n $BLU'
  alias _MAG='echo -n $MAG'
  alias _CYN='echo -n $CYN'
  alias _WHT='echo -n $WHT'
  alias _BRT='echo -n $BRT'
  alias _NRM='echo -n $NRM'

  unset E
  export BLK RED GRN YLW BLU MAG CYN WHT BRT NRM
  echo ${RED}colours set $NRM
}
