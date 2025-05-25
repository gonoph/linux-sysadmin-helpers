# AAP playbook to test AWS BYOS billing

I use the following playbook in AAP to test my AWS instances to ensure they are
using BYOS Linux vs the more expensive PAYG images.

## Usage - Command-line ansible

You will need an inventory source, AWS credentials, and playbook.

When you run it, it will error if any instances are not BYOS.

1. install aws cli utility
2. configure your aws credentials
3. export the credentials
4. install the amazon.aws collection
5. run the playbook

```bash
# install awscli2
sudo dnf install awscli2
# configure credentials
aws configure
# export it
eval $(aws configure export-credentials --format env)
# install the collection
ansible-galaxy install amazon.aws
# run the playbook
ansible-playbook -i inventory.aws_ec2.yml aws_test_billing_codes.yml
```

If you're using ansible-navigator

```bash
# install awscli2
sudo dnf install awscli2
# configure credentials
aws configure
# export it
eval $(aws configure export-credentials --format env)
# run the playbook
ansible-navigator run aws_test_billing_codes.yml -i inventory.aws_ec2.yml --penv AWS_ACCESS_KEY_ID --penv AWS_SECRET_ACCESS_KEY
```

## Usage - Ansible Automation Platform

1. Prep the tower config file with AAP credentials
2. Create / Edit `vault.yml` with AWS credentials
3. Install the ansible.controller collection
4. Run the config playbook

The config playbook `config_aap.yml` will do the following:

1. Create AWS EC2 credential
2. Create AWS inventory
3. Create AWS source
4. Create a project pointing to this repo
5. Create Job Template to test the billing codes
5. Run the Job Template to test the billing codes

### Prep the tower config file with AAP credentials

This prepares the vault that will hold the AAP credentials and the collection
used to manage the AAP Controller server.

Create the `tower_cli.cfg` file or edit the example.

```ini
[general]
host = https://localhost
verify_ssl = true
oauth_token = LEdCpKVKc4znzffcpQL5vLG8oyeku6
```

Copy `vault.yml.example` to `vault.yml`, encrypt it, and edit it.

```bash
cp vault.yml.example vault.yml
read -s -p "Enter Vault Password: " VAULT_PASS
echo $VAULT_PASS > vault_password.txt
ansible-vault encrypt vault.yml --vault-password-file=vault_password.txt
# replace editor with your preferred editor
EDITOR=vim ansible-vault edit vault.yml --vault-password-file=vault_password.txt
```

***This step only required if not using ansible-navigator***

Install the ansible.controller collection if not using ansible-navigator

```bash
ansible-galaxy collection install ansible.controller
```

#### Run the playbook to create everything

Run the playbook passing the vault file

```bash
ansible-playbook -i localhost, config_aap.yml --vault-password-file=vault_password.txt
```

If you want to use ansible-navigator, use this

```bash
ansible-navigator run config_aap.yml -i localhost, --vault-password-file=vault_password.txt
```

## FINISHED! Check the output!

Navigate to your AAP server and view the output!
