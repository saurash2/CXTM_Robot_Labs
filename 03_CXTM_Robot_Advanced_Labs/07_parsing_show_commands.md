# Lab 7 - Parsing Show Commands
This lab is an introduction to parsing show commands from network devices. Parsing show commands are helpful because:
1. Having your data in a data structure (list or dictionary) rather than one big string allows you to more precisely reference and compare your data.
2. You can express the relationships and comparisons between specific pieces of data, or against previous iterations of the same data. For example, having a show version output allows you as a human to intuitively read the parts you are interested in, but comparing the state between tests with parsed output allows you to specify to compare just the version value rather than also comparing all the rest of the output.

### Task 1 - Using Regular Expressions (RegEx) to Parse Commands

Regular expressions are incredibly powerful, but can also be incredibly confusing. If you have a strong background in regular expressions, and speak them fluently like a second language, this approach might appeal to you. Otherwise, using regular expressions (RegEx) is probably something you will use on occasion if there is something simple you want to extract out of a larger text block.

The power of regex is that you can quickly extract out any string pattern from a larger string. Think of it as a much more granular and complicated version of CTRL + F you use in most text editors. You can find one occurrence of something, or every occurrence of that pattern. Some common examples might be:
- Find IP Addresses or particular subnets
- Find interface names
- Find a particular ACL
- Find counters or drops in output

In this task you will connect to an IOS-XR network device, issue a show command, and extract out the names of all the interfaces through a regular expression and then count how many interfaces are present.

##### Step 1

In order to get the data you need to extract out the data, you will need to use the `run` keyword with a `show` command.

> Inside TC07 (Parsing Show Commands) within your CXTM project, click on `Configure Automation` and put the following code in the file:

```
# 07_parsing_with_regex.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Library  Collections

*** Variables ***
${command}  show interfaces
${DUT}  cxtm_ios

*** Test Cases ***
Establish Connection
    load testbed
    connect to device "${DUT}"

Verify Number of Interfaces
   use device "${DUT}"
   run "${command}"

```

Run the test suite and ensure it runs the command and view the output.

##### Step 2

Next, you will add a regular expression to extract out the name of the interface, `(\\w+\[\\/\\w+\]\*\[-.:]?\\w+) is \\w+\\s?\\w+, line protocol is \\w+\\s?\\w+`, which in a simple explanation is looking for the pattern we expect to see in an interface statement. Add that regular expression  with the keyword `extract patterns` as you see here in the second test case:


```
# 07_parsing_with_regex.robot
*** Test Cases ***
Verify Number of Interfaces
   use device "${DUT}"
   run "${command}"
   ${interface_list}=  extract patterns "(\\w+\[\\/\\w+\]\*\[-.:]?\\w+) is \\w+\\s?\\w+, line protocol is \\w+\\s?\\w+"
```

Look at the output, check the logs, what do you see?

Note that even though this RegEx is somewhat complicated, they can be much simpler, but you just have to do multiple separate patterns to extract out the specific data you want, rather than making one big complicated pattern.

##### Step 3

The interface names should now be in the `${interface_list}` as a list and so now to get the number of interfaces, you can use the `Get Length` keyword on the list:

```
# 07_parsing_with_regex.robot
*** Test Cases ***
Verify Number of Interfaces
   use device "${DUT}"
   run "${command}"
   ${interface_list}=  extract patterns "(\\w+\[\\/\\w+\]\*\[-.:]?\\w+) is \\w+\\s?\\w+, line protocol is \\w+\\s?\\w+"
   ${len_of_interfaces}=  Get Length  ${interface_list}
```

##### Step 4

Now, as a finishing touch, log the output the the console using the `Log To Console` keyword and also put the same data into the test message using the `Set Test Message` keyword, your final test suite should look like the following:
```
# 07_parsing_with_regex.robot
*** Test Cases ***
Verify Number of Interfaces
   use device "${DUT}"
   run "${command}"
   ${interface_list}=  extract patterns "(\\w+\[\\/\\w+\]\*\[-.:]?\\w+) is \\w+\\s?\\w+, line protocol is \\w+\\s?\\w+"
   ${len_of_interfaces}=  Get Length  ${interface_list}
   Log to console  \n\tTotal #interfaces = ${len_of_interfaces}
   Set test message  \n....... Total #interfaces = ${len_of_interfaces}  append=True
```

Run the test suite and view the output.



##### Solution

