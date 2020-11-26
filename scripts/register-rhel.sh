#!/bin/bash

ping -q -c2 www.redhat.com > /dev/null
if [ $? -eq 0 ]
then
echo $i "Pingable"
subscription-manager register --username puji.riawan --password trM3st4r47v85#@!
subscription-manager refresh
subscription-manager attach --auto
subscription-manager repos --enable rhel-7-server-rpms
subscription-manager repos --enable rhel-7-server-extras-rpms
subscription-manager repos --enable rhel-7-server-optional-rpms
subscription-manager repos --enable rhel-server-rhscl-7-rpms
echo "Completed Registering RHEL NODE Server"
else
echo $i "Not Pingable"
fi


