# set up environment to deploy notebooks on remote servers

## steps
+ install ansible
```bash
sudo pip install ansible
```
+ on local machine put remote machines' ip addresses in `inventory` file
+ run the ansible playbook

```bash
git secret reveal
ansible-playbook -i ./inventory --vault-password-file ./.ansible-secret playbook.yml
```
