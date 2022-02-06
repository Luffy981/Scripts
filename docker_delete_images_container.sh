#!/bin/bash


echo "***** What do you want to do? *****"
echo "Usage: ./scrip_name [delete(all / name image or container)]"
docker images
echo "var: "
read var
if [[ $var = "all" ]]; then
  # List all containers (only IDs)
  echo "                         Deleting all..."
  docker ps -aq
  # Stop all running containers
  docker stop $(docker ps -aq)
  # Remove all containers
  docker rm $(docker ps -aq)
  # Remove all images
  docker rmi $(docker images -q)
  # Show docker images
  echo ""
  docker images
  echo "ALL WAS DELETED... :("
elif [[ $var ]]; then
  echo "                          Deleting image..."
  # Stop  running container
  docker stop $(docker ps -a | grep $var | cut -d " " -f1)
  # Remove container
  docker rm $(docker ps -a | grep $var | cut -d " " -f1)
  # Remove image
  docker rmi $var
  # Show docker images
  echo ""
  docker images
  echo "IMAGE WAS DELETED... :("
fi

