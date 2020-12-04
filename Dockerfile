FROM busybox:latest as getHadoop
MAINTAINER libo<libo@jiachengnet.com>

# 设置Hadoop版本
ARG HADOOP_VERSION=3.1.4

# 下载hadoop发行包
RUN wget -P /tmp https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    mkdir /opt/hadoop && \
    tar -zxf /tmp/hadoop-$HADOOP_VERSION.tar.gz -C /opt/hadoop --strip-components 1 && \
    rm /tmp/hadoop-$HADOOP_VERSION.tar.gz

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_VERSION=$HADOOP_VERSION


# 第二阶段构建
FROM flink:1.11.2-scala_2.11-java8
COPY --from=getHadoop /opt/hadoop /opt/hadoop

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CLASSPATH=$HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/yarn:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*

RUN rm -rf $HADOOP_HOME/bin/ $HADOOP_HOME/etc/ $HADOOP_HOME/include/ $HADOOP_HOME/lib/ $HADOOP_HOME/libexec/ $HADOOP_HOME/sbin/ $HADOOP_HOME/share/hadoop/hdfs/lib/netty-all-4.0.52.Final.jar $HADOOP_HOME/share/hadoop/hdfs/lib/netty-3.10.5.Final.jar

# 日志记录发送到kafka所需要jar包
#COPY lib/*.jar /opt/flink/lib/
#RUN rm /opt/flink/lib/log4j-1.2-api*.jar

#ADD hadoop-3.1.3.tar.gz /opt/flink/hadoop
