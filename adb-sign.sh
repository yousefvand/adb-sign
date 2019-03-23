#!/bin/sh

#===================================================
#title           :Adblock filter list file signer.
#description     :Signs Adblock filter list files.
#author		 :Remisa Yousefvand
#date            :20180317
#version         :0.1
#usage		 :bash adb-sign.sh input-file output-file
#===================================================

# at least one argument (input file) is needed
if [ $# -eq 0 ]; then
  echo "Error: No arguments supplied."
	echo "Usage: bash $0 input.txt output.txt"
	exit 128
# check if input file exists
elif [ ! -f $1 ]; then
  echo "Error: Input file not found!"
	exit 1
else
  # set output file
  if [ -z "$2" ]; then
    OUTPUT="output.txt"
  else
    OUTPUT=$2
  fi
  # check file encoding
  ENCODING=$(file --mime-encoding $1)
  if [[ $ENCODING = *"ascii"* ]] || [[ $ENCODING = *"utf-8"* ]]; then
    # unix line ending format
    tr -d '\r' < $1 > ${OUTPUT}
    # remove empty lines
    sed -i '/^[[:space:]]*$/d' ${OUTPUT}
    # check if file begins with [Adblock Plus v.v]
    FIRSTLINE=$(head -n 1 $1)
    if ! [[ $FIRSTLINE =~ \[Adblock[[:space:]]Plus[[:space:]][[:digit:]]+\.[[:digit:]]+\] ]]; then
      echo "Error: input file is not a valid ad block list file"
      exit 1
    fi
    # remove checksum if exist (line starting with "! Checksum")
    sed -i '/^! Checksum.*/d' ${OUTPUT}
    # calculate md5 checksum
    SIGNITUTE=$(cat ${OUTPUT} | openssl dgst -md5 -binary | openssl enc -base64)
    # remove trailing "="
    SIGNITUTE=$(sed 's/=*$//' <<< ${SIGNITUTE})
    # add signiture at line 2 (line one should be "[Adblock Plus 2.0]")
    sed -i "2i\! Checksum: $SIGNITUTE\\" ${OUTPUT}
    echo "DONE! signed file generated: $PWD/${OUTPUT}"
  else
    echo "Error: Input file encoding should be UTF-8"
  fi
fi
