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

1. Prep the local vault file with local credentials
2. Install the ansible.controller collection
3. Run the config playbook

The config playbook `config_aap.yml` will do the following:

1. Create AWS EC2 credential
2. Create AWS inventory
3. Create AWS source
4. Create a project pointing to this repo
5. Create Job Template to test the billing codes
5. Run the Job Template to test the billing codes

### Prep vault and AAP controller collection

This prepares the vault that will hold the AAP credentials and the collection
used to manage the AAP Controller server.


#### Create or edit example config files

Create the `tower_cli.cfg` file or edit the example.

```ini
[general]
host = https://localhost
verify_ssl = true
oauth_token = LEdCpKVKc4znzffcpQL5vLG8oyeku6
```

Edit the `vault.yml` or copy `vault.yml.example` and edit it.

```yaml
EC2_USERNAME: AKGESKKUKB6NQWBK2ADK
EC2_SECRET_KEY: 8m7ctzd7ub7YlTThRRkHQrky7hR7mE4YI4qReou6
AAP_ORG: test-org
```

Encrypt the vault.

```bash
ansible-vault encrypt vault.yml
# Optionally create a vault-password file
cat > vault_password.txt
```

***This step only required if not using ansible-navigator***

Install the ansible.controller collection if not using ansible-navigator

```bash
ansible-galaxy collection install ansible.controller
```

#### Run the playbook to create everything

Run the playbook asking for the vault password

```bash
ansible-playbook -i localhost, config_aap.yml --ask-vault-password
```

If you want to use ansible-navigator, you need to use a vault file

```bash
ansible-navigator run config_aap.yml -i localhost, --vault-password-file=vault_password.txt
```

#### Finally run the job template on the AAP server

```bash
ansible -i localhost, -c local -mansible.controller.job_launch -a job_template=AWS-Test-Billing-Codes all
```

or via ansible-navigator

```bash
ansible-navigator exec -- ansible -i localhost, -c local -mansible.controller.job_launch -a job_template=AWS-Test-Billing-Codes all
```

## FINISHED! Check the output!

Navigate to your AAP server and view the output!
