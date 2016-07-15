FROM centos:7

MAINTAINER "Johandry Amador" <johandry@gmail.com>

ENV RUBY_VER 2.3.1

# For Python source, use the .tar.xz file.
ENV PYTHON_2 http://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
ENV PYTHON_3 http://www.python.org/ftp/python/3.4.3/Python-3.4.3.tar.xz

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
    /bin/bash --login -c "rbenv install ${RUBY_VER} && rbenv global ${RUBY_VER}" && \
    /bin/bash --login -c "gem install bundler rails"

# Installing Python 2 & 3 (AWS CLI requirement) and pip
RUN cd /tmp && \
    wget ${PYTHON_2} -O /tmp/Python-2.tar.xz && \
    wget ${PYTHON_3} -O /tmp/Python-3.tar.xz && \
    tar xf Python-2.tar.xz && rm -f Python-2.tar.xz && \
    tar xf Python-3.tar.xz && rm -f Python-3.tar.xz && \
    cd /tmp/Python-2* && ./configure && make && make install && \
    cd /tmp/Python-3* && ./configure && make && make install && \
    cd /tmp && \
    rm -rf /tmp/Python-2* && \
    rm -rf /tmp/Python-3* && \
    yum install -y python-pip && \
    pip install --upgrade pip

# Install AWS CLI
RUN pip install awscli

# Install Assumer (DevSecOps Toolkit)
RUN mkdir -p /root/toolkit && \
    cd $_ && \
    git clone https://github.com/devsecops/assumer && \
    /bin/bash --login -c "cd /root/toolkit/assumer/source && gem build assumer.gemspec && gem install assumer-*.gem"

# Install Restacker (DevSecOps Toolkit)
RUN mkdir -p /root/toolkit && \
    cd $_ && \
    git clone https://github.com/devsecops/restacker && \
    /bin/bash --login -c "cd /root/toolkit/restacker/source && bundle && gem build restacker.gemspec && gem install restacker-*.gem"

# Install Selfie (DevSecOps Toolkit)
RUN mkdir -p /root/toolkit && \
    cd $_ && \
    git clone https://github.com/devsecops/selfie && \
    /bin/bash --login -c "cd /root/toolkit/selfie && bundle && gem build selfie.gemspec && gem install selfie-*.gem"

RUN yum clean all

ENV HOME /root
