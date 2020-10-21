# install `unzip`
apt-get install --quiet --yes "unzip"

# fetch Terraform archive
wget -q https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip

# unzip Terraform archive and make it accessible in PATH
unzip terraform_0.12.9_linux_amd64.zip -d "/usr/local/bin/"

# clean up
rm --recursive  --force terraform_0.12.9_linux_amd64.zip

# helm init
helm init

# add `datadog` Helm Charts (this provides `datadog/datadog:2.4.5`)
helm repo add "datadog" "https://helm.datadoghq.com/"

# update Helm Charts
helm repo update

# create user workspace
mkdir -p ~/workspace
mkdir -p /tmp/repo

git clone https://github.com/tr0njavolta/learn-datadog-tf.git /tmp/repo

cp /tmp/repo/variables.tf ~/workspace
cp /tmp/repo/terraform.tf ~/workspace
cp /tmp/repo/kubernetes.tf ~/workspace

cd ~/workspace/

clear

echo "Ready!"