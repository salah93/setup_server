# set up environment to deploy notebooks on remote servers


### credit where its due
+ users
+ ssh

these playbooks were for the most part taken from [here](https://github.com/A5hleyRich/wordpress-ansible/tree/master/roles)

### steps
+ Make sure the remote servers have python installed

```
$ cat setup.sh
commands='dnf install -y python; dnf install -y python2-dnf'
user='root'
inventory_file='hosts'
for ip in $(grep -v '\[.*\]' $inventory_file); do
    ssh $user@$ip '$commands'
done
$ bash setup.sh
```

+ on local server put remote servers' ip addresses in <code>hosts</code> file

+ run the ansible playbook with your ssh credentials

```
ansible-playbook playbook.yml
```


default password for jupyter notebook: `ilovejupyter8888`

to change password read [here](http://jupyter-notebook.readthedocs.io/en/latest/public_server.html#preparing-a-hashed-password)
