#!/bin/bash

set -e

# kubectl create ns foo
# kubectl create ns bar
# kubectl create ns legacy

HTTP_BIN_YAML=https://raw.githubusercontent.com/istio/istio/refs/heads/release-1.24/samples/httpbin/httpbin.yaml
CURL_YAML=https://raw.githubusercontent.com/istio/istio/refs/heads/release-1.24/samples/curl/curl.yaml

for ns in foo bar legacy; do
  # kubectl label ns $ns istio-injection=enabled
  kubectl apply -n $ns -f $HTTP_BIN_YAML
  kubectl apply -n $ns -f $CURL_YAML
done

# curl $CURL_YAML | kubectl apply -n legacy -f -

for from in foo bar legacy; do for to in foo bar; do kubectl exec "$(kubectl get pod -l app=curl -n ${from} -o jsonpath={.items..metadata.name})" -c curl -n ${from} -- curl http://httpbin.${to}:8000/ip -s -o /dev/null -w "curl.${from} to httpbin.${to}: %{http_code}\n"; done; done
