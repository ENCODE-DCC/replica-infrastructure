Creates bucket and dynamoDB to store terraform state remotely. There is a chicken and egg situation here. First one needs to create the bucket and the database table, then add the backend to the `main.tf` and run `terraform init` and `terraform apply` to use the remote state and locking configuration for creating the above infrastructure.
Now that the bucket and dynamoDB table have been created this backend can be used by addingthe following terraform block into your `main.tf`:
```
terraform {
  backend "s3" {
    bucket         = "encoded-replica-terraform-state"
    key            = "[your-path-here]"
    region         = "us-west-1"
    dynamodb_table = "encoded-replica-terraform-state-locks"
    encrypt        = true
  }
}
```
where the value for `key` is the path in the s3 bucket where you want to store the state.
