CURRENT_PATH=$(shell pwd)
TARGET_TAG=v1
AWS_REPOSITORY=712449709000.dkr.ecr.eu-west-3.amazonaws.com

## Help
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9%:\\]+/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
		helpCommand = $$1; \
		helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	gsub("\\\\", "", helpCommand); \
	gsub(":+$$", "", helpCommand); \
		printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"


## Start containers
docker/start:
	docker-compose up -d --remove-orphans --build

## Clean start containers
docker/clean-start:
	docker-compose up -d --remove-orphans --build --force-recreate

## Stop and remove containers
docker/stop:
	docker-compose down --remove-orphans

## Start service containers. Alias for: docker/start
start: docker/start

## Stop docker containers. Alias for: docker/stop
stop: docker/stop

## Login to AWS ECR docker registry
docker/login:
ifndef ADDEVENT_AWS_PROFILE
	aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin ${AWS_REPOSITORY}
else
	aws ecr get-login-password --region eu-west-3 --profile $(ADDEVENT_AWS_PROFILE) | docker login --username AWS --password-stdin ${AWS_REPOSITORY}
endif

image/build:
	docker build -f app/Dockerfile -t ${AWS_REPOSITORY}/k8straefikingressrestrictingroutes:${TARGET_TAG} app/
	docker push ${AWS_REPOSITORY}/k8straefikingressrestrictingroutes:${TARGET_TAG}

k/describe:
	kubectl describe service flask-svc

k/get-all:
	kubectl get all | grep flask

k/deploy:
	kubectl apply -f k8s/flask-deployment.yaml
	kubectl apply -f k8s/flask-service.yaml 

k/remove:
	kubectl delete deployment flask-dep
	kubectl delete svc flask-svc

minikube/assign-public-ip:
	minikube service flask-svc
