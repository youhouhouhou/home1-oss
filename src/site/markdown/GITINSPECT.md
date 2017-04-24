
# 各个开发者对项目的贡献

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<big>**通**</big>过gitinspector我们可以分析出每个参与者对项目的贡献和他们重点负责哪部分。

## gitinspector

  Install gitinspector on Mac OSX:
  Need python > 2.6, use `python --version` to check python version.
  Tested on OSX 10.11.6 with python 2.7.12.

    git clone git@github.com:ejwa/gitinspector.git
    cd gitinspector
    git checkout v0.4.4
    
    # for bash
    touch ~/.bashrc
    echo "alias gitinspect='python $(pwd)/gitinspector/gitinspector.py -Tlr --since=2014-01-01'" >> ~/.bashrc
    source ~/.bashrc
    # or
    echo "alias gitinspect='python $(pwd)/gitinspector/gitinspector.py -Tlr --since=2014-01-01'" >> ~/.zshrc
    source ~/.zshrc

  进入某个git repo的目录, 执行`gitinspect`查看.
