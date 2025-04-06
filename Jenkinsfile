pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "victorzapiain/password-checker"
        DOCKER_TAG = "latest"
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm: [
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/victorzapiain/PasswordCheckerJUnit.git',
                        credentialsId: 'GithubToken'
                    ]]
                ]
            }
        }
        stage('Build') {
            steps {
                script {
                    // Build using Java 17
                    docker.image('openjdk:17-jdk').inside {
                        sh 'apt-get update && apt-get install -y maven'
                        sh 'mvn clean package'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Test using Java 11
                    docker.image('openjdk:11-jdk').inside {
                        sh 'apt-get update && apt-get install -y maven'
                        sh 'mvn test'
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    // Analyze with Java 8
                    docker.image('openjdk:8-jdk').inside {
                        sh 'apt-get update && apt-get install -y maven'
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
    }
}



