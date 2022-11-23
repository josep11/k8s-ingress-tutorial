# Goals

There should be at least 2 endpoints. We want to have the ones prefixed with '/api' exposed and the ones prefixed with '/private/api' not exposed to the public internet.

## Steps to deploy the app

Execute these make targets in this order:

- image/build
- k/deploy
- minikube/assign-public-ip

Then try to access:
/api
/private/api

## Clean up

`make k/remove`
