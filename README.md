# skipped-test-run
Clone the repo in following directory `~/ocs-upi-kvm/scripts/`

1. For Skipped tests.
   
Extract the skipped test cases and store in file
```
cat test-ocs-ci.log | grep -B 1 "SKIPPED (Ceph health check failed at setup)" | awk '{print $12}' > test_skipped.txt
```


To remove the empty lines 
```
sed -i '/^$/d' test_skipped.txt
```

2. For the Failed test cases.

Extract the Failed test cases from the log.

# Before Run

- Add the test cases which you want to run individually in `test-cases.log` file.
- eg.
  ```
  - tests/manage/pv_services/test_pvc_assign_pod_node.py::TestPvcAssignPodNode::test_rwo_pvc_assign_pod_node[CephFileSystem]
  - tests/manage/pv_services/test_pvc_assign_pod_node.py::TestPvcAssignPodNode::test_rwx_pvc_assign_pod_node[CephBlockPool]
  - tests/manage/pv_services/test_pvc_assign_pod_node.py::TestPvcAssignPodNode::test_rwx_pvc_assign_pod_node[CephFileSystem]
  ```
## Note 
```
- Please check for the empty spaces at the end of the test case.
- Try to avoid including the empty spaces or empty lines in `test-cases.log` file.
```
## EXECUTION

Before run the script change the varialbe `OCS_VERSION=4.X` from `rerun-test.sh` according to your need.

To run the script
```
bash rerun-test.sh test-cases.log
```

All the individual test log files are present in following directory
```
~/ocs-upi-kvm/scripts/skipped-test-run/rerun-logs
```

After compliting the all the test case execute `test_summary.sh` script for test summary, it will generate the `test_summary.log` file.
- `bash test_summary.sh`
