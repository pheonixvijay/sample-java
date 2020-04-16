FROM debian:latest

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install sudo -y && \
    apt-get install wget -y && \
    apt-get install unzip -y && \
    apt-get install curl -y && \
    apt-get install gnupg -y && \
    apt-get install software-properties-common -y && \
    apt-get clean;

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
RUN sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN apt update -y
RUN apt install adoptopenjdk-8-hotspot -y

RUN java -version

ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64/
RUN export JAVA_HOME
RUN echo $JAVA_HOME

RUN sudo apt-get install python3-pip -y

RUN wget https://services.gradle.org/distributions/gradle-6.3-bin.zip -P /tmp
RUN sudo unzip -d /opt/gradle /tmp/gradle-*.zip

RUN echo 'export GRADLE_HOME=/opt/gradle/gradle-6.3' >> /etc/profile.d/gradle.sh
RUN echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> /etc/profile.d/gradle.sh
RUN sudo chmod +x /etc/profile.d/gradle.sh && /etc/profile.d/gradle.sh
# RUN  /etc/profile.d/gradle.sh
ENV GRADLE_HOME /opt/gradle/gradle-6.3
ENV PATH /opt/gradle/gradle-6.3/bin:${PATH}
RUN export GRADLE_HOME
RUN export PATH
RUN echo $GRADLE_HOME
RUN echo $PATH
RUN gradle -v

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sudo ./aws/install
RUN aws --version