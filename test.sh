#!/bin/bash

release=v0.1.0

gh pr diff 1 -R cloudpremise/secure-gha --name-only > changed-files.txt
echo "changed files:"
cat changed-files.txt
echo
echo

echo "safelisted files"
cat config/safelisted-files.txt
echo
echo
for changed_file in $(cat changed-files.txt); do
	grep $changed_file config/safelisted-files.txt 2>&1 >/dev/null
	if [[ $? -eq "0" ]]; then
		echo "file $changed_file is safelisted for keywords check"
		continue
	fi

	for keyword in $(cat config/forbidden-keywords.txt); do
		echo "checking for keyword $keyword"
		grep $keyword $changed_file
		if [[ $? -eq "0" ]]; then
			echo "$changed_file has forbidden keywords"
			## cancel all runs for this branch
			for id in $(gh run list -b check-pr -R cloudpremise/secure-gha --json databaseId | jq '.[].databaseId'); do gh run cancel $id; done;
		fi
	done
done