```
# 07_parsing_with_regex.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Library  Collections

*** Variables ***
${command}  show interfaces
${DUT}  cxtm_ios

*** Test Cases ***
Establish Connection
    load testbed
    connect to device "${DUT}"

Verify Number of Interfaces
   use device "${DUT}"
   run "${command}"
   ${interface_list}=  extract patterns "(\\w+\[\\/\\w+\]\*\[-.:]?\\w+) is \\w+\\s?\\w+, line protocol is \\w+\\s?\\w+"
   ${len_of_interfaces}=  Get Length  ${interface_list}
   Log to console  \n\tTotal #interfaces = ${len_of_interfaces}
   Set test message  \n....... Total #interfaces = ${len_of_interfaces}  append=True
```



### Task 2 - Output with Run Parsed on IOS and IOS-XR

CXTA has built into it several libraries and tools which do a bunch of heavy lifting behind the scenes. One of those activities happening behind the scenes is the `run parsed` keyword. This keyword uses TextFSM templates stored in the CXTA container system files, and automatically maps the right TextFSM template to the show command you provide as an argument (assuming that particular template exists). This mapping is dependent on not only the name of the show command, such as `show interfaces`, but also the platform being used, as the output format changes per platform and the parsing needs to account for that. Behind the scenes, your testbed file provides this information to CXTA, so that is why it is important to provide accurate information in your testbed file, for example:

```yaml
    custom:
       categories:
       - ios
       - xr
       - asr
       - 9k
```

This defines the device as an IOS-XR, ASR9k, and will map the corresponding correct TextFSM template when `run parsed` is used.

Also note that `nexus` devices do not use the `run parsed` keyword, but the `run parsed json` keyword.

### IOS

##### Step 1

This Test Suite has three test cases, one to connect to the device, one to send a `show version` and one to send a `show version` which will then be parsed for you. The output for each command is stored in a variable and then logged to the screen.

> Inside TC07 (Parsing Show Commands) within your CXTM project, click on `Configure Automation` and put the following code in the file:

```
# 07_parsed_ios.robot
*** Settings ***
Library  Collections
Library  CXTA
Resource  cxta.robot

*** Variables ***
${command_02}  show version
${DUT}  cxtm_ios

*** Test Cases ***
Establish Connection
    load testbed
    connect to device "${DUT}"

Verify Version Raw
    use device "${DUT}"
    ${raw_command}=   run "${command_02}"
    Log  ${raw_command}

Verify Version Parsed
    use device "${DUT}"
    ${parsed_command}=   run parsed "${command_02}"
    Log list  ${parsed_command}
```

##### Step 2

> Run the test suite, and note the attribute for the version which will need to be used. The attribute which needs to be used is the `Version` attribute:

##### Step 3

Now that you know what the data looks like, you can add some simple verification steps in each test case. For the `raw_command` output, use the `output contains ` keyword to check to see if the specific version `15.6(1)T` present in the output.

For the `parsed_command` output, you can specifically reference the attribute in the data structure, in this case it is a Dictionary Key called `Version`. The keyword to use is  `get parsed "${desired_attribute}" where "${attribute}" is "${value}"`. If the `Version` is not `15.6(1)T` it will fail.

> Add Version verification to each test case:
>
> Note: Some versions of IOS will use a lowercase v in the `Version` attribute name.

```
# 07_parsed_ios.robot
*** Test Cases ***
Verify Version Raw
    use device "${DUT}"
    ${raw_command}=   run "${command_02}"
    Log  ${raw_command}
    output contains "15.6(1)T"

Verify Version Parsed
    use device "${DUT}"
    ${parsed_command}=   run parsed "${command_02}"
    Log  ${parsed_command}  console=True  repr=yes
    Log List  ${parsed_command}
    ${version}=  get parsed "Version"
    Should Be Equal  ${version}  15.6(1)T
```

##### Step 4

Since running the command `show version` only returns a single dictionary, instead of a list of dictionaries, the regular dictionary keywords can be used to interact with the data.

> Get the version from the parsed output using the `Get From Dictionary` keyword:

```
# 07_parsed_ios.robot
*** Test Cases ***
Get Version Parsed
	use device "${DUT}"
  ${parsed_command}=   run parsed "${command_02}"
	${version}=  Get From Dictionary  ${parsed_command[0]}  version
	Should Be Equal  ${version}  15.6(1)T
```

Note: In the above example we provide `${parsed_command[0]}` to the `Get From Dictionary` Keyword instead of `${parsed_command}` since the output that is returned from `run parsed` is still a list. Even though there is only a single dictionary in the output, it is wrapped in a list so that first dictionary element must be selected using `[0]`.

