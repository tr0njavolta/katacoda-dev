Now that you have created a policy, you will add some additional restrictions. 

First, specify the exact tags the policy should search for:

# Add specific tags
required_tags = [
	"Name",
    "Environment",
]



# Add specific tag rule

bucket_tags = rule {
	all s3_buckets as _, buckets {
		all required_tags as rt {
			buckets.change.after.tags contains rt
		}
	}
}


# Add ACL restriction

allowed_acls = [
	"public-read",
	"private",
]

# Add ACL Rule

acl_allowed = rule {
	all s3_buckets as _, buckets {
		buckets.change.after.acl in allowed_acls
	}
}


# Add main rule

main = rule {
    (acl_allowed and bucket_tags) else false
}