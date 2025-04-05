pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "victorzapiain/password-checker"
        DOCKER_TAG = "latest"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/victorzapiain/PasswordCheckerJUnit.git'  // Replace with your GitHub repo URL
            }
        }
        stage('Build') {
            steps {
                script {
                    // Build using Java 17
                    docker.image('openjdk:17-jdk').inside {
                        sh './mvnw clean package'  // Replace with your Maven build command
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Test using Java 11
                    docker.image('openjdk:11-jdk').inside {
                        sh './mvnw test'  // Replace with your Maven test command
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    // Analyze with Java 8
                    docker.image('openjdk:8-jdk').inside {
                        sh './mvnw sonar:sonar'  // Replace with your Maven SonarQube analysis command
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image for your Java app
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub and push the image
                    docker.withRegistry('', 'dockerhub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
    }
}
