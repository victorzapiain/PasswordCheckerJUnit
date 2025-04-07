FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY . .
RUN mvn clean package
CMD ["java", "-jar", "target/password-checker-0.0.1-SNAPSHOT.jar"]
