# Vagrant Build

The build script will destroy the virtual machine running, remove the previous box created and create the new box using Packer. Once the box is ready you can use the box file or publish it on [Vagrant Cloud](https://atlas.hashicorp.com/vagrant) so others - students - can use it.

To use the box from the __filesystem__ (the created file), the `build.sh` script will do it for you if you export the variable `BOX_LOCAL` set to 1.

    export BOX_LOCAL=1
    ./build.sh --vagrant

To use the box from __Vagrant Cloud__ so everybody (i.e. Bootcamp students) can use it, just execute the `build.sh` script or export the variable `BOX_LOCAL` set to 0 (default value) before execute it.

    export BOX_LOCAL=0  
    ./build.sh --vagrant

To manage the box with Vagrant, use the subcommand `box`. For example:

    # To list the existing boxes
    vagrant box list

    # To delete the box
    vagrant box remove DevSecOps

    # To update the boxes
    vagrant box update

More Vagrant box commands [here](https://www.vagrantup.com/docs/cli/box.html)

To make the Vagrant box available, it have to be uploaded first. _This process can and will be automated_.
  1. Go to https://atlas.hashicorp.com/vagrant and login.
  1. Go to the box __DevSecOps_CentOS_7__.
  1. Create a new version going to __New Version__ at the left menu.
  1. Enter the version number. Make sure it is compatible with [RubyGems versioning](http://guides.rubygems.org/patterns/#semantic-versioning).
  1. Enter the description. You can use the description of the previous version and add what is new.
  1. Click on __Create new provider__.
  1. Select the provider __VirtualBox__ and __Upload__. Click on __Continue to upload__.
  1. Choose the created file located in the directory `vagrant/boxes`.
  1. Click on Finish and go to Versions.
  1. Click on the __unreleased link__ then in __Release version__ button.


The box name is __johandry/DevSecOps_CentOS_7__. To change it, modify the `Vagrantfile` in the line

```ruby
config.vm.box = "johandry/DevSecOps_CentOS_7"
```

The build script will take the name from there. The first field (`johandry`) is the Vagrant Cloud username and the second field (`DevSecOps_CentOS_7`) is the box name.
