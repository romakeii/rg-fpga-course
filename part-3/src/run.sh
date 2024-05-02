#!/bin/sh
ARG="${@: -1}"
DIR="$(dirname "${ARG}")"
SCR="${DIR}/run.tcl"
vivado -nolog -nojournal -mode tcl -source "${SCR}" -tclargs "${SCR}"
