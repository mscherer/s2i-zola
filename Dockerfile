FROM registry.fedoraproject.org/fedora:34
MAINTAINER Michael Scherer <mscherer@redhat.com>


LABEL \
      # Location of the STI scripts inside the image.
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.k8s.description="Platform for building and running static website with zola (using cargo)" \
      io.k8s.display-name="Zola builder, Fedora 34" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder"


ENV \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    HOME=/opt/app-root/ 
RUN dnf install -y tar bsdtar shadow-utils git darkhttpd && dnf clean all
RUN useradd -m -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin -c "Default Application User" default

RUN dnf install -y cargo gcc-g++ pkgconfig libsass-devel && dnf clean all
RUN cd /tmp/ && git clone https://github.com/getzola/zola/ && cd zola && cargo build --release && cp target/release/zola /usr/local/bin/ && rm -Rf /tmp/zola

COPY ./s2i/bin/ $STI_SCRIPTS_PATH
WORKDIR ${HOME}

USER 1001

EXPOSE 8080
# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage

