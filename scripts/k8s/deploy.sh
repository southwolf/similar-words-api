#!/bin/sh
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
docker pull xogroup/xo-helm:$K8_CLUSTER

INGRESS_HOST="${ENV_PREFIX}${CNAME}"

docker run --rm xogroup/xo-helm:$K8_CLUSTER \
   upsert $APPLICATION-$ENV infrastructure/xo-app-manifest \
   --set replicaCount=1 \
   --set image.repository=southwolf/similar-words-api \
   --set image.tag=latest \
   --set image.pullPolicy=Always \
   --set service.internalPort=5000 \
   --set service.matchSelectors.application=$APPLICATION \
   --set service.matchSelectors.environment=$ENV \
   --set service.matchSelectors.role=$ROLE \
   --set labels.environment=$ENV \
   --set labels.stack=$STACK \
   --set labels.role=$ROLE \
   --set labels.application=$APPLICATION \
   --set ingress.enabled=true \
   --set ingress.hosts={$INGRESS_HOST} \
   --set ingress.tls.hosts={$INGRESS_HOST} \
   --set "env[0].name=FLASK_ENV,env[0].value=development" \
   --set resources.requests.cpu=0.1 \
   --set resources.limits.cpu=1 \
   --set resources.requests.memory=2G \
   --set resources.limits.memory=4G \
   --set imagePullSecrets.name=$K8_DOCKER_SECRET \
   --namespace $NAMESPACE
