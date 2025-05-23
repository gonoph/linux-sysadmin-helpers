#!/bin/bash

# function for temporary shell creation

tmpsh() {
	T=$(mktemp -d)
	TT=$(mktemp)
	echo 'PS1="\[\e[1;35m\](\[\e[0;33m\]tmp\[\e[1;35m\]) \[\e[0m\]$PS1"' > $TT
	INIT="#!/bin/sh
trap 'rm -rf $T $TT' EXIT
. /etc/bashrc
$(cat $TT)
cd $T
"
	bash --init-file <(echo "$INIT")
}
