FROM ubuntu:latest
ENV TZ=Asia/Shanghai
WORKDIR /
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
          && apt-get update \
          && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
          && apt-get install -y tzdata unzip wget npm curl \
          && apt-get clean \
          && apt-get autoclean \
          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
RUN mkdir /minecraft \
&& mkdir /minecraft/dashboard \
&& mkdir /minecraft/server \
&& wget http://192.168.0.201/v8.6.23.zip \
&& unzip v8.6.23.zip -d /minecraft/dashboard && mv /minecraft/dashboard/MCSManager-8.6.23/* /minecraft/dashboard && rm -rf /minecraft/dashboard/MCSManager-8.6.23 && apt purge  -y unzip wget && apt autoremove -y && rm /v8.6.23.zip &&cd /minecraft/dashboard && npm install
EXPOSE 19132 23333
ENTRYPOINT cd /minecraft/dashboard/ && npm start
