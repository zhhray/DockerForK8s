FROM danisla/hadoop:2.7.3

COPY hadoop-config /etc/hadoop-config
COPY jdk1.8.0_161 /usr/lib/jvm/jdk1.8.0_161

ENV JAVA_HOME /usr/lib/jvm/jdk1.8.0_161
ENV PATH $PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin
ENV CLASSPATH $CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib

RUN (apt-get update -y; \
     apt-get install -y openssh-server vim; \
	 ssh-keygen -t rsa -f /root/.ssh/id_rsa; \
     cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys; \
     echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config; \
     apt-get remove openjdk* -y; \
     update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_161/bin/java 300; \
     update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_161/bin/javac 300; \
     update-alternatives --config java; )	 
	
EXPOSE 22 2122 8019 8020 8030:8033 8040:8042 8088 8480 8485 9000 9001 19888 49707 50010 50020 50070 50075 50090    
