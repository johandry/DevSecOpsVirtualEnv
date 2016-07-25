# Docker Build

The docker build is way more faster than the vagrant build and it upload the image to Docker Hub automatically, something that - at this time - have to be done manually with the vagrant build.

When the image is not needed, you may delete the container and image.

    docker images
    docker rm $(docker ps -a | grep johandry/devsecops | cut -f1 -d\ )
    docker rmi johandry/devsecops

To share the local directory in the container use the parameter `-v ${pwd}/workspace:/root/workspace` when you run the container. However, it can be avoided if you share the directory (if it is not already shared) using the __File Sharing__ tab in the Docker Preferences.

  1. Click on the Docker icon (the whale with containers).
  1. Select __Preferences__ and go to the __File Shareing__ tab.
  1. Add the volume you want to share with the container (if not already there).
  1. Click __Apply & Restart__ to make the new directory available in every container.
