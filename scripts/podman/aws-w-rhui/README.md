# Create podman image using UBI on AWS RHUI

According to this KB, it's not possible:
[Can I perform containerized image builds using Red Hat Update Infrastructure (RHUI)?][1]

[1]: https://access.redhat.com/solutions/3363731

However, you **CAN** do it. It's just a little complicated.

Essentially, you need to:

1. download the RHUI rpms
2. copy them into the container
3. install the RHUI rpms
4. disable the UBI repos
5. run the build with the host's network

The reason for all this is to ensure the container has the correct certificates to access the
RHUI repos. In the past, you could just copy the RHUI directories and certificates and be good.
That doesn't work anymore, unfortunately. Also, after some strace() work, I realized that the
container is accessing the AWS metadata service to obtain a new auth token for the RHUI repos.
The metadata service doesn't respond correctly through the container network namespace, so to
get it to work, you have to use the host's network.

I made a build script and a sample `Containerfile` as an example.

They're added as files below.

You run it like this:

```bash
./run
```

Let me know if this works for you!
