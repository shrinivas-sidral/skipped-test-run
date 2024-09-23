# skipped-test-run

Extract the skipped test cases and store in file
- `cat test-ocs-ci.log | grep -B 1 "SKIPPED (Ceph health check failed at setup)" | awk '{print $12}' > test_skipped.txt
`

to remove the empty lines 
- `sed -i '/^$/d' test_skipped.txt`

to run the script
- `script.sh <test_case_file_name>`
