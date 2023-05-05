1-	I selected this Project  ;  https://github.com/spring-projects/spring-petclinic

2-	I prepared my Dockerfile for this  project on Intellij into src/java.
![image](https://user-images.githubusercontent.com/79639310/236385024-df60c6f8-1952-4d19-8bd6-46645d4339d2.png)

	 
	
I send it to path.	 
![image](https://user-images.githubusercontent.com/79639310/236385237-15af8d93-bb63-499e-8320-b0a742f706d0.png)

There were no jar file i build jar by this command;
```./mvnw package ```
And thoso two jar file are created.
 ![image](https://user-images.githubusercontent.com/79639310/236385267-edd90c3c-4812-43e0-9de5-9286725c1100.png)

I set up docker desktop.
![image](https://user-images.githubusercontent.com/79639310/236385313-df6dec40-a543-4096-8c90-c6a61e580947.png)


Pod is running .Now it is dockerized.
![image](https://user-images.githubusercontent.com/79639310/236385355-13abe3a9-6164-4914-9a71-7512537768dd.png)
 

3-I downloaded latest version of minikube with this command .
```
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
```
I added minikube.exe to run program .

```$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube'){ `
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine) `
}
```
I started my cluster .
![image](https://user-images.githubusercontent.com/79639310/236385396-f90a2e50-d9bc-4476-bb37-f37b6ab2a08f.png)

 


I accesed my cluster. 

 ![image](https://user-images.githubusercontent.com/79639310/236385426-379a8e53-df10-4700-bb6a-23675bde8c82.png)


4-I created deployment.yaml .
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
            - containerPort: 3000
```
I applied this yaml to my minikube.
![image](https://user-images.githubusercontent.com/79639310/236385992-f2b3911a-3dd3-4fa5-aea3-a56eeb9e72f4.png)
![image](https://user-images.githubusercontent.com/79639310/236386012-fb2670e9-51b4-4b5c-b99f-494942d445fc.png)

 
 


I showed pods
![image](https://user-images.githubusercontent.com/79639310/236386029-4ca015e9-f571-4e46-b921-d5e6f274374c.png)


 
Next , i created service.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: spring-project-minikube-service
spec:
  ports:
    - protocol: "TCP"
      port: 3000        # The port inside the cluster
      targetPort: 3000  # The port exposed by the service
  type: NodePort        # Type of service
  selector:
    app: springboot-kubernetes
```
I applied yaml  and listed my services.
 ![image](https://user-images.githubusercontent.com/79639310/236385927-08092d7b-a30b-4d7f-b4df-0a1a613c079c.png)
![image](https://user-images.githubusercontent.com/79639310/236385938-f4a7165a-a86d-472c-8f99-f88f9ec6cc9c.png)


 








I imagined that i installed mysql on my local.And  this is my database.yaml.
```
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
apiVersion: apps/v1 
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
```
 
I applied database.yaml.
Now, it is connected to database.
![image](https://user-images.githubusercontent.com/79639310/236385889-c4a7f39d-176d-4f0f-bc64-ad0a93dc249c.png)













5-I installed Jenkins my local in 8080 port.

![image](https://user-images.githubusercontent.com/79639310/236385647-ab0194a2-1384-447d-a4b1-af734b1f1bf2.png)




 
I logged in my admin user . I set my configs that is about maven
I created new job which name is spring-project2.
 
![image](https://user-images.githubusercontent.com/79639310/236385681-5f565a4c-76ca-4c44-aba0-5109b53ed458.png)
 ![image](https://user-images.githubusercontent.com/79639310/236385703-632a11e6-a7e1-4a28-b221-5b108efe6cca.png)

Adding maven to configuration
![image](https://user-images.githubusercontent.com/79639310/236385729-02f1b46b-afa8-4022-8c98-ee4d060cb856.png)

I configured my pipeline , adding github link to my job.
![image](https://user-images.githubusercontent.com/79639310/236385772-f1e46867-4951-40ca-9e85-690d145a1420.png)

 
This my pipeline .


```
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
```

