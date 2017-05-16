# oss 各系统搭建流程
 
## 准备工作

基础环境和服务
  
1. 准备好一定数量的虚拟机节点，安装相应的环境，[docker,docker-compose,docker私有仓库、加速设置]()，ssh访问，网络(k8s需***翻墙***)等等。

2. DNS配置，oss项目使用自定义域名internal,所以需要搭建自己的服务器来服务于项目。查看[DNS服务器搭建](DNS_SERVER.md)
   
    需要配置如下域名(各项目搭建时，有详细说明):

        k8s.internal                        #k8s-server       k8s服务器节点IP  
        k8s.nodex.internal                  #k8s-node x       k8s服务x节点IP  
        gitlab.internal                     #gitlab-server    gitlab服务节点IP
        jenkins.internal                    #jenkins          jenkins服务节点IP
        ldap.internal                       #ldap-server      ldap服务节点IP
        ldapadmin.internal                  #ldap-admin       ldap admin后台，与ldapserver部署在同一服务器，故IP相同 
        nexus.internal                      #nexus3           nexus3服务器节点IP
        mirror.docker.internal              #docker-mirror    nexus3提供的功能 IP同nexus3
        registry.docker.internal            #docker-registry  nexus3提供的功能 IP同nexus3
        fileserver.internal                 #file-server      nexus3提供的功能 IP同nexus3
        mvn-site.infra.internal             #mvn-site-server  nexus3提供的功能 IP同nexus3
        sonarqube.internal                  #sonarqube        sonarqube 节点IP

    **注意**: 搭建过程中每台机器都要配置DNS服务器地址，配置方法在安装文档中。 
   
3. LDAP服务搭建，实现统一的用户管理，查看[LDAP服务器搭建](LDAP_SERVER.md)  

    - [通过访问后台进行管理,全部界面化操作简单明了](http://ldapadmin.internal:6443) 账户信息: cn=admin,dc=internal/admin_pass，比如LDAP创建用户可按照[此文档](LDAP_ADDUSER_BY_LDAPADMIN.md)进行配置。
    - 进入docker容器内部直接使用 `ldapadd` 进行操作，略。

## 业务基础服务

### nexus3 

1. [nexus3安装](NEXUS3.md) 
2. 使用admin/admin123登录后台，[配置LDAP](NEXUS3_LDAP)
3. 默认使用deployment/deployment账户最为maven deploy账户，若要修改秘钥同时需修改oss-internal,maven settings中的内容。


### gitlab-server

1. [gitlab-server安装](GITLAB.md)  //TODO 与外面GITLAB.md的关系。 

2. 项目相关

    gitlab上的服务初始化如下项目

    - oss/oss-internal                     存放项目一些敏感信息，有些需要更新比如***k8s***的配置
   
    gitlab搭建完毕后，可从github引入样例项目

    - oss/oss-jenkins-pipeline             负责jenkins pipeline部署的项目
    - oss/oss-todomvc                      样例项目(引入后需要稍加修改ci.sh脚本，比如 GIT_REPO_OWNER即该项目拥有者需要修改，并且有个约定todomvc等项目要和oss-internal拥有者一致)   
    - oss/oss-todomvc-thymeleaf-config     todomvc-thymeleaf配置
    - oss/oss-todomvc-gateway-config       todomvc-gateway配置
    - oss/oss-todomvc-app-config           todomvc-app配置 
    
### jenkins
    
1. [jenkins搭建](JENKINS.md)
2. [ldap配置](JENKINS_LDAP.md)
3. [jenkins slave搭建](JENKINS_SWARM_SLAVE.md)

### sonarquebe

- [sonarquebe搭建](SONARQUEBE.md)

## rancher + k8s

### rancher

必要：**安装合适的docker版本**，准备环节有说明

1. [rancher github](https://github.com/rancher/rancher)
2. 安装注意事项
   - 版本选择 rancher/server:stable and rancher/server:latest
   - 环境问题 主要是docker的版本
   - 安装 非常简单执行 docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:stable
   - 访问8080端口查看

### k8s

1. [图文基于rancher搭建k8s](K8S_PIC.md)
2. [k8s实战网上教程，基本是官网翻译，只是版本旧些，注意里面的rc已经被rs取代](http://blog.csdn.net/ztsinghua/article/details/52411483)
   
   
### gitlab ci runner 
   
因为项目需要集成测试，所有ci runner部署在k8s中，这样避免了'跨域'访问问题。

- [gitlab-ci-runner k8s环境搭建](GITLAB_CI_RUNNER.md)
   