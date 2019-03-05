FROM fedora:latest

ENV PORT=11211
ENV MEMORY_LIMIT=512
ENV MAX_CON=1024
ENV EXTRA_ARGS=''


LABEL summary="Memcached container based on latest Fedora base container" \
      description="Memcached container based on latest Fedora base container" \
      io.k8s.description="Memcached container based on latest Fedora base container" \
      io.k8s.display-name="Fedora memcached" \
      io.openshift.expose-services="$PORT:memcached" \
      io.openshift.tags="fedora,memcached"

EXPOSE $PORT

# Create user for memcached that has known UID
# We need to do this before installing the RPMs which would create user with random UID
RUN getent group  memcached &> /dev/null || groupadd -r memcached &> /dev/null && \
    getent passwd memcached &> /dev/null || useradd -u 1001 -r -g memcached -d /run/memcached -s /sbin/nologin \
           -c 'Memcached daemon' memcached &> /dev/null

RUN INSTALL_PKGS='memcached' && \
    dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf clean all -y && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime

USER memcached

ENTRYPOINT memcached -p $PORT -m $MEMORY_LIMIT -c $MAX_CON $EXTRA_ARGS
