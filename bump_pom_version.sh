 #!/bin/bash

 function bumpversion(){
        CURRENT_VERSION=`mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | egrep '^[0-9\.]*$'`
        local VERSION_VALUE=`echo ${CURRENT_VERSION} | sed -e 's/[^0-9][^0-9]*$//'`
        local CURRENT_BUILD_NUMBER=`echo ${VERSION_VALUE} | sed -e 's/[0-9]*\.//g'`
        local NEXT_BUILD_NUMBER=`expr ${CURRENT_BUILD_NUMBER} + 1`
        NEXT_PROJECT_VERSION=`echo ${CURRENT_VERSION} | sed -e "s/[0-9][0-9]*\([^0-9]*\)$/${NEXT_BUILD_NUMBER}/"`
 }

 function updatePomToNextVersion() {
         echo "Updating project version to [${NEXT_PROJECT_VERSION}]..."
         mvn org.codehaus.mojo:versions-maven-plugin:1.3.1:set -DgenerateBackupPoms=false -DnewVersion=${NEXT_PROJECT_VERSION}
 }

 function pushpomversionchanges() {
        echo "Preparing updated files for commit..."
        git status
        for POM in `find . -name pom.xml` ; do
    		git add ${POM}
    		echo "   - ${POM}"
  	done
        echo "Committing changes..."
        local COMMIT_MESSAGE="Auto commit from CI - incremented build number from [${CURRENT_VERSION}] to [${NEXT_PROJECT_VERSION}]."
        git commit -m "${COMMIT_MESSAGE}"
        echo "Pushing changes to origin..."
        git push origin
 }
 function generateartifactpfile() {
	zip generalartifactapp-${NEXT_PROJECT_VERSION}.zip *
 }
bumpversion
updatePomToNextVersion
pushpomversionchanges
generateartifactpfile
