#!/bin/bash
source config/experiments.cfg

echo -e "${GREEN}>>> Using container ${BLUE}$1${GREEN} and world file ${BLUE}`basename $3`${GREEN} with ${BLUE}$4${GREEN} repetitions.${NC}"

DISPLAY_ID=${DISPLAY_ID:-1}

for rep_counter in {1..$4}; do
    echo -e "${GREEN}>>> Repetition #${rep_counter}...${NC}"
    # run experiment script using container name and world file name
    ./experiment.sh $1 $3
done
