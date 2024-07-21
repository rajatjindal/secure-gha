#!/bin/bash

gh pr diff 1 -R rajatjindal/secure-gha --name-only > changed-files.txt
cat changed-files.txt
cat config/forbidden-files.txt
echo
echo
for forbidden_file in $(cat config/forbidden-files.txt); do
	echo "file is $forbidden_file"
	grep $forbidden_file changed-files.txt
	if [[ $? -eq "0" ]]; then
		echo "forbidden file $forbidden_file changed"
		## cancel all runs for this branch
		for id in $(gh run list -b check-pr -R rajatjindal/secure-gha --json databaseId | jq '.[].databaseId'); do gh run cancel $id; done;
	fi

	echo
	echo
done;
