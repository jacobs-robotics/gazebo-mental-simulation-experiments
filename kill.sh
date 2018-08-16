#!/bin/bash
source ../config/containers.cfg

echo -e "${GREEN}>>> Stopping all containers and scripts...${NC}"

# kill scripts
killall run_experiments.sh &>/dev/null
killall repetitive_experiment.sh &>/dev/null
killall experiment.sh &>/dev/null
killall generate_random_scenes.sh &>/dev/null

# kill all running containers
current_containers=$(docker ps -a --filter="label=gazebo-mental-simulation" --format "{{.Names}}")
if [ ${#current_containers} -gt 0 ]; then
    docker kill ${current_containers} &> /dev/null
fi

killall run_experiments.sh &>/dev/null
killall repetitive_experiment.sh &>/dev/null
killall experiment.sh &>/dev/null
killall generate_random_scenes.sh &>/dev/null
