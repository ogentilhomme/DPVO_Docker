#!/bin/bash

set -e

MOUNT_DATA='/media/SSD2/aria_lamar/asl_datasets_undistort'
MOUNT_SCRIPTS='/local/home/ogentilhomme/repos/aria-lamar/baselines/dpvo'
MOUNT_ESTIMATE_FOLDER='/media/HD8TB/aria_lamar/baselines/algorithms/dpvo'

IMAGE_NAME='dpvo_docker_img'
CONTAINER_NAME='dpvo_container'

cleanup_container() {
    if [ "$(sudo docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
        echo "Stopping and removing existing container: $CONTAINER_NAME"
        sudo docker stop $CONTAINER_NAME
        sudo docker rm $CONTAINER_NAME
    fi
}

setup_x11_permissions() {
    echo "Setting up X11 permissions..."

    XSOCK=/tmp/.X11-unix
    XAUTH=/tmp/.docker.xauth


    # Remove existing xauth file if it exists
    [ -f $XAUTH ] && rm $XAUTH
    touch $XAUTH

    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
    
    # Check for errors during xauth
    if [ $? -ne 0 ]; then
        echo "Error setting up xauth. Check your DISPLAY variable or xauth setup."
        exit 1
    fi

    xhost +local:docker &> /dev/null
}

cleanup_container
# setup_x11_permissions

sudo docker run --rm -it --privileged --ipc=host \
    --name="$CONTAINER_NAME" \
    --net=host \
    --gpus all \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="ROS_IP=127.0.0.1" \
    --env="__GLX_VENDOR_LIBRARY_NAME=nvidia" \
    --name="$CONTAINER_NAME" \
    --env NVIDIA_DISABLE_REQUIRE=1 \
    --cap-add=SYS_PTRACE \
    -v /etc/group:/etc/group:ro \
    --mount type=bind,source="$MOUNT_DATA",target=/datasets \
    --mount type=bind,source="$MOUNT_SCRIPTS",target=/scripts \
    --mount type=bind,source="$MOUNT_ESTIMATE_FOLDER",target=/save_trajectory \
    $IMAGE_NAME /bin/bash  -c "tmux"
    # \
    #     tmux new-session -d -s mysession; \
    #     source activate dpvo && \
    #     ./install_dpvo.sh && \
    #     tmux attach -t mysession"
    