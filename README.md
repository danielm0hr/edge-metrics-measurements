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
resource footprint in different situations. 
[Avalanche](https://github.com/prometheus-community/avalanche/) is used as the 
metrics producer and Prometheus as the metrics database (both not part of the 
measurment).

## Configurations

The following setups are measured (measured part in **bold**):
1. Avalanche -> /metrics <- **Prometheus Agent -> remote_write** -> Prometheus
2. Avalanche -> /metrics <- **OTel Collector -> OTLP** -> OTel Collector 
(-> remote_write -> Prometheus)
3. Avalanche -> /metrics <- **OTel Collector -> remote_write** -> Prometheus

## How to run it

The scenarios' Docker Compose setups can be found in the `scenario_[1-3]` 
directories. To run a scenario execute

```
docker-compose up
```

in one of the directories. This runs the above listed components plus a 
[cAdvisor](https://github.com/google/cadvisor) instance. The receiving 
Prometheus instance is set up to scrape cAdvisor and can be queried for
container metrics. This is the basis for measurement.

The number of series which Avalanche generates can be changed by overriding
the `METRICS_COUNT` environment variable which is set in each scenario's 
`.env` file.

Note 1: The actual number of active series is 
`METRICS_COUNT * <# of series>`. The latter is currently hardcoded to a 
value of `10` (see the compose files).

Note 2: The refresh intervals for lables in Avalanche are currently
hardcoded to a value of `10000 seconds` in order to have a constant
number of active series for the whole measurement.

## Get the results

When the scenario has run for some time one can assume that components
have stabilized. Observation shows that this takes around 5 to 10 minutes.

You can run

```
hack/get-result.sh
```

to populate a CSV file in the current directory with the results of the
current run (averages over the the last 5 min). The script can be run
subsequently to add more result lines.

## PromCon EU 2023 talk

Results have been shown in lightning talk at PromCon EU 2023 in Berlin.
Find the slides [here](talks/DanielMohr_PromAgentVsOtelCol.pdf).