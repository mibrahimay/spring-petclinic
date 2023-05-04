1-	I selected this Project  ;  https://github.com/spring-projects/spring-petclinic
2-	I prepared my Dockerfile for this  project on Intellij into src/java.
3-	 
4-	
5-	I send it to path.
6-	 

There were no jar file i build jar by this command;
```./mvnw package ```
And thoso two jar file are created.
 
I set up docker desktop.
 









```











Pod is running .Now it is dockerized.
 

7-	I downloaded latest version of minikube with this command .

New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing

I added minikube.exe to run program .

```$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube'){ `
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine) `
}
```
I started my cluster .

 


I accesed my cluster. 

 



I created deployment.yaml .
```apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-petclinic
spec:
  selector:
    matchLabels:
      app: spring-petclinic
  replicas: 3
  template:
    metadata:
      labels:
        app: spring-petclinic
    spec:
      containers:
        - name: spring-petclinic
          image: :spring-petclinic.1.0
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8080
```
I applied this yaml to my minikube.

 
 


I showed pods

 
Next , i created service.yaml
apiVersion: v1
kind: Service
metadata:
  name: spring-project-minikube-service
spec:
  ports:
    - protocol: "TCP"
      port: 8080        # The port inside the cluster
      targetPort: 8080  # The port exposed by the service
  type: NodePort        # Type of service
  selector:
    app: springboot-kubernetes

I applied yaml  and listed my services.
 

 








I imagined that i installed mysql on my local.And  this is my database.yaml.
apiVersion: v1
kind: Service
metadata:
name: mysql
spec:
ports:
- port: 3306
selector:
app: mysql
clusterIP: None
---
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
name: mysql
spec:
selector:
matchLabels:
app: mysql
strategy:
type: Recreate
template:
metadata:
labels:
app: mysql
spec:
containers:
- image: mysql:5.6
name: mysql
env:
# Use secret in prod use cases
- name: MYSQL_ROOT_PASSWORD
value: password
ports:
- containerPort: 3306
name: mysql
volumeMounts:
- name: mysql-persistent-storage
mountPath: /var/lib/mysql
volumes:
- name: mysql-persistent-storage
persistentVolumeClaim:
claimName: mysql-pv-data

 
I applied database.yaml.














I installed Jenkins my local in 8080 port.





 
I logged in my admin user . I set my configs that is about maven
I created new job which name is spring-project2.
 
 
Adding maven to configuration
 
I configured my pipeline , adding github link to my job.

 
This my pipeline .



pipeline {
    agent any
    tools { 
        maven 'Maven 3.9.1' 
        jdk 'jdk17' 
    }
    stages {
        stage ('deploy-prod-minikube') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                ''' 
            }
        }

        stage ('Build') {
            steps {
                echo 'This Project built to minikube.'
            }
        }
    }
}


