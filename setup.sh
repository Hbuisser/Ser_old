#! /bin/sh

function exit_general() {
	if [[ "$1" != 0 ]]
	then 
		exit
	fi
}

function delete_cluster() {
	minikube delete
}

function check_brew() {
	brew -v
	# $? is the exit status of the last executed command / true returns 0, false 1
	if [ "$?" != 0 ]
	then 
		printf "Brew isn't installed!\n"
		read -p "Do you want to install brew? (Y/N): " REP
		if [[ $REP = "Y" || $REP = "y" || $REP = "" ]]
		then
			printf "Installing brew...\n"
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
		else
			printf "Brew is required for this program\n"
			# exit 1 means exiting with false at the end
			exit 1
		fi
	else
		printf "Brew is installed ✅\n"
	fi
}

function check_docker() {
	docker -v
	if [ "$?" != 0 ]
	then
		printf "Docker isn't installed!\n"
		printf "Check the docker documentation and come back\n"
		exit 1
	else
		printf "Docker is installed ✅\n"
	fi
}

function check_minikube() {
	minikube version
	if [ "$?" != 0 ]
	then
		printf "Minikube isn't installed!\n"
		printf "Check the documentation and come back\n"
		exit 1
	else
		printf "Minikube is installed ✅\n"
	fi
}

function metallb_config() {
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	if [ "$(kubectl get secrets --namespace metallb-system | grep memberlist)" = "" ]
	then
		kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	fi
    kubectl apply -f srcs/metallb-config.yaml
}

function build_images() {
# Connect the Docker client to the Docker server inside of the k8 node (only in the current terminal)
# => in order to see all the containers when you type docker ps

# start the docker environment on the Minikube
	eval $(minikube docker-env)
    sleep 2
 #    echo "========= 1. ftps"
 #    sleep 1
 #    docker build srcs/ftps -t img-ftps > /dev/null
 #    echo "========= 2. Grafana"
 #    sleep 1
 #    permet la visualisation de donnees
 #    docker build srcs/grafana -t img-grafana > /dev/null
 #    echo "========= 3. Influxdb"
 #    sleep 1
 #    docker build srcs/influxdb -t img-influxdb > /dev/null
	# echo "========= 4. MySQL"
	# sleep 1
	# docker build srcs/mysql -t img-mysql > /dev/null
	echo "========= 5. Nginx"
	sleep 1
	docker build srcs/nginx -t img-nginx > /dev/null
	# echo "========= 6. Phpmyadmin"
	# sleep 1
	# docker build srcs/phpmyadmin -t img-phpmyadmin > /dev/null
	# echo "========= 7. Telegraf"
	# sleep 1
	# docker build srcs/telegraf -t img-telegraf > /dev/null
	# echo "========= 8. Wordpress"
	# sleep 1
	# docker build srcs/wordpress -t img-wordpress > /dev/null
}

function deploy_all() {
    sleep 2
    # kubectl apply -f srcs/ftps/deployment.yaml
    # kubectl apply -f srcs/grafana/deployment.yaml
    # kubectl apply -f srcs/influxdb/deployment.yaml
    # kubectl apply -f srcs/mysql/deployment.yaml
    kubectl apply -f srcs/nginx/deployment.yaml
    # kubectl apply -f srcs/phpmyadmin/deployment.yaml
    # kubectl apply -f srcs/telegraf/deployment.yaml
    # kubectl apply -f srcs/wordpress/deployment.yaml
    sleep 1
}

