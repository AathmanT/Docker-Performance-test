
FROM anushiya/jmeter:v2
ADD jmeter-ballerina.jmx /home/jmeter/jmx/jmeter-ballerina.jmx
ADD jmeter-spring-boot.jmx /home/jmeter/jmx/jmeter-spring-boot.jmx
ADD jtl-splitter-0.3.1-SNAPSHOT.jar /home/jmeter/jar/jtl-splitter-0.3.1-SNAPSHOT.jar
ADD run_performance_test.sh /home/jmeter/run_performance_test.sh

WORKDIR /home/jmeter

RUN apt-get update && apt-get install curl nano -y
RUN chmod +x run_performance_test.sh



