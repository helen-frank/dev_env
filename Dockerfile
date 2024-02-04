FROM kindest/base:v20240202-8f1494ea

WORKDIR /root

ENV CONTAINER_TIMEZONE=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone
RUN apt-get update && apt-get install -y git curl wget vim openssh-server ca-certificates tzdata

# go
# COPY go1.21.6.linux-amd64.tar.gz ./go1.21.6.linux-amd64.tar.gz
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && rm -rf go1.21.6.linux-amd64*
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc
ENV go env -w GOPROXY=https://goproxy.io,direct

# frpc
# COPY frp_0.54.0_linux_amd64.tar.gz ./frp_0.54.0_linux_amd64.tar.gz
RUN wget https://github.com/fatedier/frp/releases/download/v0.54.0/frp_0.54.0_linux_amd64.tar.gz
RUN tar -xzf frp_0.54.0_linux_amd64.tar.gz && cp frp_0.54.0_linux_amd64/frpc /usr/bin/ && rm -rf frp_0.54.0_linux_amd64*
RUN mkdir -p /etc/frp
COPY frpc@.service /etc/systemd/system/frpc@.service

# sshd
COPY sshd_config /etc/ssh/sshd_config
# RUN mkdir /run/sshd
# RUN /usr/sbin/sshd
RUN systemctl enable ssh

RUN echo "root:root" | chpasswd
RUN touch /root/.ssh/authorized_keys

ENTRYPOINT [ "/usr/local/bin/entrypoint", "/sbin/init" ]
