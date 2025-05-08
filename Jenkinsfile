pipeline {
    agent any

    stages {
        stage('Code') {
            steps {
                echo "Cloning the code"
                git url: "https://github.com/chirag99960/final-year-project.git", branch: "main"
            }
        }

        stage('Rebuild Image') {
            steps {
                echo "Force rebuilding Docker image with changes"
                sh "docker build --no-cache -t notesapp ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing updated image to Docker Hub"
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
                echo "Redeploying application"
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerHub',
                        usernameVariable: 'DOCKER_HUB_USER',
                        passwordVariable: 'DOCKER_HUB_PASS'
                    )]) {
                        // Force fresh deployment
                        sh """
                            docker-compose down --volumes --remove-orphans
                            docker-compose pull
                            docker-compose up -d --force-recreate --build
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Changes successfully deployed to production!"
        }
        failure {
            echo "Deployment failed. Check logs for details."
        }
    }
}
