FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DIST=debian
ENV RELEASE=buster

RUN apt-get -qq update \
    && apt-get install --no-install-recommends -y \
      gnupg1 \
      gpgv1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Aptly repository
RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys ED75B5A4483DA07C

# Nginx repository
RUN echo "deb http://nginx.org/packages/$DIST/ $RELEASE nginx" > /etc/apt/sources.list.d/nginx.list
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62

RUN apt-get -qq update \
    && apt-get install --no-install-recommends -y \
      aptly           \
      bzip2           \
      ca-certificates \
      graphviz        \
      supervisor      \
      nginx           \
      xz-utils        \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*

# Install rootfs overrides
COPY rootfs /

ENTRYPOINT [ "/startup.sh" ]
