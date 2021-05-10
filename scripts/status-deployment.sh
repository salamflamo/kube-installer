#!/bin/bash
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config
systemctl restart sshd

if [ "$HOSTNAME" == "ansible1" ];
then
hostnamectl set-hostname controller
useradd automation
echo "P@55w0rd123!" | passwd --stdin automation

cat <<'SUDOS' > /etc/sudoers.d/automation
automation ALL=(ALL) NOPASSWD: ALL
SUDOS
subscription-manager repos --enable=ansible-2.8-for-rhel-8-x86_64-rpms
dnf install -y python3
dnf install -y ansible
else
echo "Bukan node controller"
fi

echo "P@55w0rd123!" | passwd --stdin root
touch /root/auto-shutdown.sh
touch /root/auto-shutdown1.sh
cat <<'AUTO-SHUTDOWN' > /root/auto-shutdown.sh
#!/bin/bash
#
# This is scheduled in CRON using ROOT, it runs every 5 minutes 
# and uses who -a to determine user activity. Once the idle time is
# more than the threshold value it shuts the system down.
#
echo "Start of sidle.shl"

threshold=5
log=/root/sidle.log
userid=automation
inactive='who -a | grep $userid | cut -c 45-46 | sed 's/ //g''

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

cat <<'AUTO-SHUTDOWN1' > /root/auto-shutdown1.sh
#!/bin/bash
#
# This is scheduled in CRON using ROOT, it runs every 5 minutes 
# and uses who -a to determine user activity. Once the idle time is
# more than the threshold value it shuts the system down.
#
echo "Start of sidle.shl"

threshold=5
log=/root/sidle.log
userid=root
inactive='who -a | grep $userid | cut -c 45-46 | sed 's/ //g''

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
AUTO-SHUTDOWN1

cat <<'ETC' > /etc/hosts
127.0.0.1   localhost 
::1         localhost 
192.168.234.108 controller.loc controller
192.168.234.109 ansible2.loc ansible2
192.168.234.110 ansible3.loc ansible3
192.168.234.111 ansible4.loc ansible4
192.168.234.112 ansible5.loc ansible5
ETC
chmod +x /root/auto-shutdown.sh
chmod +x /root/auto-shutdown1.sh

(crontab -l 2>/dev/null; echo "*/10 * * * * /root/auto-shutdown.sh -with args") | crontab -
(crontab -l 2>/dev/null; echo "*/10 * * * * /root/auto-shutdown1.sh -with args") | crontab -
(crontab -l 2>/dev/null; echo "59 17 * * * /sbin/shutdown -h now") | crontab -
(crontab -l 2>/dev/null; echo "59 23 * * * /sbin/shutdown -h now") | crontab -

echo "Successfully deploy Hand-on Labs Ansible Environtment for RHCE 8 EX294"