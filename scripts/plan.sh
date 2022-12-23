#!/bin/bash

terraform plan -var-file="keys.tfvars" -out="tfplan"
