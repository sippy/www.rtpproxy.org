#!/bin/sh

set -e

run_hugo() {
  hugo --debug -t herring-cove
}

if [ "${OUR_BRANCH}" != "refs/heads/master" ]
then
  run_hugo
  exit
fi

echo "\033[0;32mDeploying updates to Github...\033[0m"

OWN_REPO="https://${GITHUB_TOKEN}@github.com/sippy/www.rtpproxy.org.git"

git remote add origin_rw "${OWN_REPO}"
#git fetch origin_rw
git clone -b gh-pages --depth 1 "${OWN_REPO}" public
PUB_GIT="git -C public"
#-b ${TMP_BRANCH} origin_rw/${OUR_BRANCH}
# Build the project.
${PUB_GIT} rm -r .
run_hugo

# Add changes to git.
${PUB_GIT} add -A .

NCHG=`${PUB_GIT} diff origin/gh-pages | wc -l`
if [ ${NCHG} -gt 0 ]
then
  # Commit changes.
  msg="rebuilding site `date`"
  if [ $# -eq 1 ]
    then msg="$1"
  fi
  ${PUB_GIT} commit -m "$msg" .

  # Push source and build repos.
  ${PUB_GIT} push
else
  echo "\033[0;32mNothing to do, everything is up to date already.\033[0m"
fi
