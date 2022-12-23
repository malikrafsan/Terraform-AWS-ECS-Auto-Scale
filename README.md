# AWS Nginx ECS Cluster with Load Balancer and Fargate Launch Type and Target Tracking Autoscaling

## How to Run
- Clone this repository
- Make sure you have terraform installed (You can refer to this [link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)). This repository is tested for terraform version 1.3.5
- Make sure you have AWS cli installed on your machine
- Copy `keys.tfvars.example` to `keys.tfvars` and add your AWS credential
- Run this command to initialize terraform project
  ```
  terraform init
  ```
- Run this command to see plan that will configured when you apply the configuration
  ```
  ./scripts/plan.sh
  ``` 
- Run this command to apply configuration. 
  ```
  ./scripts/apply
  ```
- You can see load_balancer url in terminal, under output.

## How To Delete Resource (after resources made)
- Run this command
  ```
  terraform destroy -var-file="keys.tfvars"
  ```

## Author
Malik Akbar Hashemi Rafsanjani | 13520105
