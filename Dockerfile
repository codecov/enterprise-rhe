FROM        rhel7.2:latest
MAINTAINER  Codecov <enterprise@codecov.io>

RUN         yum -y update
RUN         yum -y install python-devel postgresql-devel supervisor nginx
RUN         mkdir /config
COPY        docker/cacert.pem /etc/ssl/cert.pem
COPY        docker/run /bin/run
COPY        docker/config /bin/config
COPY        docker/http.nginx.conf /http.nginx.conf
COPY        docker/https.nginx.conf /https.nginx.conf
COPY        docker/mime.types /mime.types
COPY        docker/codecov /codecov

EXPOSE      80 443
CMD         ["/bin/run"]
