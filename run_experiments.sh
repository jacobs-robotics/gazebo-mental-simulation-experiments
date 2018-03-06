#!/bin/bash
# run experiment for all present world files
source config/experiments.cfg

# stop containers if running
( cd .. || ./stop.sh && ./start.sh )

# determine number of containers to use in parallel
# make sure that only one container is used on enabled GUI to avoid crashes
containers_array=( $containers )
if [[ ${gui} == "true" ]]; then
    NUM_CONTAINERS=1
    echo -e "${YELLOW}>>> GUI enabled, hence only one container will be used.${NC}"
elif [[ ($# == 1) ]]; then
    NUM_CONTAINERS=$1
else
    NUM_CONTAINERS=${#containers_array[@]}
fi
CONTAINERS=("${containers_array[@]:0:$NUM_CONTAINERS}")
CONTAINER_INDEX=0

# run for all world files, assuming that the directory structure inside and outside of the container is similar
# on the command line, something like '`rospack find ${experiment_launch_package_name}`/worlds/blah.world' can be used
for world_file in $(docker exec --user="`id -u -n`" ${CONTAINERS[0]} /bin/bash -c '. /home/`id -u -n`/gazebo-mental-simulation/devel/setup.bash && ls /home/`id -u -n`/world_files/*.world')
do
    # perform repeated experiment run using next container
    export DISPLAY_ID=$((CONTAINER_INDEX+1))
    ./repetitive_experiment.sh ${CONTAINERS[$((CONTAINER_INDEX))]} ${worldfile_path} $world_file ${num_repetitions} &
    # increment container index
    CONTAINER_INDEX=$((($CONTAINER_INDEX+1)%$NUM_CONTAINERS))
    # wait for all containers to finish
    if [[ ($CONTAINER_INDEX == 0) ]]; then
        wait
    fi
done
