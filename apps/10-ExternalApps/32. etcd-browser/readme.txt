数据库
A quick and easy way to view/edit basic keys in etcd.


etcd browser
Demo
http://henszey.github.io/etcd-browser/

Configuration
You can configure the builtin server using environment variables:

AUTH_USER: Username for http basic auth (skip to disable auth)
AUTH_PASS: Password for http basic auth
ETCD_HOST: IP of the etcd host the internal proxy should use [172.17.42.1]
ETCD_PORT: Port of the etcd daemon [4001]
SERVER_PORT: Port of builtin server
If you use a secured etcd:

ETCDCTLCAFILE
ETCDCTLKEYFILE
ETCDCTLCERTFILE