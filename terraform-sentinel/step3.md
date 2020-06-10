In this step, you will edit your mock data structure to create a failing scenario based on the requirements in the policy. The passing test requires two tags and only allows for specific ACLs, so a failing test will have neither of those tags and have an ACL outside the bounds of your policy.

# Open the failing mock scenario for editing

There is a file called `mock-tfplan-fail-v2.sentinel`{{open}}. Open that file and edit the values for your failing test.

# Edit your mock data ACL

At line 123, the mock contains the ACL for the configuration. Instead of `public-read`, which is allowed in your policy, change this to `public-read-write`. 

If you are having trouble finding the specific line in the collection, search for "<UPDATE_VALUE> in the file.
```
				"acl":                                  "public-read-write",
```{{copy}}

# Edit your mock data tags

Review the mock data provided for you. `mock-tfplan-v2.sentinel`{{open}}

At line 133, the mock contains the tags for the configuration. To create a failing scenario, replace the tag identifiers for different values. These tag identifiers search for an exact match so any additional text will cause a failure. 

If you have trouble finding the specific line, search for "<UPDATE_ID>" in the file

```
				"tags": {
					"FAIL-Environment": "Prod",
					"FAIL-Name":        "HashiConf",
					"TTL":			60,
				},
```{{copy}}

# Create a failing test file

Now that you have created a plan in which your Sentinel policy will fail, you need to create test file for a failing test.

Open `terraform-sentinel/test/restrict-s3-buckets/fail.json`{{open}} to create a path to the failing mock data.

Copy and paste the relative path to your failing mock in the test file.

```
{
  "mock": {
    "tfplan/v2": "../../mock-data/mock-tfplan-fail-v2.sentinel"
  },
```{{copy}}

Review the rest of the test file. This test ensures the main rule will evalute to false.

# Create a passing test file
Open `terraform-sentinel/test/restrict-s3-buckets/pass.json`{{open}} and create a path to the passing mock data that has already been provided for you.

Copy and paste the relative path to your passing mock in the test file.

```
{
  "mock": {
    "tfplan/v2": "../../mock-data/mock-tfplan-pass-v2.sentinel"
  },
```{{copy}}

Review the rest of the test file. This test ensures the main rule will evalute to true.

# Run a test in the Sentinel CLI

In your terminal, run a test with the `verbose` flag

```
sentinel test -verbose restrict-s3-buckets.sentinel
```{{execute}}