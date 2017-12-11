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
... which run `gradle assemble`.


Others commands can be executed, for instance you can do:
```bash

GRADLE_CMD="gradle assemble distribution:tar:assemble -Dbuild.snapshot=false" \
docker run --rm -v <path-to-elassandra-source>:/home/builder/src strapdata/elassandra-builder

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
You may also want to spawn a shell in the container an call gradle yourself:
```bash
docker run -v <path-to-elassandra-source>:/src -it strapdata/elassandra-builder bash
cd /src
gradle assemble distribution:tar:assemble -Dbuild.snapshot=false
...
```

This way you can edit the code from your host but compile from the docker container.
