# zfs-build

This defines a container that will build the ZFS sources and kmods inside a
container and then copy the built RPMs to the home directory under `zfs-rpms`.

By default, this builds for RHEL 9.6 Extended Update Support.

## Usage:

```bash
./run
rpm -ivh ~/zfs-rpms/*.rpm
```

You can override some settings:

* `ZFSVER` - the zfs tag / release to build against.
* `RELEASEVER` - the specific RHEL version to build against.
* `RHEL_REPOS` - the RHEL repository names, by default is the eus repos.

You have to be root to run this due to how the kmod build checks determine the
underlying kernel ABI. You need real root privs in order for the build process
to check all the needed ABIs.

## What it does


