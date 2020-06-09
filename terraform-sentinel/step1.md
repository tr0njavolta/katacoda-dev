In this scenario, you will apply the Sentinel logic principles to a Terraform specific deployment.

Navigate to the `terraform-config` and open the `main.tf` file.

This configuration builds an S3 bucket with a unique name and deploys an example web app as a bucket object. You have an S3 bucket policy attached to the bucket resource which allows pubic read permissions for your bucket object. This example configuration does not have any deployment safeguards built in and if your AWS user has S3 build and upload permissions, your Terraform deployment will apply successfully.

Proper testing of a policy requires that these values be able to be mocked - or, in other words, simulated in a way that allows the accurate testing of the scenarios that a policy could reasonably pass or fail under.

In order to test this policy, this scenario has pre-generated [mock data from Terraform Cloud](https://www.terraform.io/docs/cloud/sentinel/mock.html). To learn how to generate mock data for testing in the Sentinel CLI, follow the [Sentinel Learn guides on Sentinel & Terraform Cloud](https://www.learn.hashicorp.com/terraform?LINK).

Part of writing Sentinel policies is to determine your parameters based on your infrastructure. For this configuration, your S3 bucket must meet the following requirements:

- Must not have public-read-write access
- Must have server-side encryption
- Must be tagged with the name of the user who created it

Your stub policy is in `terraform-sentinel/policies/restrict-s3-buckets`. Navigate to the `restrict-s3-buckets.sentinel` in your browser.

```
import "tfplan/v2" as tfplan

# Filter S3 buckets
s3_buckets = 

# Allowed S3 ACLs
# Don't allow public-read-write
allowed_acls = 

# Required tags
required_tags = 

# Rule to restrict S3 bucket ACLs
acl_allowed = 


# Rule to require server-side encryption
require_encryption =

# Rule to require bucket tags
bucket_tags = 

# Main rule that requires other rules to be true
main = 
```

The first step in this scenario is to apply a filter to the resources you want to evaluate.