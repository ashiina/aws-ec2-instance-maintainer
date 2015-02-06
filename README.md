# aws-ec2-instance-maintainer
Script that makes it easy to detach instances from ELB, perform scripts, reboot, and attach

What is this? 
----- 
It helps you easily perform the following tasks:  
1. Detach an instance from the ELB
2. Remotely xecute a command on the instance
3. Reboot the instance
4. Attach the instance to the ELB

How to Use
-----
It takes the `instance_id` and a `step` number as an argument. So a typical use-case would be like this:  

```bash
$ ./instance-maintainer.sh i-1234abcd 1 #detach from ELB
$ ./instance-maintainer.sh i-1234abcd 2 "yum --security -y update" #perform yum update
$ ./instance-maintainer.sh i-1234abcd 3 #reboot
$ ./instance-maintainer.sh i-1234abcd 4 #attach to ELB
```

License
----------
This library is released under the MIT license.




