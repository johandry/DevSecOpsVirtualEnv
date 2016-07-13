FROM centos:7

MAINTAINER "Johandry Amador" <johandry@gmail.com>

ENV RUBY_VER 2.3.1

# Install base packages
RUN yum install -y  epel-release \
                    gcc \
                    make \
                    perl \
                    curl \
                    curl-devel \
                    wget \
                    bzip2 \
                    tar \
                    patch \
                    net-tools \
                    git \
                    vim \
                    xz-libs \
                    sudo \
                    nfs-utils

# Installing Ruby and required gems
RUN yum install -y  autoconf \
                    bison \
                    openssl-devel \
                    expat-devel \
                    gettext-devel \
                    readline-devel \
                    gcc-c++ \
                    zlib-devel && \
    git clone https://github.com/rbenv/rbenv.git /root/.rbenv && \
    git clone https://github.com/rbenv/ruby-build /root/.rbenv/plugins/ruby-build && \
    echo 'export PATH="/root/.rbenv/bin:$PATH"' > /etc/profile.d/rbenv-path-setup.sh && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv-path-setup.sh && \
    echo 'install: --no-document\nupdate: --no-document\ngem: --no-document' >> "$HOME/.gemrc" && \
    /bin/bash --login -c "rbenv rehash && rbenv install ${RUBY_VER} && rbenv global ${RUBY_VER}" && \
    /bin/bash --login -c "gem install bundler rails"





ENV HOME /root

CMD ["/bin/bash","--login"]
