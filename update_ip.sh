#!/bin/bash
MYIP=$(curl -s https://ifconfig.me)
timestamp=`date "+%Y%m%d-%H%M"`

if test -f "last_ip.conf"; then
  source last_ip.conf
else
  LAST_IP=""
fi

echo  "${timestamp} Last IP= ${LAST_IP}"
echo  "${timestamp} Current IP= ${MYIP}"

if [[ "$MYIP" != "$LAST_IP" ]];then


  ### add new IP to lighsail instance
  for instance in $(aws lightsail get-instances --query instances[].name --output text) ; do 
    aws lightsail open-instance-public-ports --instance-name $instance --port-info protocol=TCP,fromPort=0,toPort=65535,cidrs="${MYIP}/32";
    # in case the prior IP has been stored, remove it 
    if [[ "$LAST_IP" != "" ]];then
      aws lightsail close-instance-public-ports --instance-name $instance --port-info protocol=TCP,fromPort=0,toPort=65535,cidrs="${LAST_IP}/32"
    fi
  done
  
  ### now add IPs to EC2 instances
  echo "Updating of EC2 instances not yet implemented. Please check manually the following instances: \n"
  for instance in $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text) ; do 
    echo $instance ; 
      ## this is more complex: need to get the security group and change it there
  done
  echo "LAST_IP=${MYIP}" > last_ip.conf
  echo "${timestamp} Networking rules updated"
else
    echo "${timestamp} no new IP -> no need to update networking rules" >> update_ip.log
fi
