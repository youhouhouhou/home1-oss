# oss fork开发文档

## Overview
在团队协作进行oss项目开发时，我们采用fork原工程，提交merge request的方式进行。本文档以fork工程`oss-lib`为例，来说明这种方式的具体操作流程。

## 具体步骤
 * 在gitlab中原项目点击fork，fork到自己的空间下
 * 克隆fork的项目到本地
 * 使用gitflow进行开发
 * 在feature分支上进行业务开发
 * 开发完成后，使用gitflow结束业务开发
 * 将代码push到自己的远端gitlab仓库
 * 创建远端fork项目到原项目的merge request

## fork工程同步
在fork项目后，需要我们不定期得将原项目的代码合并到fork的项目中，具体操作如下：
 * clone fork出来的项目到本地
  
  `git clone git@gitlab.internal:username/oss-lib.git`
 * 进入项目

  `cd oss-lib`
 * 添加源remote，命名为`upstream`

  `git remote add upstream git@gitlab.internal:home1-oss/oss-lib.git`
 * fetch源项目的所有分支代码

  `git fetch upstream`
 * 本地切换回初始分支`develop`

  `git checkout develop`
 * rebase 源`upstream`的`develop`分支到本项目的`develop`分支

  `git rebase upstream/develop`
通过以上步骤，就可以使得fork项目的develop分支与源项目的同一分支保持一致。

## git fork示意图
  ![intellij-maven-runner.png](images/git_fork.png)
