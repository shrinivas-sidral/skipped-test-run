#!/bin/bash
export FILENAME=$1
export OCS_VERSION=4.15
export TIER_NO=1

cp  $FILENAME ~/ocs-upi-kvm/src/ocs-ci
if [ -z "$FILENAME" ]; then
    echo "No filename passed"
    exit 1
elif [ ! -f "$FILENAME" ]; then
    echo "$FILENAME file not exists"
    exit 1
else
    #read test cases from file
    mkdir -p ~/ocs-upi-kvm/src/ocs-ci/rerun-logs
    source ~/venv/bin/activate
  cd ~/ocs-upi-kvm/src/ocs-ci
    while IFS= read -r TEST_CASE
    do
    #str=$(oc -n openshift-storage rsh `oc get pods -n openshift-storage | grep rook-ceph-tools |  awk '{print $1}'` ceph health | tr -d '[:space:]')
    #echo $str
    str=$(oc get cephcluster -n openshift-storage | grep -o HEALTH_OK)
    echo $TEST_CASE

    if [ "$str" = "HEALTH_OK" ];then
        LOG_FILE_NAME=$(awk -F '::' '{print $NF}'<<<"$TEST_CASE")
   #     echo "$SR_NO -- $TEST_CASE" >> test-rerun-commands.txt
       nohup run-ci -m "tier$TIER_NO" --ocs-version $OCS_VERSION --ocsci-conf=conf/ocsci/production_powervs_upi.yaml --ocsci-conf conf/ocsci/lso_enable_rotational_disks.yaml --ocsci-conf /root/ocs-ci-conf.yaml --cluster-name "ocstest" --cluster-path /root/ --collect-logs $TEST_CASE | tee rerun-logs/$LOG_FILE_NAME.log 2>&1
	echo "sleep 10  before next test execution"
	sleep 10 
    else
        echo "exit dua to ceph health issue"
	    echo $TEST_CASE
        exit 0
    fi
    done < <(cat < "$FILENAME")
fi
