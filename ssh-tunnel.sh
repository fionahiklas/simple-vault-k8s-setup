#!/usr/bin/env bash
#
# Create a tunnel to the Minikube Loadbalancer running in
# Docker Desktop on MacOS
#

minikube_ssh_port=$(docker ps --filter "name=minikube" --format "{{.Ports}}" | sed -e 's/^.*:\([0-9]*\)->22\/tcp.*/\1/')
http_port=10080
https_port=10443

echo "Connecting to SSH on port ${minikube_ssh_port}"
echo "HTTP  port: ${http_port}"
echo "HTTPS port: ${https_port}" 

# This is essentially copied from the SSH command from minikube
# but used specific ports.
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $HOME/.minikube/machines/minikube/id_rsa  -L ${http_port}:localhost:80 -L ${https_port}:localhost:443 -p ${minikube_ssh_port} docker@localhost 

