# Docker Build

The docker build is way more faster than the vagrant build and it upload the image to Docker Hub automatically, something that - at this time - have to be done manually with the vagrant build.

## Remove the Container and Images
When the image is not needed, you may delete the container and image.

    docker images
    docker rm $(docker ps -a | grep johandry/devsecops | cut -f1 -d\ )
    docker rmi johandry/devsecops

## Sharing a directory with the container
To share the local directory in the container use the parameter `-v ${pwd}/workspace:/root/workspace` when you run the container. However, it can be avoided if you share the directory (if it is not already shared) using the __File Sharing__ tab in the Docker Preferences.

  1. Click on the Docker icon (the whale with containers).
  1. Select __Preferences__ and go to the __File Shareing__ tab.
  1. Add the volume you want to share with the container (if not already there).
  1. Click __Apply & Restart__ to make the new directory available in every container.

## Adding more features
To install more programs to the Docker image open the file `docker/Dockerfile` and add a new `RUN` instructions and join all the commands with double ampersand (&&).

Is that, or create another Dockerfile that include the image `johandry/centos7-devsecops` using the instruction `FROM` like this:

    FROM johandry/centos7-devsecops

And include a `RUN` instruction to install whatever you need. Or, use the `Dockerfile` located in the project to do the same.

Sometimes what you need do not require to modify the Dockerfile. Let's say you need Jenkins to do a Penetration Test ([Bootcamp, Week 6, Lab 2](https://github.com/devsecops/bootcamp/blob/3db7df6bf74dbe0bd9d5f5b4b1a4843c8d257bb4/Week-6/labs/LAB-2.md)), it is better to have a new container running Jenkins (this one, for example: https://hub.docker.com/_/jenkins/) and link the two container. 
