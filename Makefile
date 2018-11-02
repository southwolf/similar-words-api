env?=qa
pod?=''
image_name:=xogroup/tbl-similar-words.k8s.thebump.com
ifeq ($(env), production)
  k8_cluster=prod
  env_prefix=''
else
  k8_cluster=preprod
  env_prefix=qa-
endif
git_hash=$(shell git rev-parse HEAD)
tag?=$(git_hash)
repository:=xogroup/$(env_prefix)tbl-similar-words.k8s.thebump.com
tagged_image:=$(repository):$(tag)
namespace=twobrightlights
k8_docker_secret=docker-xotblci
cname=tbl-similar-words.k8s.thebump.com
application=similar-words
role=api
stack=similar-words

build:
	docker build .

push:
	TAGGED_IMAGE=$(tagged_image) \
	sh ./scripts/k8s/push.sh

tag:
	IMAGE_NAME=$(image_name) \
	TAGGED_IMAGE=$(tagged_image) \
	sh ./scripts/k8s/tag.sh

deploy:
	ENV=$(env) \
	K8_CLUSTER=$(k8_cluster) \
	REPOSITORY=$(repository) \
	TAG=$(tag) \
	ENV_PREFIX=$(env_prefix) \
	NAMESPACE=$(namespace) \
	K8_DOCKER_SECRET=$(k8_docker_secret) \
	CNAME=$(cname) \
	APPLICATION=$(application) \
	ROLE=$(role) \
	STACK=$(stack) \
	sh ./scripts/k8s/deploy.sh

release: tag push deploy

get_pods:
	K8_CLUSTER=$(k8_cluster) \
	NAMESPACE=$(namespace) \
	sh ./scripts/k8s/get_pods.sh

get_pod:
	K8_CLUSTER=$(k8_cluster) \
	NAMESPACE=$(namespace) \
	APPLICATION=$(application) \
	sh ./scripts/k8s/get_pod.sh

ssh:
	K8_CLUSTER=$(k8_cluster) \
	NAMESPACE=$(namespace) \
	POD=$(pod) \
	CONTAINER=$(container) \
	sh ./scripts/k8s/ssh_pod.sh

logs:
	K8_CLUSTER=$(k8_cluster) \
  NAMESPACE=$(namespace) \
	POD=$(pod) \
	CONTAINER=$(container) \
	sh ./scripts/k8s/pod_logs.sh
