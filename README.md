# Goals

There should be at least 2 endpoints. We want to have the ones prefixed with '/api' exposed and the ones prefixed with '/private/api' not exposed to the public internet.

## Prerequisites

- kubernetes cli
- minikube
- installed minikube addons:

```sh
minikube addons enable registry-creds
minikube addons enable ingress
```

## Steps to deploy the app

Execute these make targets in this order:

make image/build
make k/setup
make k/deploy
k get ingress

Add this entry to the hosts file `/etc/hosts`

```
# Kubernetes #
127.0.0.1  flask-helloworld.info
```

Now run:

minikube tunnel

Then try to access the endpoints. You should see that you should only be able to access the public one:

```shell
curl http://flask-helloworld.info/api
curl http://flask-helloworld.info/private/api
```

## Clean up

```sh
make k/remove
```

Remove the entry from `/etc/hosts`