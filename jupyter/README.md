Docker Container for Jupyter
===

from https://github.com/occ-data/docker-jupyter/blob/master/README.md
(Open Commons Consortium) http://edc.occ-data.org/software/
used to working with global radiance data from GOES-16 satellites using the netCDF4 package
obtained via S3-API compatible service,
as described at http://edc.occ-data.org/goes16/python/#reading-in-goes-16-netcdf

https://t.co/1KtYyjKf4v
 Geostationary Lightning Mapper (GLM) provides point based data of lightning, flashes, groups, and events.
 
This Docker container is set up for Python3, HDF5, NetCDF, and Jupyter using an Alpine base image.

# Running
```
docker run -ti --name nb --rm -v $(pwd)/notebooks:/notebooks -p 8888:8888 quay.io/occ_data/docker-jupyter
```
