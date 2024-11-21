#!/bin/sh

## 1. 执行rename.sh （windows 下可以在 git bash 里面执行）
## 2. 通过 git log 查看是否已修改完毕
## 3. 同步远程仓库 git push origin --force --all

git filter-branch -f --env-filter '

OLD_EMAIL="1660470561@qq.com"
OLD_NAME="anini"
CORRECT_NAME="CatNum"
CORRECT_EMAIL="yxl19991104@gmail.com"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ] || [ "$GIT_COMMITTER_NAME" = "$OLD_NAME" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi

if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ] || [ "$GIT_AUTHOR_NAME" = "$OLD_NAME" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi

' -- --branches --tags
