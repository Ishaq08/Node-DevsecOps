pipeline {
  agent any
  tools { nodejs 'node18' }

  environment {
    IMAGE       = 'mishaq11/node-fullstack-app'
    SCANNER_HOME = tool 'sonar-scanner'
  }

  stages {
    stage('NPM Install') {
      steps { sh 'npm install' }
    }
    stage('NPM Test') {
      steps { sh 'npm test' }
    }
    stage('Trivy FS Scan') {
      steps { sh 'trivy fs --severity HIGH,CRITICAL --exit-code 0 . | tee trivyfs.txt' }
    }
    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('sonar') {
          sh '''$SCANNER_HOME/bin/sonar-scanner \
            -Dsonar.projectKey=node-fullstack-app \
            -Dsonar.sources=. \
            -Dsonar.exclusions=node_modules/**,tests/**'''
        }
      }
    }
    stage('Docker Build') {
      steps { sh 'docker build -t $IMAGE:$BUILD_NUMBER .' }
    }
    stage('Trivy Image Scan') {
      steps { sh 'trivy image --severity HIGH,CRITICAL --exit-code 0 $IMAGE:$BUILD_NUMBER | tee trivyimage.txt' }
    }
    stage('Docker Push') {
      steps {
        withDockerRegistry(credentialsId: 'dockerhub', url: '') {
          sh 'docker push $IMAGE:$BUILD_NUMBER'
        }
      }
    }
  }
}