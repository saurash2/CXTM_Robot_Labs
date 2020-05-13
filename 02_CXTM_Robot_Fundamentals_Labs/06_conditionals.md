## Lab 6 - Conditionals

### Task 1 - Conditional Logic

Conditionals are a core part of testing, they are used to determine whether or not a test is in an expected state. There are many keywords in the core Robot libraries that perform conditional checks.



##### Step 1

We've seen examples of these keywords before, like the `Should Start With` keyword which checks if a substring exists at the beginning of a string. This is running to check that condition and the test case fails if it is not true, but what if you want to check if a substring doesn't exist in the beginning of a string. You can use the keyword `Run Keyword And Expect Error` to run a check and not fail the test case if it doesn't pass. This keyword takes in an expected error, a keyword to run, and the arguments for that keyword.

> Inside TC06 (Conditionals) within your CXTM project, click on `Configure Automation` and create test cases testing a condition and its reverse using the `Run Keyword And Expect Error` keyword:

```
# 06_conditional_logic.robot
*** Test Cases ***
Boolean Check - Starts With True
    Should start with  Ethernet2/4  Eth

Boolean Check - Starts With False
    Run keyword and expect error  *  should start with  Ethernet2/4  eth

```



##### Step 2

You can write your own conditionals using boolean expressions, this can be done with the `Run Keyword If` keyword. This keyword takes in a boolean expression, a keyword to run if it evaluates to true, and arguments for that keyword. You can also add an `ELSE` statement to run an alternative keyword if the boolean expression evaluates to false.

> Write a conditional using the keyword `Run Keyword If` and a boolean expression:

```
# 06_conditional_logic.robot
*** Variables ***
${hostname}  nxos-spine1

*** Test Cases ***
Basic Conditional
    Run keyword if  '${hostname}' == 'nxos-spine1'  Log  Correct Hostname
    ...    ELSE  Log  Incorrect Hostname
```



##### Step 3

One use of conditionals is to match values, to check if a variable has a specific value to change the type of test that will be run. The following example only shows the `Log` keyword being used, but this structure could be used to run different tests based on the requirements of different operating systems.

> Test the following example:

```
# 06_conditional_logic.robot
*** Test Cases ***
Matching Values
    ${os}=  Set Variable  nxos
    Run keyword if  '${os}' == 'nxos'  Log  NXOS
    Run keyword if  '${os}' == 'ios'  Log  IOS
```



##### Step 4

Another example of a conditional keyword available in the core libraries is the `List Should Contain Value` keyword from the `Collections` library.

> Verify that an element is in a list using a conditional keyword:

```
# 06_conditional_logic.robot
*** Settings ***
Library  Collections

*** Variables ***
@{platforms}  nexus  catalyst  asa  csr  aci

*** Test Cases ***
Check If catalyst in platforms List
    List should contain value  ${platforms}  catalyst
```



##### Step 5

> Modify your test case from step 4 to verify that multiple elements exist in a list:

```
# 06_conditional_logic.robot
*** Variables ***
@{supported_platforms}  nexus  catalyst

*** Test Cases ***
Check That All Supported Platforms are in platforms List
    FOR  ${platform}  IN  @{supported_platforms}
       List should contain value  ${platforms}  ${platform}
    END
```

This above example can be accomplished using a for loop or a keyword from the collections library. Above shows the use of a for loop, you can try completing this with the keyword as well.



##### Step 6

When writing conditionals, you don't need to have a separate line to get values from a dictionary using a keyword. You can use what's referred to as "dot" notation to access dictionary values by key.

> Go through the below example, you can replace the "dot" notation with dictionary keywords to get used to the difference:

```
# 06_conditional_logic.robot
*** Test Cases ***
Check Value While Looping
    &{vlan10}=  Create Dictionary  name=web  id=10
    &{vlan20}=  Create Dictionary  name=app  id=20
    &{vlan30}=  Create Dictionary  name=db  id=30
    @{vlans}=  Create List  ${vlan10}  ${vlan20}  ${vlan30}

    FOR  ${vlan}  IN  @{vlans}
       Run keyword if  20 == ${vlan.id}  Log  Vlan Name: ${vlan.name}
    END
```



##### Solution

```
# 06_conditional_logic.robot
*** Settings ***
Library  Collections

*** Variables ***
${hostname}  nxos-spine1
@{supported_platforms}  nexus  catalyst
@{platforms}  nexus  catalyst  asa  csr  aci

*** Keywords ***
Check Platform
    [Arguments]  ${platform}
    List should contain value  ${platforms}  ${platform}

*** Test Cases ***
Boolean Check - Starts With True
    Should start with  Ethernet2/4  Eth

Boolean Check - Starts With False
    Run keyword and expect error  *  should start with  Ethernet2/4  eth

Basic Conditional
    Run keyword if  '${hostname}' == 'nxos-spine1'  Log  Correct Hostname
    ...    ELSE  Log  Incorrect Hostname

Matching Values
    ${os}=  Set Variable  nxos
    Run keyword if  '${os}' == 'nxos'  log  NXOS
    Run keyword if  '${os}' == 'ios'  log  IOS

Check If catalyst in platforms List
    List should contain value  ${platforms}  catalyst

Check That All Supported Platforms are in platforms List
    FOR  ${platform}  IN  @{supported_platforms}
       List should contain value  ${platforms}  ${platform}
    END

Check Value While Looping
    &{vlan10}=  Create Dictionary  name=web  id=10
    &{vlan20}=  Create Dictionary  name=app  id=20
    &{vlan30}=  Create Dictionary  name=db  id=30
    @{vlans}=  Create List  ${vlan10}  ${vlan20}  ${vlan30}

    FOR  ${vlan}  IN  @{vlans}
       Run keyword if  20 == ${vlan.id}  Log  Vlan Name: ${vlan.name}
    END
```



