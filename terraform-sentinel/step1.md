Sentinel is an embeddable policy as code framework to enable fine-grained, logic-based policy decisions that can be extended to source external information to make decisions.

It allows customers to implement policy-as-code in the same way that Terraform implements infrastructure-as-code.

The Sentinel Command Line Interface (CLI) allows you to apply and test Sentinel policies including those that use mocks generated from Terraform Cloud and Terraform Enterprise plans.

In this scenario, you will work with the Sentinel CLI to create and test policies that, when added to Terraform Cloud, will enable you to programatticaly make infrastructure decisions for your organization.

To start, run the `sentinel` command to verify you have latest version.

```
sentinel --version
```{{execute}}