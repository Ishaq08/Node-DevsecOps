pipeline {
  agent any
  tools { nodejs 'node18' }

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
  }
}