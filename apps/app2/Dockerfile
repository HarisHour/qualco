FROM azul/zulu-openjdk:11-jre-headless-latest
WORKDIR /opt/app
COPY ./target/springbootrestapi-1.0.0.jar /opt/app/
ENV PORT 8081
EXPOSE $PORT
CMD ["java","-jar","/opt/app/springbootrestapi-1.0.0.jar"]