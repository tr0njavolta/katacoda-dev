In this step, you will edit your mock data structure to create a failing scenario based on the requirements in the policy. The passing test requires two tags and only allows for specific ACLs, so a failing test will have neither of those tags and have an ACL outside the bounds of your policy.

# Open the failing mock scenario for editing

There is a file called `mock-tfplan-fail-v2.sentinel`{{open}}. Open that file and edit the values for your failing test.

# Edit your mock data ACL



At line 121, the mock contains the ACL for the configuration. Instead of `public-read`, which is allowed in your policy, change this to `public-read-write`. 

If you are having trouble finding the specific line in the collection, search for #ACLVALUE in the file.
```
				"acl":                                  "public-read-write",
```{{copy}}

# Edit your mock data tags

Review the mock data provided for you. `mock-tfplan-v2.sentinel`{{open}}

At line 131, the mock contains the tags for the configuration. To create a failing scenario, replace the tag identifiers for different values. These tag identifiers search for an exact match so any additional text will cause a failure. 

If you have trouble finding the specific line, search for #TAGVALUE in the file

```
				"tags": {
					"FAIL-Environment": "Prod",
					"FAIL-Name":        "HashiConf",
					"TTL":			60,
				},
```{{copy}}

# Save your failing data as a new file

Now that you have created a plan in which your Sentinel policy will fail, you need to rename this mock data so it can be consumed in a failing test. 

The mock data from a Terraform plan is what Sentinel evaluates 

Write Passing Test
Copy mock data to new file "-pass-v2.sentinel"
Create a test case

Write Failing Tests
Copy mock data to new file "-fail-v2.sentinel"
Find & replace rule data
Create a test case

Run CLI test w/ trace