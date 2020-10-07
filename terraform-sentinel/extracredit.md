In this extra credit scenario, you will refactor your existing policy into a module.

Modules allow you to re-use Sentinel code as an import. This allows you to package code that is useful across multiple policies, making final policy code simpler.

# Create a modules directory

Create a new `modules` directory.

`mkdir modules`{{execute}}

Move your policy to this directory as a new file.

`mv restrict-s3-buckets.sentinel modules/restrict.sentinel`{{execute}}

Remove the `main` rule and `print` statement.


## Update your module path

You created a new directory to house your modules. Sentinel needs the update your path to this directory in `sentinel.json`

Open `terraform-sentinel/sentinel.json`{{open}} and add the `modules` path to your new module under the `mock` paths. Copy and paste the complete file below.

```
{
  "mock": {
    "tfconfig": "mock-data/mock-tfconfig.sentinel",
    "tfconfig/v1": "mock-data/mock-tfconfig.sentinel",
    "tfconfig/v2": "mock-data/mock-tfconfig-v2.sentinel",
    "tfplan": "mock-data/mock-tfplan.sentinel",
    "tfplan/v1": "mock-data/mock-tfplan.sentinel",
    "tfplan/v2": "mock-data/mock-tfplan-v2.sentinel",
    "tfrun": "mock-data/mock-tfrun.sentinel",
    "tfstate": "mock-data/mock-tfstate.sentinel",
    "tfstate/v1": "mock-data/mock-tfstate.sentinel",
    "tfstate/v2": "mock-data/mock-tfstate-v2.sentinel"
  },
  "modules": {
    "restrict": {
      "path": "modules/restrict.sentinel"
    }
  }
}
```{{copy}}

## Create a new root policy

Create a new file `terraform-sentinel/root.policy`{{open}} and add the module as an `import` statement.

```
import "restrict"
```{{copy}}

Create a new main rule that accesses this module as an import.

```
main = rule {
    (restrict.acl_allowed and restrict.bucket_tags) else false
}
```{{copy}}

Run your Sentinel `apply` with the new `root.sentinel` file as the target policy.

```
sentinel apply -trace root.sentinel
```{{execute}}