function main() {
    minikube delete
	# echo ""
	# echo "==========================================================="
    # echo "==========================================================="
    # echo "==========================================================="
    # echo "                   FT_SERVICES_HBUISSER                    "
    # echo "==========================================================="
    # echo "==========================================================="
    # echo "==========================================================="
    # echo ""
    # echo ""
    # echo "                          WELCOME !!                       "
    # echo ""
    # echo ""
    # sleep 2
    # echo ""
    # echo "==========================================================="
    # echo "==========================================================="
    # echo "                   DEPENDENCIES CHECK                      "
    # echo "==========================================================="
    # echo "==========================================================="
    # echo ""
	# sleep 1
	# echo "1. BREW"
	# echo "2. DOCKER"
	# echo "3. MINIKUBE"
    # echo ""
    # echo "==========================================================="
    # echo "               1. CHECKING BREW INSTALLATION               "
    # echo "==========================================================="
    # echo ""
    # sleep 1
    # check_brew
    # sleep 1
    # exit_general $?
    # echo ""
    # echo "==========================================================="
    # echo "               2. CHECKING DOCKER INSTALLATION             "
    # echo "==========================================================="
    # echo ""
    # sleep 1
    # check_docker
    # sleep 1
    # exit_general $?
    # echo ""
    # echo "==========================================================="
    # echo "            3. CHECKING MINIKUBE INSTALLATION              "
    # echo "==========================================================="
    # echo ""
    # sleep 1
    # check_minikube
    # sleep 1
    # exit_general $?
    # minikube delete > /dev/null
    echo ""
    echo "==========================================================="
    echo "==========================================================="
    echo "                     STARTING MINIKUBE                     "
    echo "==========================================================="
    echo "==========================================================="
    echo ""
    sleep 1     
    exit_general $?
    echo "Minikube is started ✅"
    echo ""
    echo "==========================================================="
    echo "==========================================================="
    echo "                  METALLB CONFIGURATION                    "
    echo "==========================================================="
    echo "==========================================================="
    echo ""
    sleep 1
    kubectl create namespace my-namespace
    metallb_config
    exit_general $?
    echo "Metalib is configured ✅"
	echo ""
    echo "==========================================================="
    echo "==========================================================="
    echo "                       BUILDING IMAGES                     "
    echo "==========================================================="
    echo "==========================================================="
    echo ""
    sleep 1
    build_images
    exit_general $?
    echo "Images are build ✅"
    echo ""
    echo "==========================================================="
    echo "==========================================================="
    echo "                      DEPLOYING SERVICES                   "
    echo "==========================================================="
    echo "==========================================================="
    echo ""
    sleep 1
    deploy_all
    exit_general $?
    echo "Services deployed ✅"
    minikube dashboard
    # if [ $? != 0 ]
    # then
    #     minikube dashboard
    # fi

	# printf "Checking version and nodes...\n"
	# kubectl version
	# kubectl get nodes
	# printf "Checking Minikube status...\n"
	# minikube status
	# read -p "Do you want to delete the cluster(Y/N): " REP
	# if [[ $REP = "Y" || $REP = "y" || $REP = "" ]]
	# then
	# 	delete_cluster
	# fi
	# debug mode :
	#minikube start --vm-driver=hyperkit --v=7 --alsologtostderr

	exit_general $?
	echo "END"
}

main 

# =========================   LEARNING   ==========================

# https://medium.com/@taweesoft/chapter-1-how-to-easily-deploy-your-web-on-kubernetes-83209a8618be

# KUBERNETES
# => Container orchestartion tool

# DOCKER
# Use of Docker for a container (Develop and deploy applications)
# OS kernel and hardware remain the same
# // VM virtualize also the kernel (the OS)
# A container = way to package applications with all the dependencies and configurations (Portable)
# A container is a own isolated operating system
# An image is running inside a container / it's a part of a container (+ file system + nv configs)
# An image is used to create one or more container
# Docker Hub => Github of app on Docker
# Commands:
# docker ps 										=> show running containers
# docker inspect                                    => more info
# docker pull redis                                 => create the image from DockerHub
# docker run redis									=> create the container redis
# docker build Dockerfile -t myfile                 => when you have a Dockerfile / -t for tag + a name / create an image locally
# docker stop (id)  								=> stop the container with the id
# docker ps -a 										=> show all containers running or not running (take the id to restart)
# docker run -p6000:6379 redis 						=> binding ports / your laptop 6000 port is bound to the countainer 6369
# docker logs (id)									=> give the latest logs
# docker run -d -p6000:6379 --name redis_new redis 	=> change the name in "redis_new" / -d for detached mode
# docker run -v /opt/datadir:/var/lib/mysql mysql   => create a dir opt and match the database / external volume
# docker exec -it (id) sh       					=> go inside of the container / -i for interactive and -t for terminal
# inside:											=> cd /  		exit
# docker start 										=> restart a container 
# docker network ls 								=> Show the different networks of docker
# docker network create mongo-network				=> create the mongo-network
# docker compose (.yaml) file take all the commands related for the creation of the container:
# docker run -d \
# -p 8081:8081 \
# -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
# -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
# --net mongo-network \
# --name mongo-express \
# -e ME_CONFIG_MONGODB_SERVER=mongo-db \
# mongo-express
# docker-compose -f mongo.yaml up					=> execute the yaml file
# docker-compose -f mongo.yaml down					=> remove everything
# docker build -t my-app:1.0 .						=> create a docker image based on the docker file
# docker run -t my-app:1.0
# When you adjust the docker file, you have to rebuild the image (docker images / docker rm (id))
# docker exec -it (id) /bin/sh
# docker stop $(docker ps -a -q)                    => stop all running containers
# docker rm $(docker ps -a -q)                      => delete stopped containers
# docker rmi $(docker images -q)                    => delete all images
# ifconfig | grep 192                               => give the ip adress of the local host
# docker system prune                               => delete all
# docker run -it alpine sh
# apk add --update redis
# docker commit -c 'CMD ["redis-server"]' <id>      => sens inverse pour creer une image


