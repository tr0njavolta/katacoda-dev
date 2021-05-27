Now that you have created a policy, you will add some additional restrictions.

Open the policy file `terraform-sentinel/restrict-s3-buckets.sentinel`{{open}}, and add a print statement.

## Create a print statement for debugging

The print statement is a helpful tool for debugging and discovery when you are writing policies, so add one to the end of your policy.

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="append">
print(s3_buckets)
</pre>

Run your Sentinel CLI apply again to return the filter data in your terminal.

```
sentinel apply -trace restrict-s3-buckets.sentinel
```{{execute}}

Copy the print statement output from your Sentinel apply, which will begin with `"{aws_bucket.bucket:..."` and end with `"..."type":"aws_s3_bucket")}"`.

Create a new file called `terraform-sentinel/print.json`{{open}} and paste the print output there.

Pipe the contents of this file to a `jq` command in your terminal to make this data easier to read.

```
cat print.json | jq
```{{execute}}

Now, you can view the `resource_changes` collection for your S3 bucket resource as a key/value store.

Remove the print statement from your policy once you have reviewed the output.

## Create a required tags variable

Open the policy file `terraform-sentinel/restrict-s3-buckets.sentinel`{{open}} again, and paste the below `required_tags` variable into the file above the `bucket_tags` rule. You are creating a list of variables that must be returned from the data you just generated in the previous print statement.

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="insert" data-marker="# Rule to require at least one tag">
# Rule to require specific tags
required_tags = [
    "Name",
    "Environment",
]
</pre>


## Create a rule for your required tags

Replace the `bucket_tags` rule with a new requirement to compare to your `require_tags` variable.

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="insert" data-marker="
bucket_tags = rule {
    all s3_buckets as _, buckets {
    buckets.change.after.tags is not null
    }
}">
bucket_tags = rule {
all s3_buckets as _, buckets {
    all required_tags as rt {
        buckets.change.after.tags contains rt
        }
    }
}
</pre>


## Add an ACL restriction

Copy this list of allowed ACLs for your S3 bucket and paste it below your `bucket_tags` rule



<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="insert" data-marker="
bucket_tags = rule {
all s3_buckets as _, buckets {
    all required_tags as rt {
        buckets.change.after.tags contains rt
        }
    }
}">
bucket_tags = rule {
all s3_buckets as _, buckets {
    all required_tags as rt {
        buckets.change.after.tags contains rt
        }
    }
}

allowed_acls = [
	"public-read",
	"private",
]
</pre>

## Add a rule for your ACLs

Copy and paste your ACL rule below your `allowed_acls` to evalute the ACL data in your plan.

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="append">
acl_allowed = rule {
	all s3_buckets as _, buckets {
	buckets.change.after.acl in allowed_acls
	}
}
</pre>

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="insert" data-marker="
allowed_acls = [
	"public-read",
	"private",
]">
allowed_acls = [
	"public-read",
	"private",
]
# Restrict allowed ACL
acl_allowed = rule {
	all s3_buckets as _, buckets {
	buckets.change.after.acl in allowed_acls
	}
}
</pre>


## Edit the main rule to evaluate both rules

Your main rule must evaluate both the `acl_allowed` and `bucket_tags` rule. Edit your main rule with these new requirements.

<pre class="file" data-filename="terraform-sentinel/restrict-s3-buckets.sentinel" data-target="insert" data-marker="
# Main rule
main = rule {
    bucket_tags else false
}">
# Main rule
main = rule {
    (acl_allowed and bucket_tags) else false
}
</pre>

## Format and apply the policy

Run the `fmt` command to format your policy for clarity.

```
sentinel fmt restrict-s3-buckets.sentinel
```{{execute}}

Close and reopen the `terraform-sentinel/restrict-s3-buckets.sentinel`{{open}} file for your changes to reflect in your editor.

```
sentinel apply -trace restrict-s3-buckets.sentinel
```{{execute}}

In the next step, you will edit your mock data to create a failing test suite.
