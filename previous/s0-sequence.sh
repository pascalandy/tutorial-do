#!/usr/bin/env bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Print a helpful message if a pipeline with non-zero exit code causes the
# script to exit as described above.
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset


step_intro() {
    ### Show this which script is running
    echo "checkpoint SEQ-000 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
    echo; cat ~/temp/provisionninglogs.txt;

    echo "---step_intro is done---"; sleep 2;
}

s97_check() {
    echo "checkpoint SEQ-970 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
    echo; cat ~/temp/provisionninglogs.txt;

    RUN_THIS="s97-check.sh"
    chmod +x $RUN_THIS; ./$RUN_THIS;
    echo "---$RUN_THIS is done---"; sleep 2;
}

step1() {
    echo "checkpoint SEQ-100 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
    echo; cat ~/temp/provisionninglogs.txt;

    RUN_THIS="s1-hardening.sh"
    chmod +x $RUN_THIS; ./$RUN_THIS;
    echo "---$RUN_THIS is done---"; sleep 2;
}

step2() {
    echo "checkpoint SEQ-200 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
    echo; cat ~/temp/provisionninglogs.txt;

    RUN_THIS="s2-main-config.sh"
    chmod +x $RUN_THIS; ./$RUN_THIS;
    echo "---$RUN_THIS is done---"; sleep 2;
}

step3() {
    echo "checkpoint SEQ-300 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
    echo; cat ~/temp/provisionninglogs.txt;
    
    RUN_THIS="s3-ufw.sh"
    chmod +x $RUN_THIS; ./$RUN_THIS;
    echo "---$RUN_THIS is done---"; sleep 2;
}

step4() {
    echo "checkpoint SEQ-400 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
    echo; cat ~/temp/provisionninglogs.txt;

    RUN_THIS="s4-swarm.sh"
    chmod +x $RUN_THIS; ./$RUN_THIS;
    echo "---$RUN_THIS is done---"; sleep 2;
}

step5() {
    echo "checkpoint SEQ-990 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
    echo; cat ~/temp/provisionninglogs.txt;

    RUN_THIS="s99-reboot.sh"
    chmod +x $RUN_THIS; ./$RUN_THIS;
    echo "---$RUN_THIS is done---"; sleep 2;
}

main() {
    step_intro
        #intro

    s97_check
        #
    #step1
        #s1-hardening
        #issue https://github.com/konstruktoid/hardening/issues/5#issuecomment-327035568
    step2
        #s2-main-config
    step3
        #s3-ufw
    step4
        #s4-swarm
    step5
        #reboot
}

main "$@"