# skipped-test-run

Extract the skipped test cases and store in file
- `cat test-ocs-ci.log | grep -B 1 "SKIPPED (Ceph health check failed at setup)" | awk '{print $12}' > temp.txt
`

to remove the empty lines 
- `sed -i '/^$/d' temp.txt`
