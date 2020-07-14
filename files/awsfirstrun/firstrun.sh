#!/bin/sh

while ! curl -s -I http://169.254.169.254/ -m 5 >/dev/null; do
    echo "Waiting for network to come up..."
    sleep 1
done

# Update hostname
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -s -o /etc/hostname -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-hostname
hostname $(cat /etc/hostname)
echo "I'm now" $(hostname)!

# Download user-provided SSH key for ec2-user
mkdir -p /home/ec2-user/.ssh/
curl -s -o /home/ec2-user/.ssh/authorized_keys -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key >/home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh/
echo "Done!"

rm -rf /var/service/awsfirstrun/
rm -rf /etc/sv/awsfirstrun/
