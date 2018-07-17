# Memcached container

This repo contains all resources for Memcached container running in OpenShift.
The image is automatically rebuild in [UpShifh](https://paas.upshift.redhat.com/console/project/rad-memcached/browse/images) based on SCM event.
Also it gets automatically rebuilt when new RHEL 7 base image gets released.

### How to use the image in OpenShift
The first and the easiest way how to run memcached container
is by using following oc command:

```
oc new-app rad-memcached/memcached
```
This will create simple app with default configuration.


You will likely need more complex deployment at least to adjust memory
allocation of the pod to roughly match memory configured
for memcached (512MiB by default).

The example of such a template can be found [here](http://git.app.eng.bos.redhat.com/git/metaxor.git/tree/openshift/memcached-template.yml).

### Run image localy
```
docker build .
sudo docker run \
   -e PORT=11211 \
   -e MEMORY_LIMIT=1024 \
   -e EXTRA_ARGS='-vv' \
   -p 127.0.0.1:11211:11211/tcp \
   $IMAGE_ID
```
