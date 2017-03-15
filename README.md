# set up environment to deploy notebooks on remote servers

## steps
+ on local server put remote servers' ip addresses in <code>hosts</code> file
+ run the ansible playbook with your ssh credentials
```
ansible-playbook playbook.yml
```
