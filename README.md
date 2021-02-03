#TODO
  * Need to configure a podman Dockerfile for the development environment
  * configure the setup to communicate to the primary server
  * Need to create an FTP server to serve images locally

#Notes
The first server to be upped, will need to be an image server to minimize
the amount of traffic that needs to leave the home network. At a future state
the images can be generated locally via yocto or buildroot to ensure they are
specific, targetive, and repeatable
