# docker-elassandra-builder
Containerized build environment for Elassandra

Available on [docker hub](https://hub.docker.com/r/strapdata/elassandra-builder/):
```bash
docker pull strapdata/elassandra-builder
```

## Usage

#### One-shot compilation
First you need the Elassandra source on your host. Then run the container with your elassandra source directory mounted at `/src`:
```bash
docker run -v <path-to-elassandra-source>:/home/builder/src strapdata/elassandra-builder
```
... which run `mvn clean package -skipTests`.

Others commands can be executed, for instance you can do:
```bash
docker run -v <path-to-elassandra-source>:/src strapdata/elassandra-builder mvn --version
```

Additionally, you may want to fix ownership of generated files. For this purpose you have to set three variables in the environment:
```bash
docker run -v <path-to-elassandra-source>:/src \
           -e FIX_OWNERSHIP=true \
           -e FIXED_OWNER=$(id -u) \
           -e FIXED_GROUP=$(id -g) \
           strapdata/elassandra-builder
```

#### Interactive mode
You may also want to spawn a shell in the container an call maven yourself:
```bash
docker run -v <path-to-elassandra-source>:/src -it strapdata/elassandra-builder bash
cd /src
mvn package -DskipTests
...
```

This way you can edit the code from your host but compile from the docker container.
