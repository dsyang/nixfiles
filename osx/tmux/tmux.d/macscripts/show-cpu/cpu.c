#include <stdio.h>
#include <stdlib.h>

/*
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
top -n 0 -l 1 -S -F -R -s0 | grep CPU
*/
int main() {
    system("/Users/dsyang/Sandbox/scripts/show-cpu/cpu.sh");
    return 0;
}
