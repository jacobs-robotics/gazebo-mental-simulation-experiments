# gazebo-mental-simulation-experiments
A set of scripts to run experiments using our [parallelized Gazebo container setup](https://github.com/jacobs-robotics/gazebo-mental-simulation). This repository has to be cloned into a subfolder of the `gazebo-mental-simulation` repository, but this is usually done automatically using the `create.sh` script in said repository.

## Experiment on a single world file
```bash
./experiment.sh <container_name> <world_file_path>
```

## Repetitive experiment on a number of world files
This will use all existing containers (as defined in `containers.cfg`) to run your experiment via the launch file specified in `experiments.cfg`. This operates on all world files in the world file directory given in `containers.cfg`.
```bash
./run_experiments.sh
```
