backend_host_ip=172.17.0.1

run_time_length_seconds=600
#warm_up_time_seconds=300 # check for min vs sec
warm_up_time_minutes=2
actual_run_time_seconds=600

#Running on a server - comment it when running on my pc
jmeter_jtl_location=/home/jmeter/jtls
jmeter_jmx_file_root=/home/jmeter/jmx

jmeter_jtl_splitter_jar_file=/home/jmeter/jar/jtl-splitter-0.3.1-SNAPSHOT.jar

#Running on my pc -comment it when running on server
# jmeter_jtl_location=/home/anushiyat/Documents/wso2/project/latency-based-kubernetes-custom-autoscaler/jmeter/jtls
# jmeter_jmx_file_root=/home/anushiyat/Documents/wso2/project/latency-based-kubernetes-custom-autoscaler/jmeter/jmx
# server_metrics_location=/home/anushiyat/Documents/wso2/project/latency-based-kubernetes-custom-autoscaler/jmeter/server-metrics

# jmeter_jtl_splitter_jar_file=/home/anushiyat/Documents/wso2/project/latency-based-kubernetes-custom-autoscaler/jmeter/jar/jtl-splitter-0.3.1-SNAPSHOT.jar

# jmeter_performance_report_python_file=/home/anushiyat/Documents/wso2/project/latency-based-kubernetes-custom-autoscaler/jmeter/python/performance-report.py
# jmeter_performance_report_output_file=/home/anushiyat/Documents/wso2/project/latency-based-kubernetes-custom-autoscaler/jmeter/results.csv

# server_performance_report_generation_python_file=/home/anushiyat/Documents/wso2/project/latency-based-kubernetes-custom-autoscaler/jmeter/python/collect-metrics.py

rm -r ${jmeter_jtl_location}/

mkdir -p ${jmeter_jtl_location}/

concurrent_users=(10 50 100)
heap_sizes=(4g)
garbage_collectors=(UseParallelGC)
use_case=prime
request_timeout=50000

size=10007


for heap in ${heap_sizes[@]}
do
	for u in ${concurrent_users[@]}
		do
		for gc in ${garbage_collectors[@]}
		do
			total_users=$(($u))

			jtl_report_location=${jmeter_jtl_location}/${use_case}/${heap}_Heap_${total_users}_Users_${gc}_collector_${size}_size
			
			echo "Report location is ${jtl_report_location}"

			mkdir -p $jtl_report_location

			start_time=$(date +%Y-%m-%dT%H:%M:%S.%N)
			echo "start time : "${start_time}

			echo "starting jmeter"
			echo "jmeter  -Jgroup1.host=${backend_host_ip}  -Jgroup1.port=8688 -Jgroup1.threads=$u -Jgroup1.seconds=${run_time_length_seconds} -Jgroup1.timeout=${request_timeout} -n -t ${jmeter_jmx_file_root}/jmeter.jmx -l ${jtl_report_location}/results.jtl"
			jmeter  -Jgroup1.host=${backend_host_ip}  -Jgroup1.port=8688 -Jgroup1.threads=$u -Jgroup1.seconds=${run_time_length_seconds} -Jgroup1.timeout=${request_timeout} -n -t ${jmeter_jmx_file_root}/jmeter.jmx -l ${jtl_report_location}/results.jtl


			jtl_file=${jtl_report_location}/results.jtl

			echo "Splitting JTL"

			java -jar ${jmeter_jtl_splitter_jar_file} -f $jtl_file -t ${warm_up_time_minutes}

			jtl_file_measurement_for_this=${jtl_report_location}/results-measurement.jtl

			end_time=$(date +%Y-%m-%dT%H:%M:%S.%N)
			echo "end time : "${end_time}

			# echo "Collecting server metrics"

			# python3 ${server_performance_report_generation_python_file} ${server_metrics_location} ${start_time} ${end_time} ${size} ${u}

		done
	done
done

				
			
