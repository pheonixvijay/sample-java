#!groovy
def deployApplications = ['svc-1', 'svc-2'].join('\n')
def deployEnvironments = ['dev', 'qa'].join('\n')

pipeline {
    agent { dockerfile true}

    parameters{
        choice(name: 'APP',
                choices: deployApplications,
                description: 'Choose the application to deploy')

        string(name: 'App_Version', 
                description: 'The tag of the application to deploy',
                defaultValue: '')

        choice(name: 'ENV',
                choices: deployEnvironments,
                description: 'Choose the application to deploy.')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-west-1'
    }

    stages{
        stage('Build'){
            steps{
                script {
                        def label = "#${currentBuild.number} ${params.APP} " +
                                    "${params.ENV}"
                        currentBuild.displayName = label
                }
                script{
                    sh 'gradle build'
                }
            }
        }
        stage('deploy'){
            steps{
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'chmod +x script/AWS-Script.sh'
                    sh 'script/AWS-Script'
                }
            }
        }
    }
}