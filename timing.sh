#!/bin/bash

# outputs the runtimes into runtimes.csv, format: exit status, wall time, system time, user time

container=$1
world_file=$2
runtimes_file=../logs/runtimes_$container.csv
if [ ! -f $runtimes_file ]; then
    echo -e "world_file,exit_code,wall_time,system_time,user_time" > $runtimes_file
fi
echo -e "$world_file,\c" >> $runtimes_file
/usr/bin/time -f %x,%e,%S,%U --quiet -a -o $runtimes_file "${@:3}"
