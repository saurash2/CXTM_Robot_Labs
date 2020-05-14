## Lab 12 - Advanced Tasks

In this lab we will look at some advanced use cases in Robot Framework.

### Task 1 - Device Configuration

In this task, we will look at configuring a device in Robot.



##### Step 1 - Create File For Config Keywords

To start, we will create a keyword file to store our configuration keywords.

> Create a file named `config_keywords.robot` on your laptop to store your configuration keywords. You will need to upload it to your `Project Attachments` and also, include the file for Automation with path `/workspace`

```
# config_keywords.robot
*** Keywords ***
# Place Keywords Here

```



##### Step 2 - Create Robot File To Test Keywords

> Inside TC12 (Advanced Tasks) within your CXTM project, click on `Configure Automation` and put the following code in the file

```
# 12_device_configuration.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Resource  /workspace/config_keywords.robot

*** Variables ***
${DUT_IOS}  cxtm_ios
${DUT_XR}  cxtm_iox
```



##### Step 3 - Setup Device Connections

> Setup connection to the NXOS and XR devices:

```
# 12_device_configuration.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Resource  /workspace/config_keywords.robot
Suite Setup  device setup

*** Variables ***
${DUT_IOS}  cxtm_ios
${DUT_XR}  cxtm_iox

*** Keywords ***
Device Setup
    Load testbed
    Connect to devices "${DUT_IOS};${DUT_XR}"
```



##### Step 4 - Create Keyword To Configure ACL

The first configuration keyword we are going to create is called `Configure ACL`. This keyword will take in a list of config commands to define a new ACL. In addition to running the configuration commands, it also checks to ensure the configuration was added successfully.

> Create a keyword named `Configure ACL` in the `config_keywords.robot` file:

```
# config_keywords.robot
*** Keywords ***
Configure ACL
    [Arguments]  @{acl_config}
    [Documentation]     Configure ACL and verify if configuration commit successful or not.
    ...                 This keyword uses along with keyword "commit_fail".
    ...                 If commit fail, output of "show configuration failed" will be logged.
    ...
    ...                 Arguments: acl_config (list)
    ...
    ...                 Returns: n/a
    ...
    ...                 Usage: Configure ACL  ${acl_config}
    ...
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    [Tags]              IOS-XR_Configure_IPv4_ACL
    run "conf t"
    FOR  ${conf}  IN   @{acl_config}
        run "${conf}"
    END
    run "sh config"
    ${output}=  run "commit"
    ${status}=  Run Keyword And Return Status  output contains "Failed to commit"
    Run Keyword If  '${status}' == 'True'  commit_fail
    ...   ELSE   Log  Commit Success
    run "end"
```

Note: This keyword was specifically created to work with an ACL, but the way it functions is very generic. It sends the command "conf t" to enter configuration mode, then enters a list of configuration commands, then finally verifies the change. This same work flow will be seen in the next keyword example, and can be expanded or directly used to make other configuration changes. If you named the keyword, `Send Config Change`, it would function to same but be available for more general use cases.



##### Step 5 - Test ACL Keyword

> Write a test case to run the `Configure ACL` keyword:

```
# 12_device_configuration.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Resource  /workspace/config_keywords.robot
Suite Setup  device setup

*** Variables ***
${DUT_IOS}  cxtm_ios
${DUT_XR}  cxtm_iox

*** Keywords ***
Device Setup
    Load testbed
    Connect to devices "${DUT_IOS};${DUT_XR}"

*** Test Cases ***
Test ACL Keyword
    Use device "${DUT_XR}"
    @{acl_config}=  create list  ipv4 access-list acl_xx  10 permit 172.16.0.0 0.0.255.255
    ...  20 deny 192.168.34.0 0.0.0.255
    Configure ACL  ${acl_config}
```


##### Solution

```
*** Settings ***
Library  CXTA
Resource  cxta.robot
Resource  /workspace/config_keywords.robot
Suite Setup  device setup

*** Variables ***
${DUT_IOS}  cxtm_ios
${DUT_XR}  cxtm_iox

*** Keywords ***
Device Setup
    Load testbed
    Connect to devices "${DUT_IOS};${DUT_XR}"

*** Test Cases ***
Test ACL Keyword
    Use device "${DUT_XR}"
    @{acl_config}=  create list  ipv4 access-list acl_xx  10 permit 172.16.0.0 0.0.255.255
    ...  20 deny 192.168.34.0 0.0.0.255
    Configure ACL  ${acl_config}

```

```
# config_keywords.robot
*** Keywords ***
Configure ACL
    [Arguments]  @{acl_config}
    [Documentation]     Configure ACL and verify if configuration commmit successful or not.
    ...                 This keyword uses along with keyword "commit_fail".
    ...                 If commit fail, output of "show configuration failed" will be logged.
    ...
    ...                 Arguments: acl_config (list)
    ...
    ...                 Returns: n/a
    ...
    ...                 Usage: Configure ACL  ${acl_config}
    ...
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    [Tags]              IOS-XR_Configure_IPv4_ACL
    run "conf t"
    FOR  ${conf}  IN   @{acl_config}
        run "${conf}"
    END
    run "sh config"
    ${output}=  run "commit"
    ${status}=  Run Keyword And Return Status  output contains "Failed to commit"
    Run Keyword If  '${status}' == 'True'  commit_fail
    ...   ELSE   Log  Commit Success
    run "end"
```
