# GCP Cloud Armor

## Description

This example demonstrates how to protect application running on GCE with Clour Armor.

![diagram.png](diagram.png)

It deployes the [Juice Shop](https://owasp-juice.shop) web app, an unsecure application, onto a GCE, then creates a Load Balacing, and finally adds Cloud Armor security policies. 

Resources created:
- VPC with firewall rules
- Managed Instance Group
- Cloud Armor with WAF rules and Rate limit


## Deploy
1. Create a new project and select it.

2. Open Cloud Shell and ensure the var below is set, otherwise set it with `gcloud config set project` command
```
echo $GOOGLE_CLOUD_PROJECT
```

3. Create a bucket to store your project's Terraform state
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

4. Enable the necessary APIs
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com cloudresourcemanager.googleapis.com logging.googleapis.com monitoring.googleapis.com iam.googleapis.com 
```

5. Give permissions to Cloud Build for creating the resources
```
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/editor
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/iam.securityAdmin
```


6. Clone this repo into Cloud Shell VM
```
git clone https://github.com/sylvioneto/gcp-cloud-armor
cd gcp-cloud-armor
```

7. Run terraform with Cloud Build
```
gcloud builds submit ./terraform --config cloudbuild.yaml
```

## Testing
You can use tools such as [dirsearch](https://github.com/maurosoria/dirsearch) to test your setup.

## Destroy
1. Execute Terraform using Cloud Build
```
gcloud builds submit ./terraform --config cloudbuild_destroy.yaml
```
