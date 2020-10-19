#!/bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Colors
Green='\033[0;32m'
BGreen='\033[1;32m'       # Green

echo -e "${BGreen}Installing kind...${Color_Off}"

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
chmod +x ./kind

sudo mv ./kind /usr/local/bin/

kind --version

echo -e "${BGreen}Successfully kind!${Color_Off}"

echo -e "${BGreen}Installing kubectl...${Color_Off}"

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/

kubectl version --client

echo -e "${BGreen}Successfully kubectl!${Color_Off}"

echo -e "${BGreen}Creating cluster with 3 workers and 3 masters...${Color_Off}"

kind create cluster --config ./kind-cluster-3master-3workers.yml

echo -e "${BGreen}Cluster health:${Color_Off}"
kubectl cluster-info --context kind-kind

echo -e "${BGreen}Created nodes:${Color_Off}"
kubectl get nodes

echo -e "${BGreen}Installing ingress-nginx...${Color_Off}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
echo -e "${BGreen}Successfully ingress-nginx!${Color_Off}"

echo -e "${BGreen}Waiting  ingress-nginx!${Color_Off}"
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s