##### Solution

```
# 07_parsed_ios.robot
*** Settings ***
Library  Collections
Library  CXTA
Resource  cxta.robot

*** Variables ***
${command_02}  show version
${DUT}  cxtm_ios

*** Test Cases ***
Establish Connection
    load testbed
    connect to device "${DUT}"

Verify Version Raw
    use device "${DUT}"
    ${raw_command}=   run "${command_02}"
    Log  ${raw_command}
    output contains "15.6(1)T"

Verify Version Parsed
    use device "${DUT}"
    ${parsed_command}=   run parsed "${command_02}"
    Log  ${parsed_command}  console=True  repr=yes
    Log List  ${parsed_command}
    ${version}=  get parsed "Version"
    Should Be Equal  ${version}  15.6(1)T

Get Version Parsed
	 use device "${DUT}"
   ${parsed_command}=   run parsed "${command_02}"
	 ${version}=  Get From Dictionary  ${parsed_command[0]}  Version
	 Should Be Equal  ${version}  15.6(1)T
```



### Task 3 - Using a TextFSM Template to Parse Output

A few years back Google created an open-source Python library called TextFSM that takes in CLI text and outputs a data structure (a list of dictionaries). The keys of this data structure and the items which are placed into the values of the dictionaries are defined by a TextFSM parsing template file.

These are useful because they only need to be defined for each show command variation, and then can easily be reused to provide a data structure from a large string output for a legacy device which does not have an API.

In this task you will use a pre-existing TextFSM template to parse data from a show command output.

##### Step 1

> Inside TC07 (Parsing Show Commands) within your CXTM project, click on `Configure Automation` and put the following code in the file:

```
# 07_textfsm.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Library  Collections

*** Variables ***
${command_03}  admin show inventory
${DUT_02}  cxtm_iox

*** Test Cases ***

Establish Connection
    load testbed
    connect to device "${DUT_02}"

Verify Inventory Raw
    use device "${DUT_02}"
    ${raw_command}=   run "${command_03}"
    Log To Console   ${raw_command}
    output contains "IOSXRV"
```

This will give you a good baseline, loading in a IOS-XR device, and issuing a `show inventory` command, without any parsing. Run the test suite to make sure all the syntax is correct.

##### Step 2

Create a file on your laptop called `07_cisco_ios_xr_show_inventory.textfsm`, and put the following TextFSM syntax into it:

```
# 07_cisco_ios_xr_show_inventory.textfsm
Value NAME (.*)
Value DESCR (.*)
Value PID (([\S+]+|.*))
Value VID (.*)
Value SN ([\w+\d+]+)

Start
  ^NAME:\s+"${NAME}",\s+DESCR:\s+"${DESCR}"
  ^PID:\s+${PID}.*,.*VID:\s+${VID},.*SN:\s+${SN} -> Record
  ^PID:\s+,.*VID:\s+${VID},.*SN: -> Record
  ^PID:\s+${PID}.*,.*VID:\s+${VID},.*SN: -> Record
  ^PID:\s+,.*VID:\s+${VID},.*SN:\s+${SN} -> Record
  ^PID:\s+${PID}.*,.*VID:\s+${VID}.*
  ^PID:\s+,.*VID:\s+${VID}.*
  ^.*SN:\s+${SN} -> Record
  ^.*SN: -> Record
```

Upload this file to your `Project Attachment` and enable it to be used for Automation with path `/workspace`


##### Step 3

You will add a test case, below the previous one, which will verify the PID of the device under test. Add a test case to your test suite called `Verify PID Parsed` and use the keyword `run parsed "${command}" with template "/workspace/07_cisco_ios_show_inventory.textfsm"` and store the return value of that keyword into a variable called `${parsed_command}`:

```
# 07_textfsm.robot
*** Test Cases ***
Verify PID Parsed
    use device "${DUT_02}"
    ${parsed_command}=  run parsed "${command}" with template "/workspace/07_cisco_ios_xr_show_inventory.textfsm"

```


Save the file, and run the test suite and view the output.


##### Step 4

Note that it used that TextFSM file to parse the output and provide a data structure from the raw text. Now add an two additional tests to your `Verify PID Parsed` test case, one logging the output with `log list  ${parsed_command}` and another extracting out the value from the `SN` key depending on the value of another key `NAME`.

```
# 07_textfsm.robot
*** Test Cases ***
Verify PID Parsed
    use device "${DUT_02}"
    ${parsed_command}=  run parsed "${command_03}" with template "/workspace/07_cisco_ios_xr_show_inventory.textfsm"
    Log List  ${parsed_command}
    ${serial_number}=   get parsed "SN" where "NAME" is "Chassis"
```

