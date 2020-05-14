*** Settings ***
Metadata    Author          saurash2@cisco.com
Metadata    Executed At     ${DUT}
Metadata    Version         1.0

Library     CXTA
Resource    cxta.robot
Library     String
Library     Collections


#Variables   ../Reference_Data/variables_cxtm_iox.yaml
# Alternatively, set the variable file at run time in the cxta command, for example, cxta -n jobfile_name --variablefile ../Reference_Data/variables_cxtm_iox.yaml
Variables   ../Reference_Data/variables_${DUT}.yaml
# For the above command to work, set the DUT variable at run time in the cxta command, for example, cxta -n jobfile_name --variable DUT:cxtm_iox

#Test Setup       Test Entry
#Test Teardown    Test Exit


*** Variables ***


*** Test Cases ***
GIT Demo Test
    [Documentation]   Test to demo GIT integration with CXTM.

    Log  ${DUT}
    Log  ${test_string}
