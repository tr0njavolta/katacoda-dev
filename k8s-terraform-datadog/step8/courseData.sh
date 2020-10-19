#!/bin/sh

# clean up `tfplan` file from previous step
rm \
  --recursive \
  --force \
  "/root/step7.tfplan"

# copy relevant files to workspace
cp /tmp/scenario/k8s-terraform-datadog/step8/*.tf "/root/"
