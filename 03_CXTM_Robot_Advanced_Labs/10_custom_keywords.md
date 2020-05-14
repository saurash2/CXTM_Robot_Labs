## Lab 10 - Custom Keywords

Robot is a keyword-driven testing framework, making the use and creation of keywords a core functionality. Almost every line of Robot code contains a keyword, which can be built-in to Robot or defined by the user as a custom keyword.



### Task 1 - Creating Custom Keywords

##### Step 1 - Basic Keyword

Keywords are created in the `Keywords` section of your Robot file. They are defined by a keyword name followed by an indented block of Robot code.

> Inside TC10 (Custom Keywords) within your CXTM project, click on `Configure Automation` and put the following code in the file. Create two variables then write a custom keyword that logs those variables:

```
# 12_creating_custom_keywords.robot
*** Variables ***
${hostname}  cxtm_iox
${vendor}  cisco

*** Keywords ***
Log Variables
    Log  ${hostname}
    Log  ${vendor}
```

If you run this Robot file as it is, it won't run since there are no test cases defined. Your keyword need to be run from within test cases.



##### Step 2 - Using Custom Keyword

To run the keyword in a test case, you reference it by the keywords name. This name is case insensitive, so the capitalization of letters doesn't matter. You use custom keywords the same way you use built in keywords.

> Create a test case to run your custom keyword:

```
# 12_creating_custom_keywords.robot
*** Test Cases ***
Run Custom Keyword
    Log variables
```



##### Step 3 - Keyword Arguments

Arguments are values that are passed into the keyword when it is executed. These values are defined using the `[Arguments]` statement.

> Add arguments to pass in each variable to your logging keyword:

```
# 12_creating_custom_keywords.robot
*** Keywords ***
Log Variables
    [Arguments]  ${host}  ${vend}
    Log  ${host}
    Log  ${vend}

*** Test Cases ***
Run Custom Keyword
    Log variables  ${hostname}  ${vendor}
```

Note: the variable names in the line `[Arguments]  ${host}  ${vend}` are different from the variable names in the line `Log variables  ${hostname}  ${vendor}`. The names defined after the `[Arguments]` statement are the names that will be used to reference the values inside the keyword. Outside the keyword you need to use variables that exist in your test case.



##### Step 4 - Return Data From Keyword

Keywords run Robot code and many perform actions without returning a value like the `Log` keyword. In the case that you need your keywords to return a value to your test case, you can use the `[Return]` statement. The value provided to this statement will be returned by the keyword to the test case when it finishes executing. This value needs to be captured in the test case and stored for it to be used throughout the test.

> Write a keyword which extracts the OS from the hostname variable and returns the value:

```
# 12_creating_custom_keywords.robot
*** Settings ***
Library  String

*** Keywords ***
Get Host OS
    [Arguments]  ${host}
    ${os}=  fetch from right  ${host}  _
    [Return]  ${os}
```



##### Step 5 - Storing Keyword Data

There are multiple ways to write your Robot test, keywords should perform a specific action and sometimes its best to have extra functionality in the test case rather than in the keyword itself. Returning values to the test case allow you to use the data from your keyword to write your tests this way.

> Write a test case which stores the return value from the OS keyword, and checks that it is an expected value:

```
# 12_creating_custom_keywords.robot
*** Settings ***
Library  String

*** Test Cases ***
Run OS Keyword
    ${host_os}=  get host os  ${hostname}
    Should be equal as strings  ${host_os}  iox
```



##### Step 6 - Keyword Documentation

The `[Documentation]` statement is used to add a information about your keyword. This is a best practice to not only help you write better code, but it allows others to understand how to use your keyword. At a minimum, your documentation should contain a description of what the keyword does, what arguments it takes it, and what it returns.

> Add documentation to your `Get Host OS` keyword:

```
# 12_creating_custom_keywords.robot
*** Keywords ***
Get Host OS
    [Arguments]  ${host}
    [Documentation]     Returns the OS name from a given hostname
    ...                 Arguments: ${host}
    ...                 Returns: Name of device OS
    ...                 Usage: ${os}=  Get Host OS  ${hostname}
    ...                 Assumptions: hostname is formatted as pod_name and os_name    
    ...                 seperated by an underscore (_)
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    ${os}=  fetch from right  ${host}  _
    [Return]  ${os}
```



##### Step 7 - Keyword Timeout

