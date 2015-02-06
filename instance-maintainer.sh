#!/bin/sh

TAG="[script]"
instance_id="$1"
elb_name="ELB_NAME_HERE"
ssh_user="SSH_USERNAME_HERE"
instance_pip=""

STEP="$2"
ssh_command=$3

if [ "$instance_id" == "" ];then
	echo "No ID:$instance_id"
	exit 1
fi

deregister () {
	echo "$TAG deregistering instance $instance_id"
	aws elb deregister-instances-from-load-balancer \
	--load-balancer-name $elb_name \
	--instances $instance_id
}

update_command () {
	echo "$TAG running command on $instance_pip: $ssh_command"
	if [ "$ssh_command" == "" ];then
		echo "$TAG Need command"
		exit 1
	fi

	ssh -t $ssh_user@$instance_pip "$ssh_command"
}

reboot_instance () {
	echo "$TAG rebooting instance: $instance_id"
	aws ec2 reboot-instances \
	--instance-ids $instance_id 
#	--dry-run
}

register () {
	echo "$TAG registering instance $instance_id"
	aws elb register-instances-with-load-balancer \
	--load-balancer-name $elb_name \
	--instances $instance_id
}

get_pip () {
	instance_pip=`aws ec2 describe-instances | grep $instance_id | cut -f14`
}

if [ "$STEP" == "1" ];then
	echo "$TAG detaching..."
	deregister
fi

if [ "$STEP" == "2" ];then
	echo "$TAG get IP address for $instance_id"
	get_pip
	if [ "$instance_pip" == "" ];then
		echo "$TAG Cannot find IP"
		exit 1
	fi
	update_command
fi

if [ "$STEP" == "3" ];then
	echo "$TAG reboot..."
	reboot_instance
fi

if [ "$STEP" == "4" ];then
	echo "$TAG attaching..."
	register
	exit 0
fi

echo "$TAG done."
exit 0




