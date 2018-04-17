监控工具
Compute Resource Usage Analysis and Monitoring of Container Clusters.


Heapster
GoDoc Build Status  Go Report Card

Heapster enables Container Cluster Monitoring and Performance Analysis for Kubernetes (versions v1.0.6 and higher), and platforms which include it.

Heapster collects and interprets various signals like compute resource usage, lifecycle events, etc, and exports cluster metrics via REST endpoints.

Heapster supports multiple sources of data. More information here.

Heapster supports the pluggable storage backends described here. We welcome patches that add additional storage backends. Documentation on storage sinks here. The current version of Storage Schema is documented here.

Running Heapster on Kubernetes
Heapster can run on a Kubernetes cluster using a number of backends. Some common choices:

InfluxDB
Stackdriver Monitoring and Logging for Google Cloud Platform
Other backends
Running Heapster on OpenShift
Using Heapster to monitor an OpenShift cluster requires some additional changes to the Kubernetes instructions to allow communication between the Heapster instance and OpenShift's secured endpoints. To run standalone Heapster or a combination of Heapster and Hawkular-Metrics in OpenShift, follow this guide.

Troubleshooting guide here
Community
Contributions, questions, and comments are all welcomed and encouraged! Developers hang out on Slack in the #sig-instrumentation channel (get an invitation here). We also have the kubernetes-dev Google Groups mailing list. If you are posting to the list please prefix your subject with "heapster: ".