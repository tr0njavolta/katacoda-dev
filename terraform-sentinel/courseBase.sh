# Install Terraform and init config
# Install docker - Ubuntu doesn't have docker
apt-get install docker-ce docker-ce-cli 

# Install unzip - Katacoda docker image doesn't have unzip
apt-get install unzip
cd ..
curl -O https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/

# Download & unzip the Sentinel CLI
curl -O https://releases.hashicorp.com/sentinel/0.15.5/sentinel_0.15.5_linux_amd64.zip
unzip sentinel_0.15.5_linux_amd64.zip -d /usr/local/bin/

# Run Docker Compose up (daemon)
docker-compose up -d

# Go back to workspace directory
cd ~/terraform-sentinel

clear

echo "Ready!"