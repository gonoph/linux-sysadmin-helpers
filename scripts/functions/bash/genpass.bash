#!/bin/bash

# function to generate a large list of random password

genpass ()
{
  local _size=$1          # size of the password - default(16)
  local _count=$2         # how many passwords to generate - default(fill your terminal screen)
  local _rc _rows _width _cols
  local BASE64=base64

  test "$(uname -s)" == "Darwin" && BASE64="base64 -i"
  : ${_size:=16}
  _rc=$(stty size)
  set $_rc
  _rows=$1
  _width=$2
  _rows=$[ $_rows - 2 ]

  # using the terminal screen size calculate how many passwords can fit per row
  _cols=$[ $_width / ($_size + 1)]
  _width=$[ $_cols * ($_size + 1) ]

  # using the max column size, figure out how many passwords that is
  : ${_count:=$[ $_rows * ( $_width / ($_size + 1) )]}

  echo "width: $_width; rows: $_rows; cols: $_cols; count: $_count" 1>&2;
  # get a bunch of random text
  $BASE64 /dev/urandom 2>/dev/null | 
  # ensure the random text is only numbers and letters
  tr -cd '[:alnum:]' | 
  # encode the text as lines of password length
  dd cbs=$_size conv=unblock | 
  # convert lines to a stream of passwords inserting a space
  dd cbs=$[ $_size + 1 ] conv=block | 
  # convert the stream of passwords into columns of equal length
  dd cbs=$_width conv=unblock | 
  # stop priting passwords when we reach count
  dd bs=$[ $_size + 1 ] count=$_count 2> /dev/null
  # add a new line if needed
  [ $[ $_count % $_cols ] -ne 0 ] && echo
}
