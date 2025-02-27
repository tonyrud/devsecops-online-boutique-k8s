# online-boutique-gitops

Contains manifests and configuration for Kubernetes

This repo is connected to ArgoCD for easy deployments

## General

- `/base` contains all shared yaml files that can be used by different overlays
- `/platform` contains things that are used by the entire cluster
- `/overlays` are separate app configs, and are conntected to specific ArgoCD apps. ie `dev` will deploy to the dev online-boutique cluster, `preview` will deploy separate apps based on PRs!

## Prevew Environments

These are controlled by an appset in `appset/appset.yaml`. Pull Requests with the `preview` label added will start up a separate application instance based on the PR number.

[ArgoCD Docs on Pull Request AppSets](https://argo-cd.readthedocs.io/en/latest/operator-manual/applicationset/Generators-Pull-Request/#github)

## External Secrets

Using [ExternalSecrets](https://external-secrets.io/main/introduction/overview/)

Note, that some secrets commands are added to [Terraform repo README](https://github.com/tonyrud/12_iac_with_terraform)

Get the ExternalSecret

```bash
kubectl get ExternalSecret -n online-boutique
```

Get Secret data as JSON

```bash
kubectl get secret -n online-boutique stripe-api-key -o jsonpath="{.data}"
```

Get decoded Secret value

```bash
kubectl get secret -n online-boutique stripe-api-key -o jsonpath="{.data.stripe-key}" | base64 -d
```

Check for it in the actual pod

```bash
kubectl exec -it $(kubectl -n online-boutique get pods --selector=app=paymentservice -o name) -- env | grep STRIPE
```

## Istio

**NOTE: after adding sidecar injection, you must restart all the pods!**

```bash
kubectl rollout restart deployments
```

### Adding TLS Certificate

Add these files to AWS Secrets Manager

```bash
openssl req -x509 -newkey rsa:4096 -sha256 -days 30 -nodes -keyout key.pem -out cert.pem -subj "/CN=*.twnn.com"
```

### Inspect CMDS

Check the status of the install

```bash
helm status istiod -n istio-system && helm status istio-ingress -n istio-ingress
```

```bash
helm ls -n istio-ingress && helm ls -n istio-system
```

```bash
kubectl get Gateway,VirtualService
```

Check the peer authentication mesh is added

```bash
kubectl get peerauthentication --all-namespaces
```

Get svc outputs

```bash
istioctl x describe svc frontend -n online-boutique
```
