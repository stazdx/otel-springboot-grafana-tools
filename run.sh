#bin/bash

curl -sfL https://get.k3s.io | sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
snap install helm --classic
kubectl config view --raw > ~/.kube/config

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

kubectl create ns observability

cd promtail
helm upgrade --install promtail grafana/promtail -n observability -f promtail.yaml

helm upgrade --install loki grafana/loki-distributed -n observability

cd ../tempo
kubectl apply -f minio.yaml
helm upgrade --install tempo grafana/tempo-distributed -n observability -f tempo.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

cd ../prometheus-grafana
helm dependency update
helm upgrade --install kube-prometheus-stack -n observability .

cd ../springboot-app
kubectl apply -f springboot-app.yaml

kubectl get svc -l app=springboot-app
kubectl get svc -n observability 