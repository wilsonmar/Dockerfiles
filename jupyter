FROM alpine:3.5
LABEL maintainer "Zac Flamig <zflamig@uchicago.edu>"

RUN apk --no-cache add \
	ca-certificates \
	cmake \
	freetype-dev \
	g++ \
	gcc \
	gfortran \
	git \
	lapack-dev \
	libpng-dev \
	libstdc++ \
	linux-headers \
	m4 \
	make \
	musl-dev \
	python3 \
	python3-dev \
	wget \
	zlib-dev \
	&& ln -s /usr/include/locale.h /usr/include/xlocale.h \
	&& pip3 install --upgrade pip \
	&& python3 -m pip --no-cache-dir install \
	numpy

RUN apk --no-cache add \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        proj4-dev

# HDF5 Installation
RUN wget https://www.hdfgroup.org/package/bzip2/?wpdmdl=4300 \
        && mv "index.html?wpdmdl=4300" hdf5-1.10.1.tar.bz2 \
        && tar xf hdf5-1.10.1.tar.bz2 \
        && cd hdf5-1.10.1 \
        && ./configure --prefix=/usr --enable-cxx --with-zlib=/usr/include,/usr/lib/x86_64-linux-gnu \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf hdf5-1.10.1 \
        && rm -rf hdf5-1.10.1.tar.bz2 \
	&& export HDF5_DIR=/usr

RUN HDF5_LIBDIR=/usr/lib HDF5_INCDIR=/usr/include python3 -m pip --no-cache-dir install \
	--no-binary=h5py h5py

# NetCDF Installation
RUN wget https://github.com/Unidata/netcdf-c/archive/v4.4.1.1.tar.gz \
        && tar xf v4.4.1.1.tar.gz \
        && cd netcdf-c-4.4.1.1 \
        && ./configure --prefix=/usr \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf netcdf-c-4.4.1.1 \
        && rm -rf v4.4.1.1.tar.gz

# GEOS Installation
RUN wget http://download.osgeo.org/geos/geos-3.6.2.tar.bz2 \
        && tar xf geos-3.6.2.tar.bz2 \
        && cd geos-3.6.2 \
        && ./configure --prefix=/usr \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf geos-3.6.2 \
        && rm -rf geos-3.6.2.tar.bz2

# GDAL Installation
RUN git clone https://github.com/OSGeo/gdal.git /gdalgit \
        && cd /gdalgit/gdal \
        && ./configure --prefix=/usr \
        && make \
        && make install \
	&& cd / \
	&& rm -rf gdalgit

RUN HDF5_LIBDIR=/usr/lib HDF5_INCDIR=/usr/include python3 -m pip --no-cache-dir install \
        boto3 \
        cartopy \
        fiona \
        gdal \
        geopandas \
        matplotlib \
        netcdf4 \
	notebook \
        pandas \
        pyproj \
	requests \
        https://github.com/matplotlib/basemap/archive/v1.1.0.tar.gz \
        scipy \
        scikit-learn \
        shapely \
	&& mkdir /notebooks

WORKDIR /notebooks
CMD /bin/sh -c "/usr/bin/jupyter-notebook --allow-root --no-browser --ip=0.0.0.0 --notebook-dir=/notebooks"
