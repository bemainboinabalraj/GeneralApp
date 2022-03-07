#!/bin/bash

for delbranch in $(git branch -r | sed 's/origin\///' | grep -v "master" | grep -v "qa-release" | grep -v "develop"); do 
  if [ -z "$(git log -1 --since='2 week ago' -s $delbranch)" ]; then
    	git push origin -d $delbranch
  fi
done
