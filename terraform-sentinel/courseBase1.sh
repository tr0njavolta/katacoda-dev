mkdir -p ~/terraform-sentinel
cd ~/terraform-sentinel

mkdir -p policies/test/require-fizz
mkdir -p policies/testdata
mkdir -p assets/assets

# Install unzip - Katacoda docker image doesn't have unzip
apt-get install unzip
curl -O https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/

# Download & unzip the Sentinel CLI
curl -O https://releases.hashicorp.com/sentinel/0.15.5/sentinel_0.15.5_linux_amd64.zip
unzip sentinel_0.15.5_linux_amd64.zip -d /usr/local/bin/

cd ..

mv fail.json pass.json ~/terraform-sentinel/policies/test/require-fizz
mv mock-tfconfig.sentinel mock-tfplan-v2-pass.sentinel mock-tfplan.sentinel mock-tfstate-v2.sentinel mock-tfconfig-v2.sentinel mock-tfplan-v2-fail.sentinel mock-tfplan-v2.sentinel mock-tfrun.sentinel mock-tfstate.sentinel ~/terraform-sentinel/policies/testdata
mv sentinel.json ~/terraform-sentinel/policies
mv require-fizz.sentinel ~/terraform-sentinel/policies
mv index.html ~/terraform-sentinel/assets/assets
mv main.tf ~/terraform-sentinel/assets

clear

echo "Ready!"