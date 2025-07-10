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
RUN mkdir -p /data/terrain_attributes
COPY requirements.txt /code/requirements.txt
COPY Workflow-notebooks/create_mrvbf_mrrtf.sh /code/create_mrvbf_mrrtf.sh
COPY Workflow-notebooks/create_slope.sh /code/create_slope.sh
COPY Workflow-notebooks/classification.py /code/classification.py

RUN pip install --break-system-packages -r requirements.txt
RUN pip install --break-system-packages mapclassify

CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--no-browser", "--allow-root"]
