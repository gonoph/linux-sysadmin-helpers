#!/bin/bash

# functions to assist with ssh

# connect to an ssh host w/o saving the key
sshtmp()
{
	echo "About to temporarily connect to host" > /dev/tty
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@"
}

# show all pub keys
sshpub()
{
	set $(stty size)
	local LINE=$( python3 -c "print('#' * $2)" )
	echo $LINE
	cat ~/.ssh/*.pub
	echo $LINE
}
