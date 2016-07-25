# Vagrant Build
---

The build script will destroy the virtual machine running, remove the previous box created and create the new box using Packer. Once the box is ready you can use the box file or publish it on [Vagrant Cloud](https://atlas.hashicorp.com/vagrant) so others - students - can use it.

## Using the local box
To use the box from the __filesystem__ (the created file), the `build.sh` script will do it for you if you export the variable `BOX_LOCAL` set to 1.

```bash
export BOX_LOCAL=1
./build.sh --vagrant
```

## Using the cloud box
To use the box from __Vagrant Cloud__ so everybody (i.e. Bootcamp students) can use it, just execute the `build.sh` script or export the variable `BOX_LOCAL` set to 0 (default value) before execute it.

```bash
export BOX_LOCAL=0  
./build.sh --vagrant
```

## Boxes management
To manage the box with Vagrant, use the subcommand `box`. For example:

```bash
# To list the existing boxes
vagrant box list

# To delete the box
vagrant box remove DevSecOps

# To update the boxes
vagrant box update
```

More Vagrant box commands [here](https://www.vagrantup.com/docs/cli/box.html)

## Change the box name or Atlas (Vagrant Cloud) account
The box name is __johandry/DevSecOps_CentOS_7__. To change it, modify the `Vagrantfile` in the line

```ruby
config.vm.box = "johandry/DevSecOps_CentOS_7"
```

The build script will take the name from there. The first field (`johandry`) is the Vagrant Cloud username and the second field (`DevSecOps_CentOS_7`) is the box name.

## Add more features to the box
The Vagrant box is created with Packer and we use two files to install packages or customize the new Vagrant box. These files are `packer/ks.cfg` and `packer/centos7.json`.

The `packer/ks.cfg` use Kickstart to install and configure the Linux system during the installation process. You can learn more about Kickstart syntax [here](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-kickstart-syntax.html). In the file you'll see a list of packages that will be installed, that list can be modified to add or remove packages. There is also a list with items prefixed with dash '-', those are packages that will be uninstalled. Read this file and you'll see what other modifications you can do to the system during the installation.

The `packer/centos7.json` is the Packer file. It has 4 sections: variables, builders, provisioners and post-processors. To know more about these sections go to [https://www.packer.io/](https://www.packer.io/docs/). The section to add more packages or software to install is in __provisioners__. There is an array named __scripts__ with a list of scripts to be executed after the system is installed. Some have to be in that specific order such as the first five scripts and the last two. If you need a new feature it is recommended to create a new script and included in the list after the `repos.sh` script and before the `cleanup.sh` script. The script is recommended to be `packer/scripts`. All the scripts begins with some lines, you can copy them to your new script.

## Use a newer CentOS version or different Linux
Packer is using `CentOS-7-x86_64-NetInstall-1511.iso` but if there is a newer version of CentOS or if you wish to use other Linux such as RedHat, Fedora or even Ubuntu, go to the `packer/centos7.json` and modify the following lines:

```json
"iso_url":            "http://mirror.rackspace.com/CentOS/7/isos/x86_64/CentOS-7-x86_64-NetInstall-1511.iso",
"iso_checksum":       "9ed9ffb5d89ab8cca834afce354daa70a21dcb410f58287d6316259ff89758f5",
```

The first line is the URL of the ISO file to download. The second line is the ISO checksum, in this case is in type SHA256. To use a different checksum type, modify the parameter `iso_checksum_type` If you will use other Linux distro but CentOS, would be nice to modify the parameter `distro_name` and make sure the scripts will run (i.e replace yum for apt)

## Upload the box to the cloud
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

At this time this process is manual but it can be automated. To do so, it can be done in the `build.sh` script but it can be done with Packer as well. In the post-processors section of the file `packer/centos7.json` we can use the `vagrant-cloud` post-processors to upload the new box to Atlas. Other option is to upload the box to other location (i.e. AWS S3, Dropbox, an FTP server) and make the Vagrant Cloud box point to that location instead of uploading the box there.
