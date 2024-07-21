#!/bin/bash

gh pr diff 1 -R rajatjindal/secure-gha --name-only > changed-files.txt
echo "changed files:"
cat changed-files.txt
echo
echo

echo "safelisted files"
cat config/safelisted-files.txt
echo
echo
for allowed_file in $(cat config/safelisted-files.txt); do
	sed '/$allowed_file/!d' changed-files.txt
done
echo
echo
echo "changed files after ignoring safelisted files"
cat changed-files.txt
echo
echo
for changed_file in $(cat changed-files.txt); do
	echo $changed_file
done
