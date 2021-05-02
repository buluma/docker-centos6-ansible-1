FROM centos:6.10
LABEL maintainer="Buluma Michael"

# CentOS 6 packages are no longer hosted on the main repository, instead they are in the CentOS Vault
RUN sed -i 's/^mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's/#baseurl=http:\/\/mirror.centos.org\/centos\/$releasever/baseurl=http:\/\/vault.centos.org\/6.10/g' /etc/yum.repos.d/CentOS-Base.repo

# Set up additional build tools
# RUN yum -y update && yum clean all
# RUN yum -y install gcc curl openssl openssl-devel ca-certificates tar perl perl-Module-Load-Conditional && yum clean all
RUN yum makecache fast \
 && yum -y install deltarpm epel-release \
 && yum -y update \
 && yum -y install \
      ansible \
      sudo \
      which \
      initscripts \
      python-urllib3 \
      pyOpenSSL \
      python2-ndg_httpsclient \
      python-pyasn1 \
 && yum clean all

# Install Rust
# RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
# ENV PATH="/root/.cargo/bin:${PATH}"

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

CMD ["/sbin/init"]
