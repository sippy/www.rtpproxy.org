#!/bin/sh

echo -e "\033[0;32mDeploying updates to Github...\033[0m"

OWN_REPO="https://${GITHUB_TOKEN}@github.com/sippy/www.rtpproxy.org.git"

# Build the project.
hugo -t herring-cove

# Add changes to git.
#git add -A

NCHG=`git diff public | wc -l`
if [ ${NCHG} -gt 0 ]
then
  # Commit changes.
  msg="rebuilding site `date`"
  if [ $# -eq 1 ]
    then msg="$1"
  fi
  git commit -m "$msg" public
  git remote add origin_rw "${OWN_REPO}"

  # Push source and build repos.
  git push origin_rw master
fi
git subtree push --prefix=public "${OWN_REPO}" gh-pages
