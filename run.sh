#!/bin/sh
set -e
set +o pipefail

patch=`echo $WERCKER_GIT_TAG_COMMIT_MESSAGE| grep -w -Eo "[0-9]+\.[0-9]+\.[0-9]+" | head -n1`
version=`echo $WERCKER_GIT_TAG_COMMIT_MESSAGE| grep -w -Eo "[0-9]+\.[0-9]+" | head -n1`

if [ -n "$patch" ]; then
   tag=$patch
   echo "Apply tag $tag to commit $WERCKER_GIT_TAG_COMMIT_COMMIT"
else
   if [ -n "$version" ]; then
      tag=$version
      echo "Apply tag $tag to commit $WERCKER_GIT_TAG_COMMIT_COMMIT"
   else
      echo "No version/patch found"
      exit
   fi
fi

git config --global user.email email@wercker.com
git config --global user.name wercker

rm -rf /tmp/$WERCKER_GIT_TAG_COMMIT_REPOSITORY
mkdir -p /tmp/$WERCKER_GIT_TAG_COMMIT_REPOSITORY
cd /tmp/$WERCKER_GIT_TAG_COMMIT_REPOSITORY

git clone -b $$WERCKER_GIT_TAG_COMMIT_BRANCH git@github.com:$WERCKER_GIT_TAG_COMMIT_USER/$WERCKER_GIT_TAG_COMMIT_REPOSITORY.git .
git tag $tag $WERCKER_GIT_TAG_COMMIT_COMMIT
git push origin --tags
rm -rf /tmp/$WERCKER_GIT_TAG_COMMIT_REPOSITORY
