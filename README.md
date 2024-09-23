# skipped-test-run
Clone the repo in following directory `~/ocs-upi-kvm/scripts/`
Extract the skipped test cases and store in file
- `cat test-ocs-ci.log | grep -B 1 "SKIPPED (Ceph health check failed at setup)" | awk '{print $12}' > test_skipped.txt`

To remove the empty lines 
- `sed -i '/^$/d' test_skipped.txt`

Before run the script change the `OCS_VERSION=4.X` according to your need.

To run the script
- `bash rerun-test.sh <test_case_file_name>`

All the individual test log files are present in following directory
- `~/ocs-upi-kvm/scripts/skipped-test-run/rerun-logs`

After compliting the all the test case execute `test_summary.sh` script for test summary, it will generate the `test_summary.log` file.
- `bash test_summary.sh`
