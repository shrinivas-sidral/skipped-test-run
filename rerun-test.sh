#!/bin/bash
export FILENAME=$1
export OCS_VERSION=4.15
export TIER_NO=1
export FILE_PATH=~/ocs-upi-kvm/scripts/skipped-test-run/
export LOG_DIR=rerun-logs

if [ -z "$FILENAME" ]; then
    echo "No filename passed"
    exit 1
elif [ ! -f "$FILENAME" ]; then
    echo "$FILENAME file not exists"
    exit 1
else
    #read test cases from file
    mkdir -p $FILE_PATH$LOG_DIR
    source ~/venv/bin/activate
    cd ~/ocs-upi-kvm/src/ocs-ci
    while IFS= read -r TEST_CASE
    do
    #str=$(oc -n openshift-storage rsh `oc get pods -n openshift-storage | grep rook-ceph-tools |  awk '{print $1}'` ceph health | tr -d '[:space:]')
    #echo $str
    str=$(oc get cephcluster -n openshift-storage | grep -o HEALTH_OK)
    echo $TEST_CASE

    if [ "$str" = "HEALTH_OK" ];then
        LOG_FILE_NAME=$(awk -F '::' '{print $NF}'<<<"$TEST_CASE" | tr -d '[:space:]')
	size=${#LOG_FILE_NAME}
        if [[ $size -gt 10 ]]; then
        nohup run-ci -m "tier$TIER_NO" --ocs-version $OCS_VERSION --ocsci-conf=conf/ocsci/production_powervs_upi.yaml --ocsci-conf conf/ocsci/lso_enable_rotational_disks.yaml --ocsci-conf /root/ocs-ci-conf.yaml --cluster-name "ocstest" --cluster-path /root/ --collect-logs $TEST_CASE | tee $FILE_PATH$LOG_DIR/$LOG_FILE_NAME.log 2>&1
        
        #delete the executed tests
        escaped_pattern=$(echo "$TEST_CASE" | sed 's/[[]/\\[/g; s/[]]/\\]/g; s/\//\\\//g')
        sed -i "/$escaped_pattern$/d" $FILE_PATH$FILENAME

	    echo "sleep 10 seconds before next test execution"
	    sleep 10 
     else 
     	echo "Please check test case"
      	exit 0
	fi
    else
        echo "exit dua to ceph health issue"
	    echo $TEST_CASE
        exit 0
    fi
    done < <(cat < "$FILE_PATH$FILENAME")
fi
