# Cloud Armor Demo

This example deploys a web application called [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/), and expose it to the internet by using a Global Load Balancer protected with Cloud Armor.


## Arquitecture
![architecture](architecture.png)

## Deploy

1. Click on Open in Google Cloud Shell button below.
<a href="https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/sylvioneto/gcp-cloud-armor" target="_new">
    <img alt="Open in Cloud Shell" src="https://gstatic.com/cloudssh/images/open-btn.svg">
</a>

2. Run the `cloudbuild.sh` script
```
sh cloudbuild.sh
```

## Destroy
Execute the command below on Cloud Shell to destroy the resources.
```
sh cloudbuild.sh destroy
```
