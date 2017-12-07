# DockerForK8s

```console
  借助github访问谷歌docker镜像仓库gcr.io
```  
# Kubeadm 方式在Centos7系统安装K8s

### 步骤列表
1. 一键安装脚本: config/setup/kubeadm.sh
```bash
  Master 节点：
  sh kubeadm.sh $(yourip) master  # $(yourip)地址为master的物理IP地址
```
```bash
  Slave 节点：
  sh kubeadm.sh $(yourip) slave   # $(yourip)地址为master的物理IP地址
```
2. 安装Dashboard: /config/dashboard
```bash
  在master 节点：
  kubectl create -f config/dashboard/    # 指定目录，kubectl会自动创建该目录下的所有文件
```
3. 安装Heapster监控: /config/heapster
```bash
  在master 节点：
  kubectl create -f config/heapster/     # 指定目录，kubectl会自动创建该目录下的所有文件
```
4. 外部使用default的token调用k8s的apiserver API：
```bash
  在master 节点：
  kubectl create -f config/default-rbac.yaml
```
