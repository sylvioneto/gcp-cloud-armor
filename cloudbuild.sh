# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ -z "$GOOGLE_CLOUD_PROJECT" ]
then
   echo Project not set!
   echo What Project ID do you want to deploy the solution to?
   read var_project_id
   gcloud config set project $var_project_id
   export GOOGLE_CLOUD_PROJECT=$var_project_id
fi


if [ "$1" = "destroy" ]
then
    echo Destroying solution on project $GOOGLE_CLOUD_PROJECT
    gcloud builds submit . --config cloudbuild_destroy.yaml
else
    echo Deploying solution onto project $GOOGLE_CLOUD_PROJECT
    BUCKET_NAME=gs://$GOOGLE_CLOUD_PROJECT-tf-state
    if gsutil ls $BUCKET_NAME; then
        echo Terraform bucket already created!
    else
        echo Creating Terraform state bucket...
        gsutil mb $BUCKET_NAME
    fi

    echo Enabling required APIs...
    gcloud services enable cloudbuild.googleapis.com \
        cloudresourcemanager.googleapis.com \
        compute.googleapis.com \
        iam.googleapis.com \
        servicenetworking.googleapis.com

    echo Waiting for APIs activation...
    sleep 30

    echo "Granting Cloud Build's Service Account IAM roles to deploy the resources..."
    PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')
    MEMBER=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com
    gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/editor
    gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/iam.securityAdmin
    gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/compute.networkAdmin
    gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/secretmanager.admin
    sleep 10

    echo Triggering Cloud Build job...
    gcloud builds submit . --config cloudbuild.yaml

    echo Solution deployed successfully!
fi

echo Script completed successfully!
