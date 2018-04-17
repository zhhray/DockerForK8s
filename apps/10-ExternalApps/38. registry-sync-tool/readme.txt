容器工具
registry-sync-tool synchronizes images from a src registry to dst registry.


registry-sync-tool
Registry-sync-tool synchronizes images from a src registry to dst registry. It provides a /hook url for you to setup the webhooks of src registry.

Attention
If your registry uses HTTP, please configure /etc/default/docker, add --insecure-registry your_registry and then restart your docker deamon.
