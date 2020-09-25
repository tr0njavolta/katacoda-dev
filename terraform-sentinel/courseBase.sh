# Install unzip - Katacoda docker image doesn't have unzip
apt-get install unzip
curl -O https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/

# Download & unzip the Sentinel CLI
curl -O https://releases.hashicorp.com/sentinel/0.15.5/sentinel_0.15.5_linux_amd64.zip
unzip sentinel_0.15.5_linux_amd64.zip -d /usr/local/bin/

sleep 5s

mkdir -p ~/terraform-sentinel

git clone https://github.com/hashicorp/learn-terraform-sentinel.git ~/terraform-sentinel

mv ~/restrict-s3-buckets.sentinel ~/terraform-sentinel

cd ~/terraform-sentinel

clear

echo "Ready!"
