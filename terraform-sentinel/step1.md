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

For this policy, you will create rules to filter the number paramater through a series of rules and either Pass or Fail the policy based on those paramaters. 

For the first rule `is_fizzbuzz`, you will create a rule to evaluate if the number is divisible by both 5 and 3.

**Rules** form the basis of a policy by representing behavior that is either passing or failing (true or false). Rules are a first class language construct in Sentinel. A policy can and should be broken down into rules to aid with readability, testability, and performance.

For your `is_fizzbuzz` rule, Sentinel can use [standard arithmetic](https://docs.hashicorp.com/sentinel/language/arithmetic/) and [comparison operators](https://docs.hashicorp.com/sentinel/language/boolexpr/#comparison-operators) to evaluate `the_number` parameter. In order to evaluate `the_number`, add the evaluation to the rule to determine if your number, when divided by 15, has a remainder of 0.

```
is_fizzbuzz = rule {
the_number % 15 is 0
}
```

Repeat these steps for the `is_buzz` and `is_fizz` rules with the requirements for each in comments in the rule.

Your main rule is the final evaluation that will determine if your policy passes or fails. If your number is divisible by 15, 5, or 3, the policy will pass. If none of these conditions are met, your policy will fail.

```
# Logic to evaluate if the number supplied fits any of the requirements
main = rule {
    is_fizzbuzz or is_buzz or is_fizz else null
}
```

In your terminal, run `sentinel apply` on your policy with a passing number parameter.

```
sentinel apply -param the_number=30 require-fizz.sentinel 
```{{execute}}

Your output should display `Pass`.

Now, run `sentinel apply` on your policy with a failing number parameter.

```
sentinel apply -param the_number=19 require-fizz.sentinel 
```{{execute}}

Your output details all the failing parameters.

For more information on how your policy passes through these rules, apply the `-trace` flag.

```
sentinel apply -param the_number=12 -trace require-fizz.sentinel
```{{execute}}

You just wrote and ran your first policy with the Sentinel CLI! 

The next step will introduce a policy for a Terraform configuration.