In this scenario, you will work with the Sentinel CLI to create and test policies that, when added to Terraform Cloud, will enable you to programatticaly make infrastructure decisions for your organization.

To start, run the `sentinel` command to verify you have latest version.

```
sentinel --version
```{{execute}}

Next, navigate to your first Sentinel policy.

```
cd terraform-sentinel/policies
```{{execute}}

Open the `require-fizz.sentinel` policy. This policy is a sample of the Sentinel language and you will add rules & parameters to this policy for an introduction.

In this policy, you are required to evaluate a number and apply the programming "FizzBuzz" test which is detailed below.

```
Write a program that prints the numbers from 1 to 100.
But for multiples of three print “Fizz” instead of the number and for the multiples of five print “Buzz”.
For numbers which are multiples of both three and five print “FizzBuzz”.
```

For this policy, you will create rules to filter the number paramater through a series of rules and either Pass or Fail the policy based on those paramaters. For the first rule `is_fizzbuzz`, you will create a rule to evaluate if the number is divisible by both 5 and 3.

A **rule** in Sentinel is a boolean expression.

[Sentinel Arithmetic](https://docs.hashicorp.com/sentinel/language/arithmetic/)
