#!/bin/bash
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config
systemctl restart sshd

if [ "$HOSTNAME" == "ansible1" ];
then
hostnamectl set-hostname controller
subscription-manager repos --enable=ansible-2.8-for-rhel-8-x86_64-rpms
dnf install -y python3
dnf install -y ansible
else
echo "Gagal deploy ansible"
fi
echo "Successfully deploy Hand-on Labs Ansible Environtment for RHCE 8 EX294"