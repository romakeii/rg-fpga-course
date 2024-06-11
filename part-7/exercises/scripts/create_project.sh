#!/bin/sh
ARG="${@: -1}"
DIR="$(dirname "${ARG}")"
SCR="${DIR}/fifo_mult_stream_acc.tcl"
#TCLARGS=$1
if [[ "$1" != "" ]]; then
    TCLARGS="$1"
else
    TCLARGS="xc7vx1140tflg1930-2"
fi
vivado -nolog -nojournal -mode tcl -source "${SCR}" -tclargs "${TCLARGS}"
