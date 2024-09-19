#!/bin/bash
while :
do
str=$(oc -n openshift-storage rsh `oc get pods -n openshift-storage | grep rook-ceph-tools |  awk '{print $1}'` ceph health | tr -d '[:space:]')
if [ $str == "HEALTH_OK" ]
then
	echo "Ceph health the is $str"
        sleep 30
else
	echo $str 	
    # ceph crash archive
 echo "#######  ceph crash ls  #######";echo; oc -n openshift-storage rsh `oc get pods -n openshift-storage | grep rook-ceph-tools |  awk '{print $1}'` ceph crash ls; echo
    echo "#######  ceph crash archive  #######";echo; oc -n openshift-storage rsh `oc get pods -n openshift-storage | grep rook-ceph-tools |  awk '{print $1}'` ceph crash archive-all; echo
    echo sleep for 180 seconds
    sleep 180
fi

done

