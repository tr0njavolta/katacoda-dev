mkdir -p ~/terraform-sentinel
cd ~/terraform-sentinel

mkdir -p tf-config
mkdir -p mock-data
mkdir -p test/restrict-s3-buckets

# Install unzip - Katacoda docker image doesn't have unzip
apt-get install unzip
curl -O https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/

# Download & unzip the Sentinel CLI
curl -O https://releases.hashicorp.com/sentinel/0.15.5/sentinel_0.15.5_linux_amd64.zip
unzip sentinel_0.15.5_linux_amd64.zip -d /usr/local/bin/

sleep 15s

cd ..

mv fail.json pass.json ~/terraform-sentinel/test/restrict-s3-buckets
mv mock-tfconfig.sentinel mock-tfplan-pass-v2.sentinel mock-tfplan.sentinel mock-tfstate-v2.sentinel mock-tfconfig-v2.sentinel mock-tfplan-fail-v2.sentinel mock-tfplan-v2.sentinel mock-tfrun.sentinel mock-tfstate.sentinel ~/terraform-sentinel/mock-data
mv sentinel.json ~/terraform-sentinel
mv restrict-s3-buckets.sentinel ~/terraform-sentinel
mv index.html ~/terraform-sentinel/tf-config
mv main.tf ~/terraform-sentinel/tf-config

cd ~/terraform-sentinel

clear

echo "Ready!"