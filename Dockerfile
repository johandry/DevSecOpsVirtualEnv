FROM johandry/centos7-devsecops

MAINTAINER "Johandry Amador" <johandry@gmail.com>

EXPOSE 8080:8081
EXPOSE 3000:3001

WORKDIR /root/workspace

CMD ["/bin/bash","--login"]
