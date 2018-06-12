Docker Container for Jupyter
===

from https://github.com/occ-data/docker-jupyter/blob/master/README.md

This Docker container is set up for Python3, HDF5, NetCDF, and Jupyter using an Alpine base image.

# Running
```
docker run -ti --name nb --rm -v $(pwd)/notebooks:/notebooks -p 8888:8888 quay.io/occ_data/docker-jupyter
```
