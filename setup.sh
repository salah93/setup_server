commands='sudo dnf install -y python; sudo dnf install -y python2-dnf'
user='root'
inventory_file='hosts';
for ip in $(grep -v '\[.*\]' $inventory_file); do
    echo "ssh $user@$ip $commands";
    ssh $user@$ip $commands;
done
