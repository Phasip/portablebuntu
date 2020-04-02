# portablebuntu
Builds and packs a ubuntu container &amp; runtime into a single shell script that can be run on any host with linux namespaces support
# usage
```sudo bash ./build_container.sh```

will dump out a container.sh which is the runnable
# Requirements on build system
Docker, wget, tar
# Requirements on usage system
tar, sh, tail, sudo
linux kernel with namespaces support
# Behind the scenes?
It creates a docker ubuntu:latest container, installs a few tools on it (see script if you wanna change)
exports the container and places it in a folder together with runc (a stand alone container runtime) and a configuration
file that gives the container access to everything on the host (only uses mount ns)
Then it downloads runc
Packs it all into a nice self extracting shell script and now you are good to go.
