# test-crow
``` bash
.
├── apps
│   ├── client
│   │   ├── BUILD
│   │   └── src
│   │       └── client.cpp
│   ├── server
│   │   ├── BUILD
│   │   └── src
│   │       └── server.cpp
│   └── test
│       ├── BUILD
│       └── src
│           └── TestServer.cpp
├── docker
│   └── Dockerfile.base
├── LICENSE
├── README.md
├── third_party
│   ├── boost.bzl
│   ├── BUILD
│   ├── BUILD.boost
│   ├── Config
│   │   ├── BUILD
│   │   ├── include
│   │   │   └── Config.h
│   │   └── src
│   │       └── Config.cpp
│   ├── crow
│   │   ├── BUILD
│   │   └── crow_all.h
│   ├── deps.bzl
│   ├── getTimeOfDay
│   │   ├── BUILD
│   │   ├── include
│   │   │   └── TimeStamp.h
│   │   └── src
│   │       └── TimeStamp.cpp
│   └── gtest.BUILD
└── WORKSPACE

```
# setup
you need to install curl to build the client app
``` bash
sudo yum install libcurl-devel
``` 

# build
``` bash
git clone https://github.com/kubeCorn/test-crow.git
cd test-crow
bazel build //apps/app1:app1_bin
bazel build //apps/app2:app2_bin

```
# create image
``` bash
bazel run //apps/app1:app1_image
bazel run //apps/app2:app2_image

```
# push image
``` bash
if not already done: cat ~/GH_TOKEN.txt | docker login ghcr.io -u YOUR_USER --password-stdin


bazel run //apps/app1:app1_push --embed_label="your_new_image_version"
bazel run //apps/app2:app2_push  --embed_label="your_new_image_version"

```
## [optional] if you want to test from ssh tunnel make sure ssh is active on the host
``` bash
in VBox : Conf/network/NAT -> advanced port fowarding : ssh | TCP | 127.0.0.1  |  2522 | <IP_VM> | 22
systemctl ssh status // active(running) if not installed ( try sudo yum –y install openssh-server openssh-clients ) 
also verify response from ping 8.8.8.8 -> ok you are connected to the wwweb
```


# Test with image
``` bash 
for now the port is hard coded in the image

docker run -d -p 9080:9080 crow/apps/app2:app2_image
docker run -d -p 9081:9081 crow/apps/app1:app1_image

```
# Unit Test 
``` bash
bazel build //apps/test:test
bazel-bin/apps/test/test
```
``` console
response  :==========] Running 4 tests from 1 test case.
[----------] Global test environment set-up.
[----------] 4 tests from TestServer
[ RUN      ] TestServer.when_set_Port_Message_Should_Works
    
    // ... // 

[       OK ] TestServer.when_Unset_all_Should_Default (0 ms)
[----------] 4 tests from TestServer (0 ms total)

[----------] Global test environment tear-down
[==========] 4 tests from 1 test case ran. (0 ms total)
[  PASSED  ] 4 tests.

```
# Docker-compose

Setup Docker-Compose : https://docs.docker.com/compose/install/

``` bash
cd ./docker_compose/
docker-compose --env-file ../var.bzl up

docker ps # Get Containers ID
docker exec -it CONTAINER_ID bash # Open bash in container
```

```
# k8s

check the README_K8s to start the cluster
sh recreate-cluster.sh
kubectl apply -f deployments/app2-deployment.yml
kubectl apply -f deployments/app2-service.yml
kubectl apply -f deployments/app1-deployment.yml
kubectl apply -f deployments/app1-service.yml
kubectl apply -f deployments/ingress-server.yml

test:
curl http://localhost:80/app1
curl http://localhost:80/app2


to see file testing volume:
kubectl exec -it {app1-pod-name} /bin/bash
cat /data/history/client_history.txt

```
# postgres

create and push postgres image with init data:

cd postgresImage
docker build . -t ghcr.io/kubecorn/test_vault/postgres:v1
docker push ghcr.io/kubecorn/test_vault/postgres:v1
 
access postgres db in docker iamge:

start container: docker run -p 5432:5432 ghcr.io/kubecorn/test_vault/postgres:v1
access db: psql -h localhost -U postgresadmin --password -p 5432 postgresdb
password is admin123

add postgres in k8s:
once cluster is started:

kubectl apply -f deployments/postgres-configPwd.yml
kubectl apply -f deployments/postgres-storage.yml
kubectl apply -f deployments/postgres-deployment.yml
kubectl apply -f deployments/postgres-service.yml

access db in cluster:
kubectl run -it --rm --image=postgres:10.14 --restart=Never postgres-client --env="PGPASSWORD=admin123" -- psql -h postgres -U postgresadmin -d postgresdb -p 5432

