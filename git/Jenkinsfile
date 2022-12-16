node{
    stage('code checkout'){
        echo 'checking out the code'
        git credentialsId: 'github', url: 'https://github.com/devopsmvc/insurance.git'
    }

    stage('Compile'){
        echo 'Compling Code'
        sh 'mvn compile'
    }

    stage('Testing the Code'){
        echo 'Testing the Code'
        sh 'mvn test'
    }

    stage('workspace stage'){
        echo 'cleaning the workspace'
        sh 'mvn clean'
    }

    stage('complie, test, package'){
        echo 'Compiling, testing and packaging source code'
        sh 'mvn package'
    }

    stage('deploy'){
        echo 'deploy the Insurance App to tomcat9'
        deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://172.31.1.190:8081/')], contextPath: 'Insurance', war: '**/*.war'
    }

}
