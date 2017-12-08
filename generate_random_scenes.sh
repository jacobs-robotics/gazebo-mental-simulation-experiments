#!/bin/bash
source config/experiments.cfg

# we need only one container for this
CONTAINER=${image_name}1

# stop container if running
docker kill ${CONTAINER} &> /dev/null
# wait until the container has been stopped
until [ "`/usr/bin/docker inspect -f {{.State.Running}} ${CONTAINER}`" == "false" ]; do
    sleep 0.1;
done;
# restart container
docker start ${CONTAINER} &
# wait until the container is officially running
until [ "`/usr/bin/docker inspect -f {{.State.Running}} ${CONTAINER}`" == "true" ]; do
	sleep 0.1;
done;

# loop this infinitely; need to stop random scene generator manually after all scenes have been generated
while :
do
    # start random scene generation
    timeout --signal=SIGKILL ${timeout} docker exec -t ${CONTAINER} /bin/bash -c ". /usr/share/gazebo/setup.sh && . /home/${user}/${image_name}/devel/setup.bash && roslaunch ${experiment_launch_package_name} ${random_scenes_launch_file_name} gui:=true"
    # stop container
    docker kill ${CONTAINER} &> /dev/null
    # wait until the container has been stopped
	until [ "`/usr/bin/docker inspect -f {{.State.Running}} ${CONTAINER}`" == "false" ]; do
		sleep 0.1;
	done;
    # start container
	docker start ${CONTAINER} &
	# wait until the container is officially running
	until [ "`/usr/bin/docker inspect -f {{.State.Running}} ${CONTAINER}`" == "true" ]; do
		sleep 0.1;
	done;
done
