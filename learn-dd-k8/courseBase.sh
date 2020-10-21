# install `unzip`
apt-get install --quiet --yes "unzip"

# fetch Terraform archive
curl --remote-name "https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip"

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

cd ~/workspace && touch kubernetes.tf helm_datadog.tf datadog_metrics.tf datadog_synthetics.tf datadog_dashboard.tf

echo "Ready!"
