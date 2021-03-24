# Creating a custom cluster 

```bash
kind create cluster --name demo --config config.yaml
```

# Deploy Metric Server 

```bash
kubectl apply -f toolkit/metric-server/metric-server.yml
```

# Deploy a ingress 

### Nginx

```bash
kubectl apply -f ingress/nginx/ingress.yml
```

### Traefik

```bash
kubectl apply -f ingress/traefik/ingress.yml
```

# Deploy demo application for tests 

```bash
kubectl apply -f toolkit/demo-apps/whois.yml
```

```bash
curl 0.0.0.0:80/whois/google.com -i
HTTP/1.1 200 OK
Date: Wed, 24 Mar 2021 20:18:41 GMT
Content-Type: application/json
Content-Length: 1706
Connection: keep-alive

{"domainName":"google.com","registryDomainId":"2138514_DOMAIN_COM-VRSN","registrarWhoisServer":"whois.markmonitor.com","registrarUrl":"http://www.markmonitor.com","updatedDate":"2019-09-09T08:39:04-0700","creationDate":"1997-09-15T00:00:00-0700","registrarRegistrationExpirationDate":"2028-09-13T00:00:00-0700","registrar":"MarkMonitor, Inc.","registrarIanaId":"292","registrarAbuseContactEmail":"abusecomplaints@markmonitor.com","registrarAbuseContactPhone":"+1.2083895770","domainStatus":"clientUpdateProhibited (https://www.icann.org/epp#clientUpdateProhibited) clientTransferProhibited (https://www.icann.org/epp#clientTransferProhibited) clientDeleteProhibited (https://www.icann.org/epp#clientDeleteProhibited) serverUpdateProhibited (https://www.icann.org/epp#serverUpdateProhibited) serverTransferProhibited (https://www.icann.org/epp#serverTransferProhibited) serverDeleteProhibited (https://www.icann.org/epp#serverDeleteProhibited)","registrantOrganization":"Google LLC","registrantStateProvince":"CA","registrantCountry":"US","registrantEmail":"Select Request Email Form at https://domains.markmonitor.com/whois/google.com","adminOrganization":"Google LLC","adminStateProvince":"CA","adminCountry":"US","adminEmail":"Select Request Email Form at https://domains.markmonitor.com/whois/google.com","techOrganization":"Google LLC","techStateProvince":"CA","techCountry":"US","techEmail":"Select Request Email Form at https://domains.markmonitor.com/whois/google.com","nameServer":"ns2.google.com ns3.google.com ns1.google.com ns4.google.com","dnssec":"unsigned","urlOfTheIcannWhoisDataProblemReportingSystem":"http://wdprs.internic.net/","lastUpdateOfWhoisDatabase":"2021-03-24T13:16:17-0700 <<<"}
```