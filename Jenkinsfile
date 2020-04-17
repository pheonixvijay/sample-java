#!groovy

def deployApplications = ['svc-1', 'svc-2'].join('\n')
def deployEnvironments = ['dev', 'qa', 'prod'].join('\n')
def swapEnvironments=['yes','no'].join('\n')

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
                description: 'Choose the environment to deploy.')
        choice(name: 'SWAP',
                choices: swapEnvironments,
                description: 'Choose to swap Prod Envs.')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-west-1'
    }

    stages{
        stage('Build'){
            WHEN(params.SWAP=='no'){
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
        }
        stage('deploy'){
             WHEN(params.SWAP=='no'){
                steps{
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'chmod +x script/AWS-Script'
                        sh 'script/AWS-Script'
                    }
                }
             }
        }
        stage('swap prod'){
             WHEN(params.SWAP=='yes' && params.ENV=='prod'){
                steps{
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        //Swap CNAMES
                        echo 'starting environment swap'
                        sh 'chmod +x script/AWS-SWAPScript'
                        sh 'script/AWS-SWAPScript'
                    }
                }
             }
        }
    }
}