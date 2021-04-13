# Install CLI

```bash
curl -sL run.linkerd.io/install | sh
```

# Export Path 

```bash
PATH=$PATH:/Users/matheus/.linkerd2/bin
```

# Install Linkerd on Kubectl Context 

```bash
linkerd install | kubectl apply -f -
```

# Wait for install 

```bash
linkerd check
```


# Extensions 

## Viz Dashboards and Metrics

```bash
linkerd viz install | kubectl apply -f -
```

## Jaeger Collector and UI

```bash
linkerd jaeger install | kubectl apply -f -
```


## Multicluster Mode

```bash
linkerd multicluster install | kubectl apply -f
```

# Dashboard 

## For test mode 

```bash
linkerd viz dashboard & 
```

## Ingress Mode (VIZ)

### Nginx with basic auth

```bash
kubectl apply -f dashboard-ingress.yml
```

## Secrets

* User: admin
* Pass: admin

#### Get secret value

```
echo "YWRtaW46JGFwcjEkbjdDdTZnSGwkRTQ3b2dmN0NPOE5SWWpFakJPa1dNLgoK" | base64 --decode
admin:$apr1$n7Cu6gHl$E47ogf7CO8NRYjEjBOkWM.
```

# Inject 

## Raw Injection by YAML 

```bash
cat toolkit/demo-apps/chip.yml | linkerd inject - | kubectl apply -f -
```