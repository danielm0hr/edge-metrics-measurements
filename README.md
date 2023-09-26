# Measuring metrics collection footprint for edge use cases

In the context of resource constraint environments like edge deployments,
acquiring data for observability purposes is challenging. Especially in
the metrics area, running a TSDB like Prometheus alongside the workloads,
which collects (scrapes) metrics and stores them for querying and alerting
is not an option. The only remaining possibility often is a pure scrape-and-forward
approach, where metrics are immediately sent to a storage location outside
of the cluster or device where the monitored workloads run.

This project sets up different configurations and combinations of OpenTelemetry 
Collector and Prometheus Agent with the goal to measure and compare their
resource footprint in different situations. Avalanche is used as the metrics
producer and Prometheus as the metrics database (both not part of the measurment).

## Setups

The following setups are measured (measured part in **bold**):
1. Avalanche -> /metrics <- **Prometheus Agent -> remote_write** -> Prometheus
2. Avalanche -> /metrics <- **OTel Collector -> OTLP** -> OTel Collector (-> remote_write -> Prometheus)
3. Avalanche -> /metrics <- **OTel Collector -> remote_write** -> Prometheus

