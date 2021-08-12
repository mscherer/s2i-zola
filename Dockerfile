FROM registry.fedoraproject.org/fedora:34
MAINTAINER Michael Scherer <mscherer@redhat.com>


LABEL \
      # Location of the STI scripts inside the image.
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.k8s.description="Platform for building and running static website with zola" \
      io.k8s.display-name="Zola builder, Fedora 34" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder"


ENV \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH
RUN dnf install -y tar bsdtar shadow-utils git && dnf clean all
RUN mkdir -p /opt/app-root/src
RUN useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin -c "Default Application User" default
RUN chown -R 1001:0 /opt/app-root 

RUN dnf install -y zola nginx && dnf clean all

COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./s2i/nginx.conf  /etc/nginx/nginx.conf
WORKDIR ${HOME}

USER 1001

EXPOSE 8080
# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage

