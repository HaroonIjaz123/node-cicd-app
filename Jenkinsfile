pipeline {
  agent any
  triggers { pollSCM('H/2 * * * *') }
  options {
    skipDefaultCheckout(true)
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 10, unit: 'MINUTES')
  }
  parameters {
    booleanParam(name: 'DEPLOY', defaultValue: true,
      description: 'Publish to the local lab preview')
  }
  environment {
    LAB_DEPLOY_ROOT = '/opt/jenkins-lab/node-cicd'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Install') {
      steps { sh 'npm ci' }
    }
    stage('Test') {
      steps { sh 'npm test' }
    }
    stage('Build') {
      steps { sh 'npm run build' }
    }
    stage('Archive') {
      steps {
        archiveArtifacts artifacts: 'dist/**', fingerprint: true
      }
    }
    stage('Deploy') {
      when { expression { params.DEPLOY } }
      steps { sh 'npm run deploy -- declarative' }
    }
  }
  post {
    success { echo 'CI passed. Check the Deploy stage for publication.' }
    failure { echo 'Failed. Inspect Console Output before retrying.' }
    always { echo "Finished build ${env.BUILD_NUMBER}" }
  }
}
