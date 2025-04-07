
FROM eclipse-temurin:17-jdk
WORKDIR /app
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*
COPY . .
RUN mvn clean package
CMD ["java", "-jar", "target/password-checker-0.0.1-SNAPSHOT.jar"]
