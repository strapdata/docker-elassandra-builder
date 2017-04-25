# docker-elassandra-builder
Containerized build environment for Elassandra

Usage
-----
**Warning**: this works with an internal version of elassandra that is not yet published.

First you need the Elassandra source on your host. Then run the container with your elassandra source directory mounted at `/src`: 
```bash
docker run -v <path-to-elassandra-source>:/src -it strapdata/elassandra-builder
```
If this command succeed, you will have a new folder `collect/` within you elassandra source directory, containing the generated tarballs and packages.
