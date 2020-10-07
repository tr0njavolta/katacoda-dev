In this scenario, you will apply the Sentinel Policy-as-Code principles to a Terraform specific deployment. You will create a policy that requires your configuration to have specific tags on your S3 buckets and restrict the level of access to your bucket objects.

Open the file `terraform-sentinel/tf-config/main.tf`{{open}} and review the configuration you are testing.

This configuration builds a publicly-readable S3 bucket with a unique name and deploys an example web app as a bucket object. The `acl` attribute of the `"aws_s3_bucket" "bucket"` resource ensures this web app object is public but the viewer cannot write or edit it.

For your first policy, create a resource filter for your S3 buckets and a rule that requires that resource to have at least one tag.

## Create a filter

Open the stub of this policy in `terraform-sentinel/restrict-s3-buckets.sentinel`{{open}}.

Create a filter for the s3_bucket resources in the Terraform Cloud plan. Copy and paste the filter block below the commented line `# Filter S3 buckets`.

```
s3_buckets = filter tfplan.resource_changes as _, rc {
	rc.type is "aws_s3_bucket" and
	(rc.change.actions contains "create" or rc.change.actions is ["update"])
}
```{{copy}}


## Create the bucket rule

Add a rule to evaluate mock data. Copy and paste the `bucket_tags` rule below the commented line `# Rule to require at least one tag`.

```
bucket_tags = rule {
	all s3_buckets as _, buckets {
	buckets.change.after.tags is not null
	}
}
```{{copy}}


## Create main rule

Your filter and bucket rule will be evaluated in the main rule. Copy and paste the main rule below the commented line `# Main rule`


```
main = rule {
    bucket_tags else false
}
```{{copy}}

## Apply the policy

Run an `apply` with the `trace` flag in your terminal.

```
sentinel apply -trace restrict-s3-buckets.sentinel
```{{execute}}

Review the trace information. You will find that this policy passed because the Terraform plan contained at least one tag and meets the requirements in your `bucket_tags` rule.

## Create a failing policy

To test the failure behavior of your Sentinel policy, change the `bucket_tags` rule to a `null` statement.

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="buckets.change.after.tags is not null">buckets.change.after.tags is null</pre>

Run an apply in the Sentinel CLI again and evaluate the output. Your policy will fail.

```
sentinel apply -trace restrict-s3-buckets.sentinel
```{{execute}}

After reviewing the failing output, change the `bucket_tags` rule to evaluate correctly.

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="buckets.change.after.tags is null">buckets.change.after.tags is not null</pre>

In the next step, you will build on this policy with more specific and restrictive policy information.
