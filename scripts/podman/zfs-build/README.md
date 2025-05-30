# zfs-build

This defines a container that will build the ZFS sources and kmods inside a
container and then copy the built RPMs to the home directory under `zfs-rpms`.

By default, this builds for RHEL 9.6 Extended Update Support.

## Usage:

```bash
cp zfs.repo /etc/yum.repos.d
./run
dnf install zfs kmod-zfs
```

You can override some settings:

* `--skip`       - Skip the check for host updates. This attempts to make the build consistent between host and artifacts.
* `--kernel`     - override the detected kernel version to build against. Useful to build against a kernel you haven't booted into, yet.
* `--zfsver`     - the zfs tag / release to build against.
* `--releasever` - the specific RHEL version to build against.
* `--rhelrepos`  - the RHEL repository names, by default is the eus repos.

You have to be root to run this due to how the kmod build checks determine the
underlying kernel ABI. You need real root privs in order for the build process
to check all the needed ABIs.

## What the run script does

1. Validates the current host has no more updates to install.
2. Checks if you're running as root to ensure the kmod checks don't hang. (not sure why it hangs as non-root)
3. Creates a cache directory for dnf - in case you run this multiple times
4. Starts the podman build - a multi-stage build
5. Creates a mount point from the created image
6. Copies the generated "repository" to the local file system

## What the Container build does

The 1st build phase preps and packages the sources for rpmbuild:

1. Downloads UBI (9.6 by default)
2. sets some default args
3. disables all repositories - this is required so the UBI repos don't conflict with the EUS repos
4. enables the EUS repos by default
5. sets the release to 9.6 by default - this is required for EUS to work
6. updates the container
7. installs the development tools
8. tests that the host kernel (that was passed in) is the same as the kernel-devel (that was installed)
9. preps the destination for the project clone
10. Clones the zfs project by release tag
11. enters the zfs project repo, and starts the prep stage

The 2nd build phase:

1. starts an rpmbuild for zfs-kmod packages
2. starts an rpmbuild for zfs packages

The 3rd build phase:

1. copies all the packages from zfs-kmod and zfs phases into a directory
2. creates the repo metadata from that directory, turning it into a repository

The final build phase:

1. Copies the repository into a scratch image

# TODO

* better versioning, maybe edit the spec files to introduce slots of to build it based on current kernel
* figure out why the rootless container hangs on building the kmod
