#!/bin/bash

echo "Building site..."


hugo

cd public
git add .

msg="Rebuilding site"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..