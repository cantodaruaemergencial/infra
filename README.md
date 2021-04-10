```bash
export TF_VAR_project="[gpc_project]"
export GOOGLE_APPLICATION_CREDENTIALS="[path]"

terraform init
terraform plan
terraform apply
```

+ **services to enable on gcp:**
  + `cloudresourcemanager.googleapis.com`  
  + `sqladmin.googleapis.com`
  + `run.googleapis.com`
  + `compute.googleapis.com`
  + `servicenetworking.googleapis.com`
  + `vpcaccess.googleapis.com`
  + `cloudbuild.googleapis.com`

+ **permissions needed on automation custom role**:
  + `artifactregistry.repositories.create`
  + `artifactregistry.repositories.delete`
  + `artifactregistry.repositories.get`
  + `artifactregistry.repositories.list`
  + `artifactregistry.repositories.update`
  + `cloudsql.databases.create`
  + `cloudsql.databases.delete`
  + `cloudsql.databases.get`
  + `cloudsql.databases.list`
  + `cloudsql.databases.update`
  + `cloudsql.instances.create`
  + `cloudsql.instances.delete`
  + `cloudsql.instances.get`
  + `cloudsql.instances.list`
  + `cloudsql.instances.update`
  + `cloudsql.users.create`
  + `cloudsql.users.delete`
  + `cloudsql.users.list`
  + `cloudsql.users.update`
  + `run.services.create`
  + `run.services.delete`
  + `run.services.get`
  + `run.services.getIamPolicy`
  + `run.services.list`
  + `run.services.setIamPolicy`
  + `run.services.update`
  + `storage.objects.create`
  + `storage.objects.delete`
  + `storage.objects.get`
  + `storage.objects.getIamPolicy`
  + `storage.objects.list`
  + `storage.objects.setIamPolicy`
  + `storage.objects.update`

+ **roles service account need**:
  + custom role above
  + `Cloud Build Editor`
  + `Service Account User`
  + `Cloud Run Admin`
  + `Viewer`

+ create oauth consent screen