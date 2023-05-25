#!/bin/bash

# set the script to executable
# chmod +x cleanup.sh
#To clean up the setup, simply run the script:  ./cleanup.sh
# Delete the sample application
kubectl delete -f app-deployment.yaml

# Stop the Minikube cluster
minikube stop

# Delete the Minikube cluster
minikube delete
