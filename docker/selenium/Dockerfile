FROM eclipse-temurin:17-jdk-alpine
ARG JAR_FILE=*.jar
COPY selenium-runnable-headless-ubu2.jar .
COPY chromedriver /home/ubuntu
EXPOSE 8090
ENTRYPOINT ["java","-jar","selenium-runnable-headless-ubu2.jar"]
