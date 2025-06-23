FROM ghcr.io/osgeo/gdal:ubuntu-full-3.10.0

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    git \
    libpq-dev \
#    ca-certificates \
#    build-essential \
    saga \
    nodejs \
    npm \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN npm install -g configurable-http-proxy

ADD . /code
WORKDIR /code
RUN pip install --break-system-packages -r requirements.txt 

CMD jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
