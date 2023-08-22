# Stage 1: build the application
FROM maven:3.6.3-adoptopenjdk-8-openj9 AS build

WORKDIR /app
COPY . .

RUN mvn install

# Stage 2: run the application
FROM openjdk:8-jre-alpine

WORKDIR /app

# ENV DB_DIALECT HSQLDB
# ENV DB_URL jdbc:hsqldb:file:lavagna
# ENV DB_USER user
# ENV DB_PASS user
# ENV SPRING_PROFILE dev

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl


# Copy the entry-point script
COPY entry-point.sh .
RUN chmod +x ./entry-point.sh

# Copy the built JAR file from the build stage
COPY --from=build /app/target /app/target

ENTRYPOINT ["sh","./entry-point.sh"]