# set up environment to deploy notebooks on remote servers

## steps
+ install ansible

    sudo pip install ansible

+ on local machine put remote machines' ip addresses in `inventory` file
+ run the ansible playbook

    ansible-playbook -i ./inventory playbook.yml

