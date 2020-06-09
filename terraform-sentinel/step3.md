In this step, you will edit your mock data structure to create a failing scenario based on the requirements in the policy. The passing test requires two tags and only allows for specific ACLs, so a failing test will have neither of those tags and have an ACL outside the bounds of your policy.

# Edit your mock data

The mock data from a Terraform plan is what Sentinel evaluates 

Write Passing Test
Copy mock data to new file "-pass-v2.sentinel"
Create a test case

Write Failing Tests
Copy mock data to new file "-fail-v2.sentinel"
Find & replace rule data
Create a test case

Run CLI test w/ trace