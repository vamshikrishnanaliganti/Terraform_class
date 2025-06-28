#!/bin/bash

# Create a ZIP file
if [ ! -f "lambda_function.zip" ]; then
    zip -j  lambda_function.zip lambda_function.py
fi 

# Run Terraform command

#terraform destroy -auto-approve
terraform apply -auto-approve