Another useful Robot feature for keywords is `[Timeout]`. Using this statement, you can define a maximum amount of time for the keyword to run before returning an error. This statement takes in a time and optionally a message to output when the timeout is reached.

> Add a timeout to your `Get Host OS` keyword:

```
# 12_creating_custom_keywords.robot
*** Keywords ***
Get Host OS
    [Arguments]  ${host}
    [Documentation]     Returns the OS name from a given hostname
    ...                 Arguments: ${host}
    ...                 Returns: Name of device OS
    ...                 Usage: ${os}=  Get Host OS  ${hostname}
    ...                 Assumptions: hostname is formatted as pod_name and os_name    
    ...                 seperated by an underscore (_)
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    [Timeout]  1 minute 30 seconds  Get Host OS keyword took longer than 1.5 minutes
    ${os}=  fetch from right  ${host}  _
    [Return]  ${os}
```

In this example, the `Fetch From Right` keyword will execute very quickly so the timeout won't be hit, you could test this out by shortening the time or by adding more time consuming operations in your keyword like connecting to devices.



##### Step 8 - Keyword Teardown

In addition to test case teardown, you can set a keyword to run for keyword teardown. Using the `[Teardown]` feature, you can provide a keyword to run when the custom keyword is finished executing.

> Add a teardown to the `Get Host OS` keyword that logs the `${os}` variable to the console:

```
# 12_creating_custom_keywords.robot
*** Keywords ***
Get Host OS
    [Arguments]  ${host}
    [Documentation]     Returns the OS name from a given hostname
    ...                 Arguments: ${host}
    ...                 Returns: Name of device OS
    ...                 Usage: ${os}=  Get Host OS  ${hostname}
    ...                 Assumptions: hostname is formatted as pod_name and os_name    
    ...                 seperated by an underscore (_)
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    [Timeout]  1 minute 30 seconds  Get Host OS keyword took longer than 1.5 minutes
    ${os}=  fetch from right  ${host}  _
    [Teardown]  Log to console  The Host OS is: ${os}
    [Return]  ${os}
```

Note: The teardown keyword will run if the custom keyword fails. Also, every step of the teardown will execute regardless of previous steps failing.



##### Step 9 - Keyword Tags

Tags can be added to keywords in addition to test cases using the `[Tags]` statement. These tags don't change the test cases or keywords that are executed like the test case tags. These tags are showed in the log file and are used to make documentation.

> Add some tags to the `Get Host OS` keyword:

```
# 12_creating_custom_keywords.robot
*** Keywords ***
Get Host OS
    [Arguments]  ${host}
    [Documentation]     Returns the OS name from a given hostname
    ...                 Arguments: ${host}
    ...                 Returns: Name of device OS
    ...                 Usage: ${os}=  Get Host OS  ${hostname}
    ...                 Assumptions: hostname is formatted as pod_name and os_name    
    ...                 seperated by an underscore (_)
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    [Tags]  facts  os
    [Timeout]  1 minute 30 seconds  Get Host OS keyword took longer than 1.5 minutes
    ${os}=  fetch from right  ${host}  _
    [Teardown]  Log to console  The Host OS is: ${os}
    [Return]  ${os}
```



##### Solution

```
# 12_creating_custom_keywords.robot
*** Settings ***
Library  String

*** Variables ***
${hostname}  cxtm_iox
${vendor}  cisco

*** Keywords ***
Log Variables
    [Arguments]  ${host}  ${vend}
    Log  ${host}
    Log  ${vend}

Get Host OS
    [Arguments]  ${host}
    [Documentation]     Returns the OS name from a given hostname
    ...                 Arguments: ${host}
    ...                 Returns: Name of device OS
    ...                 Usage: ${os}=  Get Host OS  ${hostname}
    ...                 Assumptions: hostname is formatted as pod_name and os_name    
    ...                 seperated by an underscore (_)
    ...                 Author: SVS-Training (SVS-Training@SVS.com)
    [Tags]  facts  os
    [Timeout]  1 minute 30 seconds  Get Host OS keyword took longer than 1.5 minutes
    ${os}=  fetch from right  ${host}  _
    [Teardown]  Log to console  The Host OS is: ${os}
    [Return]  ${os}

*** Test Cases ***
Run Custom Keyword
    Log variables  ${hostname}  ${vendor}

Run OS Keyword
    ${host_os}=  get host os  ${hostname}
    Should be equal as strings  ${host_os}  iox
```
