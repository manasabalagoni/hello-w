#!/bin/bash

set -ev

# This script will be used by Travis CI and will deploy the project to maven, making sure to use the sign and
# build-extras profiles and any settings in our settings file.

echo $TRAVIS_BRANCH;
echo $TRAVIS_COMMIT_DESCRIPTION;
echo $TRAVIS_EVENT_TYPE;
echo $TRAVIS_PULL_REQUEST_BRANCH;
echo $TRAVIS_PULL_REQUEST;

if [[ "$TRAVIS_COMMIT_DESCRIPTION" != *"maven-release-plugin"* ]];then

    if [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST_BRANCH" == "" ];then
        mvn --batch-mode release:clean release:prepare -Dusername=$GITHUB_USERNAME -Dpassword=$GITHUB_PASSWORD
        mvn release:perform --settings travis-ci/settings.xml
    else if [ "$TRAVIS_PULL_REQUEST" != "" ] && [ "$TRAVIS_EVENT_TYPE" == "pull_request" ];then
            mvn org.apache.maven.plugins:maven-release-plugin:2.2.1:stage release:stage --settings travis-ci/settings.xml
        fi
    fi

else
  echo "deploy: Not running deploy mvn commands due to maven-release-plugin auto commit - this is just for preparation for dev/releases";
fi

