FROM ibm-semeru-runtimes:open-8u382-b05-jdk-jammy
COPY /utils /utils
RUN chmod -R 777 /utils && /utils/compile.sh
ENTRYPOINT [ "bash" ]
