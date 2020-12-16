#!/bin/bash
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config
systemctl restart sshd

if [ "$HOSTNAME" == "ansible1" ];
then
hostnamectl set-hostname controller
useradd automation
echo "P@55w0rd123!" | passwd --stdin automation

touch /root/auto-shutdown.sh
cat <<'SUDOS' > /etc/sudoers.d/automation
automation ALL=(ALL) NOPASSWD: ALL
SUDOS

subscription-manager repos --enable=ansible-2.8-for-rhel-8-x86_64-rpms
dnf install -y python3
dnf install -y ansible

else
echo "Gagal deploy ansible"
fi

echo "P@55w0rd123!" | passwd --stdin root
touch /root/auto-shutdown.sh
cat <<'AUTO-SHUTDOWN' > /root/auto-shutdown.sh
#!/bin/bash
#
# This is scheduled in CRON using ROOT, it runs every 5 minutes 
# and uses who -a to determine user activity. Once the idle time is
# more than the threshold value it shuts the system down.
#
echo "Start of sidle.shl"

threshold=15
log=/root/sidle.log
userid1=root
userid2=automation
inactive=`who -a | grep '$userid1\|$userid2' | cut -c 45-46 | sed 's/ //g'`

if [ "$inactive" != "" ]; then

echo "Idle time is: " $inactive

if [ "$inactive" -gt "$threshold" ]; then
echo "Threshold met so issuing shutdown command"
/sbin/shutdown -h now
else
echo "Bellow threshold"
fi
else
echo "Idle time is: 0"
fi 
echo "Ending"
AUTO-SHUTDOWN
chmod +x /root/auto-shutdown.sh
echo "Successfully deploy Hand-on Labs Ansible Environtment for RHCE 8 EX294"