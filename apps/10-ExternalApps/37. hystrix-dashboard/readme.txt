微服务框架
服务熔断（Circuit breaker）dashboard by Netflix OSS hystrix.

服务容错
Circuit Breaker by Martin Fowler The basic idea behind the circuit breaker is very simple. You wrap a protected function call in a circuit breaker object, which monitors for failures. Once the failures reach a certain threshold, the circuit breaker trips, and all further calls to the circuit breaker return with an error, without the protected call being made at all. Usually you'll also want some kind of monitor alert if the circuit breaker trips.

Building microservices with Spring Cloud and Netflix OSS

Release it:Design.and.Deploy.Production.Ready.Software

Spring Cloud Circuit Breaker tutorial

Netflix
[Netflix Hystrix] (https://github.com/Netflix/Hystrix)
Netflix Hystrix Dashboard
Run Hystrix Dashboard Docker image
$ docker run -d -p 8080:8080 --name hystrix-dashboard grissomsh/hystrix-dashboard:latest