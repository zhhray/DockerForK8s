数据库
A web interface for managing redis: cli, admin, and live monitoring.


Redmon
Simple sinatra based dashboard for redis.

Environments
ADDRESS The thin bind address for the app (default: 0.0.0.0)
BASE_PATH The base path to expose the service at (default: /)
LIFESPAN Lifespan(in minutes) for polled data (default: 30)
NAMESPACE The root Redis namespace (default: redmon)
INTERVAL Poll interval in secs for the worker (default: 10)
PORT The thin bind port for the app (default: 4567)
REDIS The Redis url for monitor (default: redis://127.0.0.1:6379, note: password is support, ie redis://:password@127.0.0.1:6379)
CREDENTIALS Use basic auth. Colon separated credentials, eg admin:admin.
NO_APP Do not run the web app to present stats (default: true)
NO_WORKER Do not run a worker to collect the stats (default: true)
License
Copyright (c) 2012 Sean McDaniel

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy and modify copies of the Software, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.