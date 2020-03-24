```bash
git secret reveal
ansible-playbook -i ./inventory --vault-password-file ./.ansible-secret playbook.yml
```


```bash
# running container to deploy
sudo docker build -t deploy .
sudo docker run \
    --network host  \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    deploy
```
