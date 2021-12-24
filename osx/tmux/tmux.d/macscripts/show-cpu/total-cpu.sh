#!/bin/bash
## Displays CPU usage for use with GNU Screen
# top arguments:
#  -n = number of procs to show (0)
#  -l = logging mode (non-interactive) and log only 1 sample
#  -S = display Swap space information (not really necessary but... ya)
#  -F = don't calculate stats for shared libraries
#  -R = dont' report memory map for each process
#  -s0 = sample interval os 0 seconds
#
#

CPU_USAGE=$(top -n 0 -l 1 -S -F -R -s0 | grep CPU)
OIFS=$IFS
IFS=' '
array=($CPU_USAGE)
num1=$(echo ${array[2]} | sed "s/%//")
num2=$(echo ${array[4]} | sed "s/%//")
IFS=$OIFS
sum=$(echo "$num1 + $num2" | bc)
echo "CPU usage: $sum "
