
cd /local/home/anusha/repos/DPVO
echo "Removing dpvo docker image if already exists..."
sudo docker rm -f dpvo 2> /dev/null
sudo docker rmi -f dpvo_docker_img 2> /dev/null
sudo docker build --tag dpvo_docker_img --build-arg CUDA_VERSION=$1 .
