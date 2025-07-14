pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'us-east-1'
    TF_IN_AUTOMATION = 'true'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Amrutadoke6/terraform-CloudOps.git', branch: 'main'
      }
    }

    stage('Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Plan') {
      steps {
        sh 'terraform plan -out=tfplan'
      }
    }

    stage('Apply') {
      steps {
        input message: 'Approve apply?'
        sh 'terraform apply tfplan'
      }
    }
  }
}

