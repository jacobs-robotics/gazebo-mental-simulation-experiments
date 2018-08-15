#!/bin/bash

# outputs the runtimes into runtimes.csv, format: exit status, wall time, system time, user time

runtimes_file=../logs/runtimes.csv
world_file=""

if [ "$1" == "-w" ]; then
    world_file=$2
fi
if [ ! -f $runtimes_file ]; then
    echo -e "world_file,exit_code,wall_time,system_time,user_time" > $runtimes_file
fi
if [ "$world_file" == "" ]; then
    echo -e ",\c" >> $runtimes_file
    /usr/bin/time -f %x,%e,%S,%U --quiet -a -o $runtimes_file "${@:1}"
else
    echo -e "$world_file,\c" >> $runtimes_file
    /usr/bin/time -f %x,%e,%S,%U --quiet -a -o $runtimes_file "${@:3}"
fi
