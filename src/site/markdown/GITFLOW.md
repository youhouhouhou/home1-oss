
# oss的分支模型

为了使协作更有序, 需要团队中的所有人以同一种模式使用版本控制系统, 以避免发生冲突或破坏仓库内容.  

我们使用gitflow作为版本控制模型.  
[gitflow必看文档](http://nvie.com/posts/a-successful-git-branching-model/)

具体执行时使用[gitflow-maven-plugin](https://github.com/KimJejun/gitflow-maven-plugin), 
下面介绍发布版本, 紧急修复一个bug, 开发一个新功能时需要做什么, 如何使用gitflow插件, 
以及gitflow插件帮我们做了什么, 还有什么是我们需要自己手动做的.

#### 发布版本(release)

从develop分支创建release分支, 使用release版本号更新pom(s)

    # 确保没有未提交的修改
    mvn gitflow:release-start
    # 检查所有出现版本号的位置是否被正确修改

将release分支merge到master, 使用develop版本号更新pom(s), 将release分支merge到develop, 删除release分支

    # 可选的 mvn clean install [deploy]
    # 确保全部测试通过, 否则无法release-finish
    mvn gitflow:release-finish
    # 检查所有出现版本号的位置是否被正确修改
    git push origin develop:develop
    # 可选的 触发ci发布新版本
    git push origin master:master
    # 可选的 触发ci发布新版本

#### 紧急修复一个bug(hotfix)

从master分支创建hotfix分支, 使用hotfix版本号更新pom(s)

    # 确保没有未提交的修改
    mvn gitflow:hotfix-start
    # 检查所有出现版本号的位置是否被正确修改
    # 进行开发
    # 提交所有未提交的修改

将hotfix分支merge到master, 使用之前的版本号更新pom(s) 这里有问题下文详述, 将hotfix分支merge到develop 这里有问题下文详述, 删除hotfix分支

    # 可选的 mvn clean install [deploy]
    mvn gitflow:hotfix-finish
    # 选择要完成的hotfix分支(可以同时有多个hotfix)
    # 会发生pom冲突或其它冲突
    # pom冲突主要是因为hotfix分支来自于master上最后一个release, develop分支的版本号在最后一个release之后增加了.
    # 详见issue: https://github.com/aleksandr-m/gitflow-maven-plugin/issues/19
    # 编写此文档时这个问题还没有解决办法
    # 手动处理冲突
    # 检查所有出现版本号的位置是否被正确修改
    # git add .
    # git commit -m 'resolve conflicts on merge'
    # git branch -d hotfix/<填写版本号>
    git push origin develop:develop
    # 可选的 触发ci发布新版本
    git push origin master:master
    # 可选的 触发ci发布新版本

#### 开发一个新功能(feature)

从develop分支创建feature分支, 使用之前的版本号更新pom(s), 可选择更新或不更新版本号, 默认使用feature名字更新版本号更新pom(s)

    # 确保没有未提交的修改
    mvn gitflow:feature-start
    # 输入feature名称
    # 检查所有出现版本号的位置是否被正确修改
    # 进行开发
    # 提交所有未提交的修改

将feature分支merge到develop分支, 使用之前的版本号更新pom(s), 删除feature分支

    mvn gitflow:feature-finish
    # 选择要完成的feature名称(可以同时有多个feature)
    # 检查所有出现版本号的位置是否被正确修改
    git push origin develop:develop
    # 可选的 触发ci发布新版本

#### 更多参考资料

[painless-maven-project-releases-with-maven-gitflow-plugin](http://george-stathis.com/2013/11/09/painless-maven-project-releases-with-maven-gitflow-plugin/)  
[maven-git-flow-plugin-for-better-releases](http://blogs.atlassian.com/2013/05/maven-git-flow-plugin-for-better-releases/)  
[git-flow插件官方网站](http://jgitflow.bitbucket.org/)  
[conflict-free-git-trees](https://stanfy.com/blog/conflict-free-git-trees-part-1/)


## 为什么不使用官方的maven-release-plugin
[maven-release-plugin与git之间的问题](http://stackoverflow.com/questions/29120076/maven-and-gitlab-releaseprepare-uses-the-wrong-scm-url)
