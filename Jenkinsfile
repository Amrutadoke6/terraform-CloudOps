pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
  }

  stages {
    stage('Init') {
      steps { sh 'terraform init' }
    }

    stage('Validate') {
      steps {
        sh 'terraform validate'
        sh 'terraform fmt -check'
      }
    }

    stage('Plan') {
      steps { sh 'terraform plan -out=tfplan' }
    }

    stage('Apply') {
      steps {
        input 'Apply infrastructure?'
        sh 'terraform apply tfplan'
      }
    }
  }
}

