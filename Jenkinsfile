pipeline {
    agent any

    tools {
        nodejs 'node18'
    }

    environment {
        IMAGE = 'mishaq11/node-fullstack-app'
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('NPM Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('NPM Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --severity HIGH,CRITICAL --exit-code 0 . | tee trivyfs.txt'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=node-fullstack-app \
                        -Dsonar.sources=. \
                        -Dsonar.exclusions=node_modules/**,tests/**
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE:$BUILD_NUMBER .'
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --severity HIGH,CRITICAL --exit-code 0 $IMAGE:$BUILD_NUMBER | tee trivyimage.txt'
            }
        }

        stage('Docker Push') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub') {
                    sh 'docker push $IMAGE:$BUILD_NUMBER'
                }
            }
        }

        stage('Update Deployment File') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh '''
                        git config user.email "jenkins@local"
                        git config user.name "jenkins"
                        sed -i "s|image: .*node-fullstack-app:.*|image: $IMAGE:$BUILD_NUMBER|" k8s/deployment.yaml
                        git add k8s/deployment.yaml
                        git commit -m "update image to $BUILD_NUMBER" || echo "nothing to commit"
                        git push https://$GIT_USER:$GIT_TOKEN@github.com/Ishaq08/Node-DevsecOps.git HEAD:main
                    '''
                }
            }
        }
    }
}
