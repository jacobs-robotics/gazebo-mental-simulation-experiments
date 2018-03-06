# gazebo-mental-simulation-experiments
A set of scripts to run experiments using our [parallelized Gazebo container setup](https://github.com/jacobs-robotics/gazebo-mental-simulation). This repository has to be cloned into a subfolder of the `gazebo-mental-simulation` repository, but this is usually done automatically using the `create.sh` script in said repository.

## Experiment on a single world file
```bash
./experiment.sh <container_name> <world_file_path>
```

## Repetitive experiment on a number of world files
This will use all existing containers (as defined in `containers.cfg`) to run your experiment via the launch file specified in `experiments.cfg`. This operates on all world files in the world file directory given in `containers.cfg`.
The number of containers to use can be set using the optional `num_containers` argument, omitting this uses all available containers. Using only one container is helpful for debugging because the console outputs are garbled for more than one.
**Caution: Only one container will be used with enabled GUI!** Set `gui="false"` in `experiments.cfg` when more than one container shall be used.
```bash
./run_experiments.sh <num_containers>
```
*Recommended use cases:*
* enabled GUI, one container: debugging, scripting development
* disabled GUI, multiple containers: productive experiment runs, benchmarking
