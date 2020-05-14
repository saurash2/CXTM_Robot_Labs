# 09_lldp_keywords.robot
*** Keywords ***
Verify LLDP Globally
    [arguments]  ${DUT}
    [Documentation]     Verify LLDP Globally Enabled.
    ...
    ...                 Arguments: DUT
    ...
    ...                 Returns: True if enabled and False if not enabled globally
    ...
    ...                 Usage: ${status}=  Verify LLDP Globally  ${DUT}
    ...
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    ${output}=  run "show run | include lldp"
    ${status}=  Run Keyword And Return Status  output contains "lldp"
    [return]  ${status}

Disable or Enable LLDP Globally
    [arguments]  ${DUT}  ${feature_status}  ${LLDP_HOLDTIMER}
    [Documentation]     Enable or Disable LLDP Globally.
    ...
    ...                 Arguments: DUT   enable/disable  hold time
    ...
    ...                 Usage:  Disable or Enable LLDP Globally  ${DUT}  disable/enable  ${LLDP_HOLDTIMER}
    ...
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    run "conf t"
    Run Keyword If  '${feature_status}' == 'enable'  run "lldp holdtime ${LLDP_HOLDTIMER}"
    ...   ELSE   run "no lldp"
    ${output}=  run "commit"
    ${status}=  Run Keyword And Return Status  output contains "Failed to commit"
    Run Keyword If  '${status}' == 'True'  fail
    ...   ELSE   Log  Commit Success
    run "end"
