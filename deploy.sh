#!/bin/sh

set -e

if [ "${TRAVIS_BRANCH}" != "master" ]
then
  echo "Oops, this is not expected to run on anything but master" 1>&2
  exit 1
fi

echo "\033[0;32mDeploying updates to Github...\033[0m"

OWN_REPO="https://${GITHUB_TOKEN}@github.com/sippy/www.rtpproxy.org.git"

git remote add origin_rw "${OWN_REPO}"
git fetch origin_rw
git checkout -b ${TRAVIS_BRANCH} origin_rw/${TRAVIS_BRANCH}
# Build the project.
git rm -r `find public/ -maxdepth 1 \! -name doc`
hugo --debug -t herring-cove

# Add changes to git.
git add -A public

NCHG=`git diff ${TRAVIS_COMMIT} public | wc -l`
if [ ${NCHG} -gt 0 ]
then
  # Commit changes.
  msg="rebuilding site `date`"
  if [ $# -eq 1 ]
    then msg="$1"
  fi
  git commit -m "$msg" public

  # Push source and build repos.
  git push origin_rw ${TRAVIS_BRANCH}
else
  git reset --hard
fi
git subtree push --prefix=public "${OWN_REPO}" gh-pages
