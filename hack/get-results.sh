#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

results_file='results.csv'
results_tmp_file="$BASEDIR/results.csv.tmp"
cpu_query='rate(container_cpu_usage_seconds_total{name="experiment"}[20m])'
mem_query='avg_over_time(container_memory_usage_bytes{name="experiment"}[20m])'
net_rcv_query='rate(container_network_receive_bytes_total{name="experiment"}[20m])'
net_trmt_query='rate(container_network_transmit_bytes_total{name="experiment"}[20m])'

cp -n $results_tmp_file $results_file

echo -n $(curl -gs "http://localhost:9091/api/v1/query?query=$cpu_query" | jq -r .data.result[0].value[1]) >> $results_file
echo -n ";" >> $results_file

echo -n $(curl -gs "http://localhost:9091/api/v1/query?query=$mem_query" | jq -r .data.result[0].value[1]) >> $results_file
echo -n ";" >> $results_file

echo -n $(curl -gs "http://localhost:9091/api/v1/query?query=$net_rcv_query" | jq -r .data.result[0].value[1]) >> $results_file
echo -n ";" >> $results_file

echo -n $(curl -gs "http://localhost:9091/api/v1/query?query=$net_trmt_query" | jq -r .data.result[0].value[1]) >> $results_file
echo ";" >> $results_file

cat $results_file