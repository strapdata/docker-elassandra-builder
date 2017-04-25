# docker-elassandra-builder
Containerized build environment for Elassandra

Available on [docker hub](https://hub.docker.com/r/strapdata/elassandra-builder/):
```bash
docker pull strapdata/elassandra-builder
```

**Warning**: this works with an internal version of elassandra that is not yet published.

## Usage

#### One-shot compilation
First you need the Elassandra source on your host. Then run the container with your elassandra source directory mounted at `/src`:
```bash
docker run -v <path-to-elassandra-source>:/src -it strapdata/elassandra-builder
```
If this command succeed, you will have a new folder `collect/` within you elassandra source directory, containing the generated tarballs and packages.


#### Interactive mode
You may also want to spawn a shell in the container an call maven yourself:
```bash
docker run -v <path-to-elassandra-source>:/src -it strapdata/elassandra-builder bash
cd /src
mvn package -DskipTests
...
```

This way you can edit the code from your host but compile from the docker container.
