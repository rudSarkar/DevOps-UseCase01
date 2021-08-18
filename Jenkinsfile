node {
    def app

    stage ('Clone repository') {
        // scm is a special variable which instructs the checkout step to clone the specific revision which triggered this Pipeline run.
        checkout scm
    }

    // Initialize the docker app
    stage('Initialize'){
        def dockerHome = tool 'DownloadDocker'
        env.PATH = "${dockerHome}/bin:${env.PATH}"
    }

    stage('Build image') {
        app = docker.build('rudr4sarkar/nodeapp')
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        withCredentials([usernamePassword( credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            docker.withRegistry('', 'docker-hub-cred') {
                sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
            }
        }
    }
}