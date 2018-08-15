#!/bin/bash
source config/experiments.cfg

EXIST_OPTION=0
INTERACTIVE=""
# use "false" as default argument in case this variable has not been set outside
gui=${gui:-"false"}

DISPLAY_ID=${DISPLAY_ID:-1}
SHUTDOWN="true"

if [[ ($# -gt 0 && $1 == "-i" || $# -gt 1 && $2 == "-i" || $# -gt 2 && $3 == "-i") ]]; then
    EXIST_OPTION=1
    echo -e "${GREEN}>>> Starting container with interactive option...${NC}"
    INTERACTIVE="-i"
    gui="true"
    verbose="true"
fi

if [[ ($# -gt 0 && $1 == "-k" || $# -gt 1 && $2 == "-k" || $# -gt 2 && $3 == "-k") ]]; then
    echo -e "${GREEN}>>> Keeping container started!${NC}"
    SHUTDOWN="false"
fi

# check if a world file command was given
if [[ ($# == 1) ]]; then
    echo -e "${RED}>>> ERROR: Please specify a container name to start!${NC}" >&2
    exit 1;
elif [[ ($# == 2 && $1 != "-k" && $1 != "-i") ]]; then
    container=$1
	world_file=$2
elif [[ ($# == 3 && $2 != "-k" && $2 != "-i") ]]; then
    container=$2
	world_file=$3
elif [[ ($# -gt 4) ]]; then
    container=$3
	world_file=$4
fi

echo -e "${GREEN}>>> Starting ${container} container...${NC}"
docker start $INTERACTIVE ${container} &
# wait until the container is officially running
until [ "`/usr/bin/docker inspect -f {{.State.Running}} ${container}`" == "true" ]; do
    sleep 0.1;
done;
if [[ ($world_file = "") ]]; then
    # use default world
    if [ "${gui}" == "false" ]; then
        echo -e "${YELLOW}>>> Using headless operation with display ID ${DISPLAY_ID}!${NC}"
        timeout --signal=SIGKILL $timeout docker exec $INTERACTIVE -t ${container} /bin/bash -c ". /usr/share/gazebo/setup.sh && (killall -q Xvfb; rm -f /tmp/.X${DISPLAY_ID}-lock; Xvfb :${DISPLAY_ID} -screen 0 1600x1200x16 & export DISPLAY=:${DISPLAY_ID}.0 && . /home/`id -u -n`/gazebo-mental-simulation/devel/setup.bash && roslaunch ${experiment_launch_package_name} ${experiment_launch_file_name} gui:=${gui} verbose:=${verbose}"
    else
        timeout --signal=SIGKILL $timeout docker exec $INTERACTIVE -t ${container} /bin/bash -c ". /usr/share/gazebo/setup.sh && . /home/`id -u -n`/gazebo-mental-simulation/devel/setup.bash && roslaunch ${experiment_launch_package_name} ${experiment_launch_file_name} gui:=${gui} verbose:=${verbose}"
    fi
else
    # check if given world file exists inside the docker container(!)
    if !($(docker exec --user="`id -u -n`" ${container} /bin/bash -c ". /home/`id -u -n`/gazebo-mental-simulation/devel/setup.bash && test -e $world_file_destination_path/$world_file")); then
        echo -e "${RED}>>> ERROR: World file ${world_file} not found inside container!${NC}" >&2
        exit 1
    fi
    # use provided world file
    echo -e "${GREEN}>>> Using world file ${BLUE}"$world_file"${GREEN}.${NC}"
    if [ "${gui}" == "false" ]; then
        echo -e "${YELLOW}>>> Using headless operation with display ID ${DISPLAY_ID}!${NC}"
        timeout --signal=SIGKILL $timeout docker exec $INTERACTIVE -t ${container} /bin/bash -c ". /usr/share/gazebo/setup.sh && (killall -q Xvfb; rm -f /tmp/.X${DISPLAY_ID}-lock; Xvfb :${DISPLAY_ID} -screen 0 1600x1200x16 & export DISPLAY=:${DISPLAY_ID}.0 && . /home/`id -u -n`/gazebo-mental-simulation/devel/setup.bash && roslaunch ${experiment_launch_package_name} ${experiment_launch_file_name} gui:=${gui} verbose:=${verbose} world_file:=$world_file_destination_path/$world_file world_filename:=$world_file)"
    else
        timeout --signal=SIGKILL $timeout docker exec $INTERACTIVE -t ${container} /bin/bash -c ". /usr/share/gazebo/setup.sh && . /home/`id -u -n`/gazebo-mental-simulation/devel/setup.bash && roslaunch ${experiment_launch_package_name} ${experiment_launch_file_name} gui:=${gui} verbose:=${verbose} world_file:=$world_file_destination_path/$world_file world_filename:=$world_file"
    fi
fi

# shut down container if necessary
if [[ "$SHUTDOWN" == "true" ]]; then
    ( cd .. && ./stop.sh ${container} )
fi
