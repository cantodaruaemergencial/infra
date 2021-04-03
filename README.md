```bash
export TF_VAR_project="[gpc_project]"
export GOOGLE_APPLICATION_CREDENTIALS="[path]"

terraform init
terraform plan
terraform apply
```

+ services to enable on gcp:
  + `cloudresourcemanager.googleapis.com`
  + `artifactregistry.googleapis.com`