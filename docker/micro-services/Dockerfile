FROM eclipse-temurin:17-jdk-alpine
ARG JAR_FILE=*.jar
COPY micro-service-0.0.1-SNAPSHOT.war .
EXPOSE 8089
ENTRYPOINT ["java","-jar","/micro-service-0.0.1-SNAPSHOT.war"]
