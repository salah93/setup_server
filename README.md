```bash
git secret reveal
ansible-playbook -i ./inventory --vault-password-file ./.ansible-secret playbook.yml
```
