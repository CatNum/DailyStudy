  # changeCommit.sh
  git filter-branch -f --commit-filter '
    if [ "GIT_AUTHOR_NAME" = "CatNum" ];
    then
            GIT_AUTHOR_NAME="CatNum";
            GIT_AUTHOR_EMAIL="yxl19991104@gmail.com";
            git commit-tree "$@";
    else
            git commit-tree "$@";
    fi' HEAD
