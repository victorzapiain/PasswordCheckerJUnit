# Use official Java 17 image
FROM eclipse-temurin:17-jdk

# Set the working directory inside the container
WORKDIR /app

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

# Copy everything from your repo into the container
COPY . .

# Build the Maven project
RUN mvn clean package

# Run the JAR file (adjust filename if it's different)
CMD ["java", "-jar", "target/password-checker-0.0.1-SNAPSHOT.jar"]
