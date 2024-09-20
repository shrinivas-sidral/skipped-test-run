export LOG_DIR=~/ocs-upi-kvm/scripts/rerun-logs/
export INDIVIDUAL_TEST_SUMMARY=~/ocs-upi-kvm/scripts/test_summary.log
export PASS=0
export FAIL=0
export ERR=0
export SKIP=0

test_summary() {
    if [ -d "$LOG_DIR" ]; then     
	    echo "=========================== short test summary info ============================" | tee "$INDIVIDUAL_TEST_SUMMARY"
        # LOOP to fetch all log files in log dir
        for logfile in "$LOG_DIR"*.log; do
           temp=$1

           #check passed test cases
            if [[ $(tail -n 2 $logfile | grep -o passed) == "passed" ]]; then
                keyword=$(echo "$logfile" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')
                ptc=$(grep -i -F $keyword $logfile | tail -n 1)
                echo "PASSED $ptc" | tee -a "$INDIVIDUAL_TEST_SUMMARY"
                #pass count for summary
                ((PASS++))

            #check failed test cases
            elif [[ $(tail -n 2 $logfile | grep -o failed) == "failed" ]]; then
                tail -n 2 $logfile | grep -v -B 1 failed | tee -a "$INDIVIDUAL_TEST_SUMMARY"
                #fail count for summary
                ((FAIL++))
            #check error test cases
            elif [[ $(tail -n 2 $logfile | grep -o error) == "error" ]]; then
                tail -n 2 $logfile | grep -v -B 1 error | tee -a "$INDIVIDUAL_TEST_SUMMARY"
                #fail count for summary
                ((ERR++))

            #if not pass or fail found then considered as skipped test
            else
                keyword=$(echo "$logfile" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')
                stc=$(grep -i -F $keyword $logfile | tail -n 1)
                echo "SKIPPED $stc" | tee -a "$INDIVIDUAL_TEST_SUMMARY"
                ((SKIP++))
            fi
        done
	echo "=======================$FAIL failed, $PASS passed, $SKIP skipped, $ERR errors=========================" | tee -a "$INDIVIDUAL_TEST_SUMMARY"
              
    # exit if logs directory not exist.
    else
        echo "$LOG_DIR does not exist."
    fi
}

test_summary

