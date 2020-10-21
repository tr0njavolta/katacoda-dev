A synthetic check allows Datadog to check a specific URL at intervals of your choice. If the URL times out or does not return the expected value you will be alerted.

Open the `/root/datadog_synthetics.tf`{{open}} file.

Update the `url` with the Katacoda host URL. To get your URL, click the "+" sign in Katacoda and choose "View HTTP port 80 on Host 1." Katacoda will launch another web browser where you will select a different port. Update to "8080" and choose Display Port. Copy the new address in your browser into the configuration.


Apply your configuration to create a new synthetic monitor. Remember to confirm your apply with a `yes`.

`terraform apply`{{execute}}
