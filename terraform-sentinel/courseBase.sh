mkdir -p ~/terraform-sentinel
git clone https://github.com/tr0njavolta/2021-test-sentinel.git ~/terraform-sentinel

cd ~/terraform-sentinel

wget https://releases.hashicorp.com/sentinel/0.18.2/sentinel_0.18.2_linux_amd64.zip

unzip sentinel_0.18.2_linux_amd64.zip

rm /usr/local/bin/sentinel

mv sentinel /usr/local/bin/

echo "Ready!"
