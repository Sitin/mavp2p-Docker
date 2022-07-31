mavp2p-Docker
=============

[![Publish to Docker registry](https://github.com/Sitin/mavp2p-Docker/actions/workflows/main.yml/badge.svg)](https://github.com/Sitin/mavp2p-Docker/actions/workflows/main.yml) [![Update latest tag according to mavp2p](https://github.com/Sitin/mavp2p-Docker/actions/workflows/update-tags.yml/badge.svg)](https://github.com/Sitin/mavp2p-Docker/actions/workflows/update-tags.yml)

Dockerized [mavp2p](https://github.com/aler9/mavp2p) proxy for [MAVLink](https://mavlink.io/en/).

[DockerHub](https://hub.docker.com/r/sitin/mavp2p).

CI/CD is configured to automatically release new image on new mavp2p tag (scheduled run twice per day).
See [`.github/workflows/update-tags.yml`](.github/workflows/update-tags.yml) and [`update-tags.sh`](update-tags.sh).

> **WARNING!!!**
> 
> This is unofficial image. Once mavp2p community decide to create an official image, this repository will be either
> archived or turned into the set of tools to build mavp2p server for a custom MAVLink dialect.
> 
> We suggest to always use a specific version tag for mavp2p (e.g. `sitin/mavp2p:0.6.5` instead of just `sitin/mavp2p`).

Usage
-----

Run the `0.6.5` image (we use `-sig-proxy=false` to allow Ctr+C), accept incoming connection to UDP port `14540` and
proxy it to the host machine's UDP port `14550`:

```shell
docker run --rm --sig-proxy=false -p 14540:14540/udp sitin/mavp2p:0.6.5 udps:0.0.0.0:14540 udpc:host.docker.internal:14550
```

Development
-----------

Create a platform-specific build:

```shell
make build
```

Start the server:

```shell
make up
```

Run tests (multiplatform build):

```shell
make test
```

Clean up:

```shell
make clean
```
