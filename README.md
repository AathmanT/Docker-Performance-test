## Running 2 Apps: same machine (in containers) vs different machines (in containers)
Jmeter is in one container and Spring boot is in another container.

Give the appropriate jmx file in run-performance-test.sh script as jmeter -t argument.


There are two folders.
1.Sinlge-vs-multiple-machine-test
  Here both jmeter and spring is deployed in one machine and in 2 different machines.
  
  sudo docker run --memory="6G" --cpuset-cpus="2" --name jmeter -it aathmant/jmeter-spring-boot:v1 bash
  Edit the run-performance-test.sh script for followings.
  change jmeter argument  -t jmeter-spring-boot.jmx
  change number of users, server ip and test duration
  sudo docker run -p 9000:9000  --memory="6G" --cpuset-cpus="2" --name prime anushiya/app:latest
  
  
2.CPU-KeepAlive-test
  Here Jmeter and Netty Echo service is used. Testing performance with different CPU allocation and setting keep alive time to   true or false.
  
  sudo docker run --memory="6G" --cpuset-cpus="2" --name jmeter -it aathmant/jmeter-spring-boot:v1 bash
  Edit the run-performance-test.sh script for followings.
  change jmeter argument  -t jmeter-ballerina.jmx
  change number of users, server ip and test duration
  sudo docker run -p 8688:8688 --memory="6G" --cpuset-cpus="2" --name netty -it aathmant/netty-echo:v1 bash

  
  