Run the test suite, and view the output.



##### Solution

```
# 07_textfsm.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Library  Collections

*** Variables ***
${command_03}  admin show inventory
${DUT_02}  cxtm_iox

*** Test Cases ***

Establish Connection
    load testbed
    connect to device "${DUT_02}"

Verify Inventory Raw
    use device "${DUT_02}"
    ${raw_command}=   run "${command_03}"
    Log To Console   ${raw_command}
    output contains "IOSXRV"

Verify PID Parsed
    use device "${DUT_02}"
    ${parsed_command}=  run parsed "${command_03}" with template "/workspace/07_cisco_ios_xr_show_inventory.textfsm"
    Log List  ${parsed_command}
    ${serial_number}=   get parsed "SN" where "NAME" is "Chassis"
```



### Task 4 Parsing Raw Text From Devices

There are situations where you will want to extract certain values or check to see if something is present in a certain part of the output, apart from using the `| json` of Nexus or the built in TextFSM parsing of `run parsed ` for IOS/IOS-XR. There are some keywords which can help with these scenarios.

##### Step 1
For some tests you will want to verify that if a value is present on a certain line of text, there should be a corresponding value on the same line. For example for the given `show redundancy` output on IOS-XR:
```
Tue Aug  6 23:05:05.888 UTC
Redundancy information for node 0/RP0/CPU0:
==========================================
Node 0/RP0/CPU0 is in ACTIVE role
Node 0/RP0/CPU0 has no valid partner

Details
--------
Current active rmf state:
    NSR not ready since Standby is not Present

Reload and boot info
----------------------
IN reloaded Mon Jul 22 22:40:21 2019: 2 weeks, 1 day, 24 minutes ago
Active node booted Mon Jul 22 22:40:21 2019: 2 weeks, 1 day, 24 minutes ago

Active node reload
```
In order to verify the intended RP is indeed the active one, you can use the  `values "${arg1}" and "${arg2}" exist on same line` keyword.

##### Step 2
> Inside TC07 (Parsing Show Commands) within your CXTM project, click on `Configure Automation` and put the following code in the file:

```
# 07_raw_parsing.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Variables ***
${command_04}  show redundancy
${DUT_02}  cxtm_iox

*** Test Cases ***
Establish Connection
    load testbed
    connect to device "${DUT_02}"

Verify Active RP
    ${raw_command}=   run "${command_04}"
    Log to console   ${raw_command}
```

Run the test suite and note the `show redundancy` output, looking for the active RP.

##### Step 3

This test case is modelled after an existing community keyword, to illustrate how to use the `...exist on same line` keyword. If you want to make sure a certain state exists, you can verify that two dependent values are present. In this case `0/0/CPU0` is the expected Active RP, and should have the `ACTIVE` value on the same line of output.

Also, we can use the `Check Command "${command}" From Device "${device}" For Regex "${regex}"` keyword to verify that a specific regular expression exists in the output. In this case, we are going to use the regex `\\d\/\\S+\/\\S+` to check for the format of the Node ID.  This keyword will return the value that is matched by the regex if it exists, and will fail the test case if it doesn't exist.

> Look at the `show redundancy` output and update the test case to verify the intended state:

```
# 07_raw_parsing.robot
*** Test Cases ***
Verify Active RP
    ${raw_command}=   run "${command_04}"
    Log to console   ${raw_command}
    Check command "${command_04}" from device "${DUT_02}" for regex "\\d\/\\S+\/\\S+"
    Values "0/0/CPU0" and "ACTIVE" exist on same line
```



##### Solution

```
# 07_raw_parsing.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Variables ***
${command_04}  show redundancy
${DUT_02}  cxtm_iox

*** Test Cases ***
Establish Connection
    load testbed
    connect to device "${DUT_02}"

Verify Active RP
    use device "${DUT_02}"
    ${raw_command}=   run "${command_04}"
    Log to console   ${raw_command}
    Check command "${command_04}" from device "${DUT_02}" for regex "\\d\/\\S+\/\\S+"
    Values "0/0/CPU0" and "ACTIVE" exist on same line
```





## References

**Keywords Learned**
```
Run "${command}"
Run Parsed "${command}"
Output Contains "${string}"
Get Parsed "${desired_attribute}"
Get Parsed "${desired_attribute}" Where "${attribute}" Is "${value}"
Values "${arg1}" And "${arg2}" Exist On Same Line
```
