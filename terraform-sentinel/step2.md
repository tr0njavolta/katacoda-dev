Now that you have created a policy, you will add some additional restrictions. 

In `terraform-sentine/restrict-s3-buckets.sentinel`{{open}}, add required tags to your policy.

# Create a print statement for debugging

Your policy plan collection contains a lot of data. To see what data you are giving to your policy, create a print statement below your filter statement.

```
print(s3_buckets)
```{{copy}}

Run your Sentinel CLI apply again to see what data your plan contains.

```
sentinel apply -trace restrict-s3-buckets.sentinel
```{{execute}}

# Create a required tags variable

```
required_tags = [
	"Name",
    "Environment",
]
```{{copy}}

# Create a rule for your required tags

Edit the `bucket_tags` rule to compare to your `require_tags` variable.

```
bucket_tags = rule {
	all s3_buckets as _, buckets {
		all required_tags as rt {
			buckets.change.after.tags contains rt
		}
	}
}
```{{copy}}


# Add an ACL restriction

For S3 buckets, it is considered a good practice to restrict the level of access to the objects to prevent unauthorized editing. Copy this list of allowed ACLs for your S3 bucket and paste it below your `bucket_tags` rule

```
allowed_acls = [
	"public-read",
	"private",
]
```{{copy}}

# Add a rule for your ACLs

Copy and paste this rule below your `allowed_acls` to evalute the ACL data in your plan.

```
acl_allowed = rule {
	all s3_buckets as _, buckets {
		buckets.change.after.acl in allowed_acls
	}
}
```{{copy}}


# Edit the main rule to evaluate both rules

Your main rule must evaluate both the `acl_allowed` and `bucket_tags` rule. Copy and paste this as your main rule.

```
main = rule {
    (acl_allowed and bucket_tags) else false
}
```{{copy}}

In the next step, you will edit your mock data to create a failing test suite.