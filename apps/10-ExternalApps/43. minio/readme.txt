存储系统
Minio is an object storage server compatible with Amazon S3 and licensed under Apache 2.0 License


Minio Gitter
Minio is an object storage server compatible with Amazon S3 and licensed under Apache license 2.0.

Description
Minio is an open source object storage server released under Apache License V2. It is compatible with Amazon S3 cloud storage service. Minio follows a minimalist design philosophy. Minio is light enough to be bundled with the application stack. It sits on the side of NodeJS, Redis, MySQL and the likes. Unlike databases, Minio stores objects such as photos, videos, log files, backups, container / VM images and so on. Minio is best suited for storing blobs of information ranging from KBs to 5 TBs each. In a simplistic sense, it is like a FTP server with a simple get / put API over HTTP.

Minio currently implements two backends

Filesystem (FS) - is available and ready for general purpose use.
ErasureCoded (XL) - is available, but it is not ready for general purpose use.
Minio Client
Minio Client (mc) provides a modern alternative to Unix commands like ls, cat, cp, sync, and diff. It supports POSIX compatible filesystems and Amazon S3 compatible cloud storage systems. It is entirely written in Golang.

Amazon S3 Compatible Client Libraries
Golang Library
Java Library
Nodejs Library
Python Library
.Net Library
Install Build StatusBuild status
GNU/Linux
Download minio for:

64-bit Intel from https://dl.minio.io/server/minio/release/linux-amd64/minio
32-bit Intel from https://dl.minio.io/server/minio/release/linux-386/minio
32-bit ARM from https://dl.minio.io/server/minio/release/linux-arm/minio
~~~ $ chmod +x minio $ ./minio --help ~~~

OS X
Download minio from https://dl.minio.io/server/minio/release/darwin-amd64/minio

~~~ $ chmod 755 minio $ ./minio --help ~~~

Microsoft Windows
Download minio for:

64-bit from https://dl.minio.io/server/minio/release/windows-amd64/minio.exe
32-bit from https://dl.minio.io/server/minio/release/windows-386/minio.exe
~~~ C:\Users\Username\Downloads> minio.exe --help ~~~

FreeBSD
Download minio from https://dl.minio.io/server/minio/release/freebsd-amd64/minio

~~~ $ chmod 755 minio $ ./minio --help ~~~ Read more here on How to configure Minio on FreeBSD with ZFS backend.

Docker container
Download minio for docker.

~~~ $ docker pull minio/minio ~~~

Read more here on How to configure data volume containers for Minio?

Source
NOTE: Source installation is intended for only developers and advanced users. For general use, please download official releases from https://minio.io/downloads.
If you do not have a working Golang environment, please follow Install Golang.

~~~ $ go get -d github.com/minio/minio $ cd $GOPATH/src/github.com/minio/minio $ make ~~~

How to use Minio?
Start minio server.

~~~ $ minio server ~/Photos

Endpoint: http://10.0.0.10:9000 http://127.0.0.1:9000 http://172.17.0.1:9000 AccessKey: USWUXHGYZQYFYFFIT3RE SecretKey: MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03 Region: us-east-1

Browser Access: http://10.0.0.10:9000 http://127.0.0.1:9000 http://172.17.0.1:9000

Command-line Access: https://docs.minio.io/docs/minio-client-quick-start-guide $ ./mc config host add myminio http://10.0.0.10:9000 USWUXHGYZQYFYFFIT3RE MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03

Object API (Amazon S3 compatible): Go: https://docs.minio.io/docs/golang-client-quickstart-guide Java: https://docs.minio.io/docs/java-client-quickstart-guide Python: https://docs.minio.io/docs/python-client-quickstart-guide JavaScript: https://docs.minio.io/docs/javascript-client-quickstart-guide ~~~

How to use AWS CLI with Minio?
This section assumes that you have already installed aws-cli, if not please visit https://aws.amazon.com/cli/
To configure aws-cli, type aws configure and follow below steps.

$ aws configure
AWS Access Key ID [None]: YOUR_ACCESS_KEY_HERE
AWS Secret Access Key [None]: YOUR_SECRET_KEY_HERE
Default region name [None]: us-east-1
Default output format [None]: ENTER
Additionally enable aws-cli to use AWS Signature Version '4' for Minio server.

$ aws configure set default.s3.signature_version s3v4
To list your buckets.

$ aws --endpoint-url http://localhost:9000 s3 ls
2016-03-27 02:06:30 deebucket
2016-03-28 21:53:49 guestbucket
2016-03-29 13:34:34 mbtest
2016-03-26 22:01:36 mybucket
2016-03-26 15:37:02 testbucket
To list contents inside bucket.

$ aws --endpoint-url http://localhost:9000 s3 ls s3://mybucket
2016-03-30 00:26:53 69297 argparse-1.2.1.tar.gz
2016-03-30 00:35:37 67250 simplejson-3.3.0.tar.gz
To make a bucket.

$ aws --endpoint-url http://localhost:9000 s3 mb s3://mybucket
make_bucket: s3://mybucket/
To add an object to a bucket.

$ aws --endpoint-url http://localhost:9000 s3 cp simplejson-3.3.0.tar.gz s3://mybucket
upload: ./simplejson-3.3.0.tar.gz to s3://mybucket/simplejson-3.3.0.tar.gz
Delete an object from a bucket.

$ aws --endpoint-url http://localhost:9000 s3 rm s3://mybucket/argparse-1.2.1.tar.gzdelete: s3://mybucket/argparse-1.2.1.tar.gz
Remove a bucket.

$ aws --endpoint-url http://localhost:9000 s3 rb s3://mybucket
remove_bucket: s3://mybucket/
How to use AWS SDK with Minio?
Please follow the documentation here - Using aws-sdk-go with Minio server

How to use s3cmd with Minio?
This section assumes that you have already installed s3cmd, if not please visit http://s3tools.org/s3cmd
Edit the following fields in your s3cmd configuration file ~/.s3cfg .

host_base = localhost:9000
host_bucket = localhost:9000
access_key = YOUR_ACCESS_KEY_HERE
secret_key = YOUR_SECRET_KEY_HERE
signature_v2 = False
bucket_location = us-east-1
To make a bucket.

$ s3cmd mb s3://mybucket
Bucket 's3://mybucket/' created
To copy an object to bucket.

$ s3cmd put newfile s3://testbucket
upload: 'newfile' -> 's3://testbucket/newfile'
To copy an object to local system.

$ s3cmd get s3://testbucket/newfile
download: 's3://testbucket/newfile' -> './newfile'
To sync local file/directory to a bucket.

$ s3cmd sync newdemo s3://testbucket
upload: 'newdemo/newdemofile.txt' -> 's3://testbucket/newdemo/newdemofile.txt'
To sync bucket or object with local filesystem.

$ s3cmd sync s3://otherbucket otherlocalbucket
download: 's3://otherbucket/cat.jpg' -> 'otherlocalbucket/cat.jpg'
To list buckets.

$ s3cmd ls s3://
2015-12-09 16:12 s3://testbbucket
To list contents inside bucket.

$ s3cmd ls s3://testbucket/
DIR s3://testbucket/test/
2015-12-09 16:05 138504 s3://testbucket/newfile
Delete an object from bucket.

$ s3cmd del s3://testbucket/newfile
delete: 's3://testbucket/newfile'
Delete a bucket.

$ s3cmd rb s3://testbucket
Bucket 's3://testbucket/' removed
Contribute to Minio Project
Please follow Minio Contributor's Guide

Jobs
If you think in Lisp or Haskell and hack in go, you would blend right in. Send your github link to callhome@minio.io.