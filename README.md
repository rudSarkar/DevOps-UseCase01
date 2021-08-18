# DevOps Use-Case 01

This repo will help me to create a Dockerfile and Jenkinsfile and Understanding the use-case of DevOps basic things

- Create a simple node.js application with express

- Push the application to github

- The application will go through Jenkins build

- Clone the git repository

- Build a docker image

- Push the image in docker hub

# Error I faced while building the image

I faced an error in jenkins build which is:

```
Jenkins : Cannot run program “docker”: error=2, No such file or directory
```

So I found a soultion in StackOverflow:

- Link: https://stackoverflow.com/a/50933411/6927300

I hit the same problem as above. I am not sure that my case is exactly the same as your but the TL;DR is that you need make sure that Docker is available to the PATH variable Jenkins is using. Specifically the one it starts up with, which can be seen under **Jenkins Home -> Manage Jenkins -> System Information**.

In my case, I am on a Mac and installed Jenkins through Homebrew. To fix the issue I edited the `/usr/local/opt/jenkins-lts/homebrew.mxcl.jenkins-lts.plist` file and changed it to the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>homebrew.mxcl.jenkins-lts</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/libexec/java_home</string>
      <string>-v</string>
      <string>1.8</string>
      <string>--exec</string>
      <string>java</string>
      <string>-Dmail.smtp.starttls.enable=true</string>
      <string>-jar</string>
      <string>/usr/local/opt/jenkins-lts/libexec/jenkins.war</string>
      <string>--httpListenAddress=127.0.0.1</string>
      <string>--httpPort=8080</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
```

In this case my case docker installed in Mac the PATH is:

```console
/usr/local/bin/docker
```

Another issue I faced while push build image to docker hub:

I wasn't able to login to docker hub with `withRegistry` which occurs docker login failed. I found a solution which helped me to login to docker hub:

- Link: https://issues.jenkins.io/browse/JENKINS-41051

```jenkinsfile
stage('Push image') {
    withCredentials([usernamePassword( credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        docker.withRegistry('', 'docker-hub-cred') {
            sh "docker login -u ${USERNAME} -p ${PASSWORD}"
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
```
