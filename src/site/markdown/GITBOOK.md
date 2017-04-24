
# 如何构建oss的gitbook

    ./book.sh build
    
    # 预览 http://127.0.0.1:4000
    ./book.sh serve
    
  查看更多命令请执行
    
    ./book.sh help

## 如何使用gitbook

https://github.com/GitbookIO/gitbook
http://toolchain.gitbook.com/pages.html

    # 准备gitbook目录
    cd ~/ws/architecture
    mkdir -p oss/src/gitbook
    cd oss/src/gitbook

    # 写此文档时的环境
    node --version
    v6.2.2
    npm --version
    3.9.5

    npm install gitbook-cli@2.3.0 -g
    gitbook init
    # 生成README.md 和 SUMMARY.md
    
    # Preview and serve your book using:
    gitbook serve
    # Or build the static website using:
    gitbook build
    # Debugging
    gitbook build ./ --log=debug --debug

## 生成PDF等其他格式的电子书

需要安装 `ebook-convert`, 可以到 `https://calibre-ebook.com/` 下载

  Mac用户可以执行 `brew install Caskroom/cask/calibre` 安装, 但前提是你已经安装了 `Homebrew`
