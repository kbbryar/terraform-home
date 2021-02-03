#TODO
  * configure terraform to communicate to the primary server
  * Need to create an FTP server to serve images locally
  * fix podman to use host user's git credentials

#Notes
The first server to be upped, will need to be an image server to minimize
the amount of traffic that needs to leave the home network. At a future state
the images can be generated locally via yocto or buildroot to ensure they are
specific, targetive, and repeatable

##development environment
The development environment includes a makefile for use on the host system. The
makefile is primitive, but fulfills the following needs:
  * generate cryptographic keys
  * build the image
  * run the image
  * stop the image
  * clean-up the image build content

The dockerfile is configured to instantiate a container image that is capable of
running the terraform application. Once instantiated then the image can be run to
perform development efforts.

###known issues
The ability to commit code does not exist within the container. Code should be commit
while on the host system only.
