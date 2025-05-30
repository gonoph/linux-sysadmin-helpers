# podman scripts

Useful (to me) scripts that use podman or influence podman

## aws-w-rhui - Create podman image using UBI on AWS RHUI

[aws-w-rhui](aws-w-rhui) - Create podman image using UBI on AWS with RHUI

It's not intuitive trying to build a ubi image on AWS and have it consume RHUI
content. This attempts to solve that.

# zfs-build - Using a container to build ZFS kmod and binaries

[zfs-build](zfs-build) - Container build environment and script

Sometimes you don't want DKMS, nor all the build tools installed on a server.
Howver, you also want to install something from source on the server. Such was
my experience after upgrading to RHEL 9.6 and the ZFS kmod packages weren't
updated, yet.

This makes it work for me.

It's designed for RHEL 9.6 EUS.
