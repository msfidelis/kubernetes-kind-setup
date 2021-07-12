# Install using Helm 

```bash
helm install prometheus --namespace prometheus --create-namespace prometheus-community/kube-prometheus-stack
```

# Install Grafana Dashboard Ingress 

```bash
kubectl apply -f ingress.yml
```

## Grafana Password 

Username: `admin`
Password: `prom-operator`