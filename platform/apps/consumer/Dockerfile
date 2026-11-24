# Stage 1: build the jar with the Maven wrapper
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN ./mvnw -q dependency:go-offline   # dependencies cached in their own layer
COPY src src
RUN ./mvnw -q package -DskipTests

# Stage 2: small runtime image with just the JRE and the jar
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]

# It's a multi-stage build: the full JDK compiles the code, but the final image keeps only the JRE and the jar, so it's much smaller.