### Task 2 - Dynamic Testing

Writing some tests will rely on dynamic data, like data from your device inventory, so you need a way to modify your tests depending on your data.



##### Step 1

To start, we need to define some variables to test with. We will define several devices, and list their facts in a dictionary. Also we will be including the `Collections` library to make it easier to work with these dictionaries.

> Define some devices and import the `Collections` library:

```
# 06_dynamic_testing.robot
*** Settings ***
Library  Collections

*** Variables ***
&{device_1_facts}  os=nxos  platform=nexus  vendor=cisco  hostname=sw01  location=nyc  device_type=switch
&{device_2_facts}  os=nxos  platform=nexus  vendor=cisco  hostname=sw02  location=nyc  device_type=switch
&{device_3_facts}  os=ios  platform=catalyst  vendor=cisco  hostname=rt01  location=nyc  device_type=router
```



##### Step 2

To make it easier to loop through our devices, we are going to add them all to a single list. Nested data structures will be discussed in more detail later, for this example you just need to know that dictionaries can be stored in lists the same way other data types can be.

> Define a list containing the device facts dictionaries:

```
# 06_dynamic_testing.robot
*** Variables ***
@{devices}  ${device_1_facts}  ${device_2_facts}  ${device_3_facts}
```



##### Step 3

We are writing a test case to send a command to our devices, this command has a different syntax depending on the OS of the device so we will need to use a conditional. Using a for loop to iterate over all of the devices, we will retrieve the OS of the device and then use the `Run Keyword If` keyword to change the test based on the OS.

> Write a test case with the given specifications:

```
# 06_dynamic_testing.robot
*** Test Cases ***
Run OS Specific Command
	FOR  ${device}  IN  @{devices}
           Run keyword if  '${device.os}' == 'nxos'  Log  Device OS: nxos
           Run Keyword If  '${device.os}' == 'iosxe'  Log  Device OS: iosxe
           Run keyword if  '${device.os}' == 'iosxr'  Log  Device OS: iosxr
	END
```



##### Solution

```
# 06_dynamic_testing.robot
*** Settings ***
Library  Collections

*** Variables ***
&{device_1_facts}  os=nxos  platform=nexus  vendor=cisco  hostname=Pod0X-N9Kv  device_type=switch
&{device_2_facts}  os=iosxe  platform=nexus  vendor=cisco  hostname=Pod0X-CSRv device_type=switch
&{device_3_facts}  os=iosxr  platform=catalyst  vendor=cisco  hostname=Pod0X-XRv  device_type=switch
@{devices}  ${device_1_facts}  ${device_2_facts}  ${device_3_facts}

*** Test Cases ***
Run OS Specific Command
	FOR  ${device}  IN  @{devices}
          Run keyword if  '${device.os}' == 'nxos'  Log  Device OS: nxos
          Run Keyword If  '${device.os}' == 'iosxe'  Log  Device OS: iosxe
          Run keyword if  '${device.os}' == 'iosxr'  Log  Device OS: iosxr
	END

```



### Task 3 - Loop Conditionals

There are built in keywords that are helpful for running loops, allowing you to exit or skip iterations when certain conditions are met.



##### Step 1

The `Exit For Loop If` keyword will stop executing a for loop and continue executing the rest of the test if a condition evaluates to true.

> Exit a for loop early when an IP address is found:

```
# 06_loop_conditionals.robot
*** Variables ***
@{ip_addrs}  1.1.1.1  2.2.2.2  3.3.3.3  4.4.4.4  5.5.5.5
${target_ip}  3.3.3.3

*** Test Cases ***
Log IP Addresses To Console
    FOR  ${ip_addr}  IN  @{ip_addrs}
        Log To Console  ${ip_addr}
        Exit For Loop If  '${ip_addr}' == '${target_ip}'
    END

```



##### Step 2

`Continue For Loop If` will stop the current run of the loop and jump to the next iteration when a condition evaluates to true.

> Skip flagged IP addresses when running a test:

```
# 06_loop_conditionals.robot
*** Variables ***
@{blacklist_ip_addrs}  2.2.2.2  4.4.4.4

*** Test Cases ***
Run Test Against Devices
    FOR  ${ip_addr}  IN  @{ip_addrs}
        ${check_result}=  Run keyword and return status  should not contain any  ${ip_addr}  @{blacklist_ip_addrs}
        Continue for loop if  ${check_result}
        Log to console  Testing Device: ${ip_addr}    # Run Test
    END

```



##### Solution

```
# 06_loop_conditionals.robot
*** Variables ***
@{ip_addrs}  1.1.1.1  2.2.2.2  3.3.3.3  4.4.4.4  5.5.5.5
${target_ip}  3.3.3.3
@{blacklist_ip_addrs}  2.2.2.2  4.4.4.4

*** Test Cases ***
Log IP Addresses To Console
    FOR  ${ip_addr}  IN  @{ip_addrs}
        Log To Console  ${ip_addr}
        Exit For Loop If  '${ip_addr}' == '${target_ip}'
    END

Run Test Against Devices
    FOR  ${ip_addr}  IN  @{ip_addrs}
        ${check_result}=  Run keyword and return status  should not contain any  ${ip_addr}  @{blacklist_ip_addrs}
        Continue for loop if  ${check_result}
        Log to console  Testing Device: ${ip_addr}    # Run Test
    END

```
