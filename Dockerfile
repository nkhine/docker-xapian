FROM python:rc-alpine
## Install global dependencies
RUN apk add --update \
    build-base \
    cmake \
    curl-dev \
    gcc \
    gettext \
    linux-headers \
    openssl \
    py-pip \
    python3-dev \
    util-linux-dev \
    zlib-dev && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip
# INSTALL sphinx
RUN pip3 install sphinx
# Install xapian-core
ADD https://oligarchy.co.uk/xapian/1.4.18/xapian-core-1.4.18.tar.xz /tmp/
WORKDIR /tmp/
RUN tar Jxf /tmp/xapian-core-1.4.18.tar.xz
WORKDIR /tmp/xapian-core-1.4.18
RUN ./configure && make && make install
# Install xapian-bindings python
ADD http://oligarchy.co.uk/xapian/1.4.18/xapian-bindings-1.4.18.tar.xz /tmp/
WORKDIR /tmp/
RUN tar Jxf /tmp/xapian-bindings-1.4.18.tar.xz
WORKDIR /tmp/xapian-bindings-1.4.18
RUN ./configure --with-python3 && make && make install
RUN pip3 install --no-cache-dir xapian-bindings
RUN python3 -c "import xapian; print(xapian.__version__)"

WORKDIR /app
COPY ./100-objects-v1.csv ./
COPY ./index.py ./
RUN python index.py 100-objects-v1.csv db
COPY ./search.py ./