# KUBERNETES
# Node : physical server or virtual machine that runs containers
# Master manage the nodes 
# Pod : smallest unit in k8s / create a layer in top of a container / one app by pod
#       run one or more related containers
#       Each pod and db has its own IP adress / can communicate with other pod with it
#       Pod can die easily, and a new IP is placed. So we use a service instead of ip address
#       runs a single sets of containers / not used in production
# Service : permanent IP address / set up networking in a k8 cluster
#       Connects to pods even if the IP address of the pod changed
#       External service : opens the communications from external sources
#       One service connects multiple nodes
#       4 kind of services: 
#           - ClusterIp 
#           - NodePort => expose the container to the outside world 
#           - Ingress => external service with a beautiful name instead od http://000110:
#                       If you want to communicate with a service running in a pod, 
#                        you have to open up a channel for communication.
#           - LoadBalancer => same as ingress 
# Deployment : Maintains a set of identical pods, ensuring their number and config
#           Like pods, runs containers
#           Deployment is an abstraction in top of pods (pod is an abstraction in top of containers)
#           Purpose: being able to update more info than pod (only the image)
#           has a pod template
# Volumes: storage of the db on a local machine or remote of the k8 cluster
#           3 types (volume / persistent volume / persistence volume claim)
#           persistent not linked to the pod => good to keep the data if the pod crash
# Secret: securely store a piece of info in the cluster
#			command: kubectl create secret generic pgpassword --from-literal PGPASSWORD=12345 
# ConfigMap: same as secret but no password / external conf of your app
# K8 doesn't manage db persistence
# Db can't be replicated with deployment => StatefulSet (component)
# No localhost / need to have an IP adress (minikube ip to get it)
# To deploy smth we update the config file

# DOCKER in KUBERNETES
# 3 processes need to be installed in each node
# The 1er is Docker (for the countainer)
# The 2e is Kubelet (process of K8 itself) / interact with the container and the machine node itself
# 		Kubelet starts the pod with a container inside
# The 3e is Kubeproxy / ensure the communication between nodes through services

# The master node has different processes:
# 1. API server / cluster gateway that gets the initial request of the k8 dashboard / authentification
# 2. Scheduler / start the app pod on the worker node / decide which pod, how much CPU and RAM
# 		Kubelet execute the request of the scheduler
# 3. Controller Manager / detect cluster state changes / send back a request to the scheduler
# 4. etcd / cluster brain / state of cluster are saved / key value store

# MINIKUBE
# To experiment with Kubernetes locally, Minikube will create a virtual cluster on your personal hardware
# Use for managing the VM itself - the node - local only (kubectl is  used for managing containers in the node)
# Master and nodes processes run on one machine / one node k8s cluster for testing purposes
# The node runs in a virtual box
# Copying the docker image to Minikube docker environment
# Building the docker image into Minikube itself.
# accessible through an IP adress :
# minikube ip

# API server is the entry point for the cluster (for the master process)
# Kubectl is a command line tool to create components through the API server
# kubectl get nodes 									// after launching minikube
# kubectl create -h 									// commands for creation
# kubectl create deployment nginx-depl --image=nginx 	// create a pod
# kubectl get replicaset 								// replicate the pod 
# kubectl edit deployment nginx-depl 					// auto generate a conf file
# kubectl apply -f nginx-deployment.yaml 				// launch the file config
# kubectl describe service nginx-service				
# kubectl get pod -o wide
# kubectl get deployment nginx-deployment -o yaml > nginx-deployment-result .yaml

# NAMESPACE
# Virtual cluster inside a k8 cluster
# Deployments, Services, Persistent Volume etc are wrapped under one huge bubble called Namespace. 
# Its duty is just grouping these components.
# 4 namespaces by default (system / public / node / default)
# kubectl create namespace my-namespace OR with a conf file
# purpose: store by teams or subjects
# volume and node can't be in a namespace
# kubens // list of all namespaces and the one active

# METALLB
# Load-balancer
# access to only one specific set of pods into the application

# NGINX
# Serveur - Logiciel libre de serveur Web (serveur le plus utilise en 2019)

# FTPS
# Serveur - protocol de communication, permet au visiteur de verifier l'identite du serveur


#FTPS is a server that is capable to download and upload files through the File Transfer Propocol.
#Grafana is a interactive application that can be used tho produce many visual representations of datas. In this project, we stablished an direct connection between the Ìnfluxdb pod, that were used to supply the application with the data needed to build charts, graphs, etc.
#Wordpress, Phpmyadmin and MySQL are three separeted pods responsible to manage and produce websites linkes to a solid database.
#NGINX is a http server that was user to sharpen our skills regrding proxy and server security.


# https://github.com/Victor-Akio/ft_services-42

# https://github.com/Victor-Akio/ft_services-42
# https://github.com/lobbyra/ft_services/blob/master/srcs/nginx/Dockerfile
# https://github.com/math-ve/19-ft_services/blob/master/srcs/metallb-config.yaml



































