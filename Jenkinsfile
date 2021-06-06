pipeline {
    agent any

    stages {
        
        stage('Version Update'){
            steps{
                script{
                    def PomVersion = readMavenPom()
                    def version = PomVersion.version
                }
                echo '${version}'
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'zip generalartifactapp-3.zip *'
            }
        }
        stage('Push to Jfrog Artifactory') {
            steps {
                    rtUpload (
                        serverId: 'Cloud-Artifactory',
                        spec: '''{
                                "files": [
                                    {
                                        "pattern": "generalartifactapp*.zip",
                                        "target": "example-repo-local/"
                                    }
                                ]
                            }'''
                    )                   
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'sleep 20s'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
