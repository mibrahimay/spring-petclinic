#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM openjdk:17
COPY --from=build C:\Users\muham\Downloads\spring-petclinic\target\spring-petclinic-3.0.0-SNAPSHOT.jar /usr/local/lib/spring.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]