## Minikube and kubectl  install

install Minikube and kubectl on CentOS 7, you can follow these steps:

1. Install Docker:
   Update your system's package manager:
   ```
   sudo yum update
   ```

2. Install the required packages for Docker:
   ```
   sudo yum install -y yum-utils device-mapper-persistent-data  lvm2
   ```
3. Add the Docker repository:
   ```
   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   ```
4. Install Docker:
   ```
   sudo yum install -y docker-ce docker-ce-cli containerd.io
   ```

5. Start and enable the Docker service:
   ```
   sudo systemctl start docker 
   sudo systemctl enable docker
   ```

6. Install kubectl:
   ```
   sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   ```
7. Make the kubectl binary executable:
   ```
   sudo chmod +x kubectl
   ```
8. Move the kubectl binary to a directory included in your system's PATH.
   ``
   sudo mv kubectl /usr/local/bin/
   ```
9. Install Minikube:
   ```
   sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
   sudo rpm -ivh minikube-latest.x86_64.rpm
   ```
10. Start Minikube with Docker as the container runtime:
    ```
    minikube start --driver=docker
    ```
11. Verify the status of the Minikube cluster:
    ```
    minikube status  
    kubectl version --client
    ```
##  Runnin the Application

A simple "Hello World" web application develop in Python, this app uses the Flask micro-framework. 
and is containerize using Docker, and then deploy to Kubernetes with a load balance within Minikube.

Here are the steps on how to setup the application:

1. Create a new directory for the project and navigate to it:
   ```
   mkdir web-app
   cd web-app
   ```
2. Create a new Python file called python_web_app.py and add the following lines of code: 
   This code creates a Flask application with a single route that returns the string "Hello, World!".
   ```
   from flask import Flask
   import socket
   app = Flask(__name__)

   @app.route("/")
   def request_handler():
     hostName = socket.gethostname()
     return "Hello, World!" + "HostName: "+ hostNam

   if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0',port=5000)
  ```	
	
3. Create a file called requirements.txt and add the following line below:
   This file specifies the dependencies required by the application
   ```
   Flask==2.0.0
   ```
4. Create a new Dockerfile and add the following code:
   ```
   FROM python:3
   WORKDIR /app
   COPY requirements.txt python_web_app.py .
   RUN pip install --no-cache-dir -r requirements.txt
   EXPOSE 5000
   CMD ["python", "python_web_app.py"]
   ```
   This Dockerfile starts with a Python 3.8 image and sets the working directory to /app. It then copies the requirements.txt file into the container and installs the dependencies. Finally, 
   it copies the rest of the application code into the container, exposes port 5000, and starts the Flask application.

5. Build the Docker image:
   ```
   eval $(minikube docker-env)                     # configure Docker client to use the Minikube Docker daemon
   docker build -t my-web-app:latest .
   minikube image ls                               # to ensure image is accessable from Minikube
   ```
   This command builds the Docker image and tags it as my-web-app:latest and must be run in the same directory as the Dockerfile.

6 Run the Docker container:
  ```
  docker run -p 5000:5000 my-web-app:latest
  ```
  This command starts the Docker container and forwards port 5000 from the container to port 5000 on the host machine.
  
7. Open a web browser and navigate to http://localhost:5000 or curl http://localhost:5000.
   You should see the message "Hello, World! <Hostname>" displayed in the  browser or from the shell using curl command.

8. Stop the Docker container by pressing Ctrl+C.

9.  Ensure Minikube is running, see section above on how to start Minikube

10. Create a new Kubernetes deployment by running the following command: 
    ```
    kubectl apply -f app-deployment.yaml
	```
    This will create a deployment call python-web-app as well as a service called pyhton-web-app-service with three replicas using the Docker image built earlier.
	
11. Expose the deployment as a Kubernetes service on different terminal to ranther the loadbalance service accessible.
    ```
    sudo minikube tunnel 
	```
	
    This will expose the service via a  Kubernetes load-balanced service on port 80 
   
12. Access the web URL for the service by running the following command:
    ```
    kubectl get service # the LoadBalancer IP address should be listed as external IP.
	```
    This command retrieves the IPs for the Kubernetes service LoadBalancer IP.
	
13. Use the curl shell command and navigate to the IP from the previous step. You should see the message "Hello, World! <hoetname>" with 
    respective   containers    hostnames displayed if the command is run multipl times.
   ```
   curl http://<load-balanced service external IP address>
   ```


	

