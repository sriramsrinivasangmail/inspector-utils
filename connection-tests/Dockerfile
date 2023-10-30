FROM registry.access.redhat.com/ubi8/go-toolset:latest
USER 0
RUN yum install -y gcc glibc-devel openssl-devel 
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=ibm-semeru-runtimes:open-11-jdk $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:/opt/maven/bin:${PATH}"
COPY /utils /utils
RUN chmod -R 777 /utils && /utils/compile.sh && chmod -R 777 /opt/app-root
USER 1001
ENTRYPOINT [ "bash" ]
