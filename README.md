# minecraft for docker
## 1.安装docker以及docker-compose
```bash
apt install docker docker-compose
```
## 2.编写Dockerfile构建docker image
```Dockerfile
 FROM
 ubuntu:latest                                                                                               TZ=Asia/Shanghai
WORKDIR /
 FROM ubuntu:latest                                               
 ENV TZ=Asia/Shanghai
 WORKDIR /
 RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \ 
&& apt-get update \
&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 
&& echo $TZ > /etc/timezone \
apt-get install -y tzdata unzip wget npm curl \
&& apt-get clean \
&& apt-get autoclean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir /minecraft \
&& mkdir /minecraft/dashboard \
&& mkdir /minecraft/server \
&& wget https://github.com/Suwings/MCSManager/archive/refs/tags/v8.6.23.zip \
#这里的链接复制minecraft管理面板下载链接
&& unzip v8.6.23.zip -d /minecraft/dashboard 
#同样的后面的文件名以及解压的目录名要根据实际情况进行修改
&& mv /minecraft/dashboard/MCSManager-8.6.23/* /minecraft/dashboard 
&& rm -rf /minecraft/dashboard/MCSManager-8.6.23 \
&& apt purge  -y unzip wget \
&& apt autoremove -y \
&& rm /v8.6.23.zip \
&& cd /minecraft/dashboard && npm install
EXPOSE 19132 23333
#对外暴露的端口
ENTRYPOINT cd /minecraft/dashboard/ && npm start
```
## 3.编写docker-compose.yml文件进行启动容器
```yaml
version:"3.9"                                                           services:
     minecraft:
         container_name: minecraft
         hostname: minecraft
         build: .
         image: minecraft:v1.0
         ports:
             - 19132:19132/udp
             - 19132:19132
             #这里指定需要映射的端口
         volumes:
             ./minecraft:/minecraft/dashboard/server
             #这里指定映射路径
         restart: unless-stopped
```