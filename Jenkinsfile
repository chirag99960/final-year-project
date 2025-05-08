pipeline {
    agent any

    stages {
        stage('Code') {
            steps {
                echo "Cloning the code"
                git url: "https://github.com/chirag99960/final-year-project.git", branch: "main"
            }
        }

        stage('Build') {
            steps {
                echo "Building the image using Docker"
                sh "docker build -t notesapp ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing the image to Docker Hub"
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerHub',
                        usernameVariable: 'DOCKER_HUB_USER',
                        passwordVariable: 'DOCKER_HUB_PASS'
                    )]) {
                        sh "echo \$DOCKER_HUB_PASS | docker login -u \$DOCKER_HUB_USER --password-stdin"
                        sh "docker tag notesapp \$DOCKER_HUB_USER/notesapp:latest"
                        sh "docker push \$DOCKER_HUB_USER/notesapp:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying the application using docker-compose"
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerHub',
                        usernameVariable: 'DOCKER_HUB_USER',
                        passwordVariable: 'DOCKER_HUB_PASS'
                    )]) {
                        // Replace image in docker-compose.yml with the pushed one
                        sh """
                            sed -i 's|build: .|image: \$DOCKER_HUB_USER/notesapp:latest|' docker-compose.yml
                        """

                        // Shut down existing containers, if any
                        sh "docker-compose down || true"

                        // Start up using updated docker-compose config
                        sh "docker-compose pull && docker-compose up -d"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
