## Lab 15 - Debugging and Challenge

Debugging is the process of fixing errors in a program. In this lab we will cover many common errors so you will have an idea how to interpret error messages and resolve the errors. As you get more experience using Robot Framework, these errors will become more familiar to you allowing you to quickly fix them.



### Task 1 - Debugging Robot

##### Step 1 - Invalid Section Name

The first type of error we will look at is an invalid section name. The four sections we have seen so far are `Settings`, `Variables`, `Keywords`, and `Test Cases`. In the below Robot file, we have misspelled the `Settings` section name, instead naming it `Setings`.

> Inside TC15 (Debugging Challenge) within your CXTM project, click on `Configure Automation` and put the following code in the file. Run it and view the error in the log.html file:

```
# 15_debugging_robot.robot
*** Setings ***
Library  Strings

*** Test Cases ***
Placeholder
    Log to console Placeholder Test Case Start
    ${message_one}=  Hello
    ${message_two}=  World!
    Log  catenate  SEPERATOR=" "  ${message_one}  ${message_two}
```

Error Message: `Error in file '/tmp/jobfile.robot': Unrecognized table header 'Setings'. Available headers for data: 'Setting(s)', 'Variable(s)', 'Test Case(s)', 'Task(s)' and 'Keyword(s)'. Use 'Comment(s)' to embedded additional data.`

This error message points out which file the error is found in, the type of error, and some helpful information about fixing it. The error is a `Unrecognized table header` error, which tells us that our section `Setings` is invalid. Next it tells us all of the possible options, and we can see that the spelling of the `Settings` section can be either `Settings` or `Setting`.



##### Step 2 - Library Not Found

Here we have fixed the error from step 1, now we will look at what happens when we use an invalid library name.

```
# 15_debugging_robot.robot
*** Settings ***
Library  Strings

*** Test Cases ***
Placeholder
    Log to console Placeholder Test Case Start
    ${message_one}=  Hello
    ${message_two}=  World!
    Log  catenate  SEPERATOR=" "  ${message_one}  ${message_two}
```

> Run the test again and view the error in the log.html file:

Error Message: `Error in file '/tmp/jobfile.robot': Importing test library 'Strings' failed: ModuleNotFoundError: No module named 'Strings'`

The error message indicates that its a `Non-existing setting` error, so our `Library Strings` setting is invalid. Since the Collections library is spelt with an `s`, it can be common to put an `s` on the string library as well, but it is supposed to be spelt `string`.



##### Step 3 - Invalid Spacing

The error from step 2 is now fixed, but the next error we are getting is regarding invalid spacing.

```
# 15_debugging_robot.robot
*** Settings ***
Library  String

*** Test Cases ***
Placeholder
    Log to console Placeholder Test Case Start
    ${message_one}=  Hello
    ${message_two}=  World!
    Log  catenate  SEPERATOR=" "  ${message_one}  ${message_two}
```
> Run the test again and view the error in the log.html file:

Error Message: `No keyword with name 'Log to console Placeholder Test Case' found.`

This is an unknown keyword error, it can't find a keyword with the specific name. If you look at this line of code, you can see that we are trying to log the message `Placeholder Test Case Start` to the console. The problem is that there is only one space between `console` and `Placeholder`. Since there is only one space, Robot thinks this entire line is a keyword instead of a keyword and its argument.

Note: This is a very common error. Since Robot is parsed based on white space, only placing a single space where two or more are needed will result in errors.



##### Step 4 - Setting Variable Without Keyword

We solve the previous error by adding a space between `console` and `Placeholder`, in this step we will see what happens when we try to set a variable in a test case without a keyword.

```
# 15_debugging_robot.robot
*** Settings ***
Library  String

*** Test Cases ***
Placeholder
    Log to console  Placeholder Test Case Start
    ${message_one}=  Hello
    ${message_two}=  World!
    Log  catenate  SEPERATOR=" "  ${message_one}  ${message_two}
```

> Run the test again and view the error in the log.html file:

Error Message: `No keyword with name 'Hello' found.`

You see here that this error message is the same as in step 3, `No keyword with name`, but the cause of the error is different. When you start a new line of Robot code, the parser is looking for either a keyword or a variable declaration. If it finds a variable declaration, like `${message_one}=`, then it will look for a keyword separated by two spaces. In this case, it finds the string `Hello` so it looks for a keyword named `Hello` but doesn't find one. We are trying to assign the value `Hello` to the variable `${message_one}`, the real error here is that we aren't using a keyword to assign the error. We need to fix this by using a keyword like `Set Variable` to set the variable value.



##### Step 5 - Invalid Keyword As Argument

Unlike working in a programming language, like Python, you can't always call keywords as the arguments for other keywords. You will see here the error that happens when you provide a keyword as an argument to another keyword expecting a value.

```
# 15_debugging_robot.robot
*** Settings ***
Library  String

*** Test Cases ***
Placeholder
    Log to console  Placeholder Test Case Start
    ${message_one}=  set variable  Hello
    ${message_two}=  set variable  World!
    Log  catenate  ${message_one}  ${message_two}
```

> Run the test again and view the error in the log.html file:

Error Message: `Invalid log level 'Hello'.`

This is an example of when an error message isn't very helpful. The problem here is that we are using the `catenate` keyword as input to the `log` keyword, which is expecting a value to print to the log. The error is indicating that the value `'Hello'` which was passed in as an argument to the `catenate` keyword is an invalid option for `log level`. The `log` keyword as an option second parameter of `log level`, which can be set to something like `debug` to change where the log is printed. To get this code to work as expected, we need to move it into two lines, one line to create the log message, and a second to print it to the log file.



##### Solution

```
# 15_debugging_robot.robot
*** Settings ***
Library  String

*** Test Cases ***
Placeholder
    Log to console  Placeholder Test Case Start
    ${message_one}=  set variable  Hello
    ${message_two}=  set variable  World!
    ${message}=  catenate  ${message_one}  ${message_two}
    Log  ${message}
```



### Task 2 - Debugging CXTA

##### Step 1 - Forgetting CXTA Imports

In this Robot file, we didn’t import the CXTA library.

```
# 15_debugging_cxta.robot
*** Settings ***
Library  Collections

*** Variables ***
${command}  show version
@{DUTS}  cxtm_ios  cxtm_iox

*** Test Cases ***
Establish Connection
    Load testbed
    Connect to devices  ${DUTS}

Get Version
    Use device "cxtm_ios"
    ${version_data_raw}=   run "${command}"
```

> Run the test again and view the error in the log.html file:

Error Message: `No keyword with name 'Load testbed' found.`

Whenever an error message indicates it can’t find a keyword belonging to the CXTA library, that means you have probably forgotten to import the library or have spelled the keyword wrong. First check the settings section to see if they are there. If they are, another common cause of this error is using two spaces instead of one for embedded arguments.



##### Step 2 - Two Spaces Instead Of One and Missing Quotes Around Params

We can fix the previous issue as follows by including the CXTA library.

```
# 15_debugging_cxta.robot
*** Settings ***
Library  Collections
Library  CXTA
Resource  cxta.robot

*** Variables ***
${command}  show version
@{DUTS}  cxtm_ios  cxtm_iox

*** Test Cases ***
Establish Connection
    Load testbed
    Connect to devices  ${DUTS}

Get Version
    Use device "cxtm_ios"
    ${version_data_raw}=   run "${command}"
```

> Run the test again and view the error in the log.html file:

Error Message: `No keyword with name 'Connect to devices' found. Did you mean`

Once again we are faced with the same error. A good example of an error that could have several different causes you need to check step by step. In this case we see that there are two spaces instead of one between `devices` and `${DUTS}`. Removing the extra space and wrapping the argument `${DUTS}` in quotes (“”) which is a requirement for the CXTA keyword should now be the solution.



##### Step 3 - Invalid Argument Type

The `Connect to devices "${devices}"` keyword requires a string with a semi-colon separated list of device names. Passing a list instead is an example of providing the wrong type of parameter to a keyword.

```
# 15_debugging_cxta.robot
*** Settings ***
Library  Collections
Library  CXTA
Resource  cxta.robot

*** Variables ***
${command}  show version
@{DUTS}  cxtm_ios  cxtm_iox

*** Test Cases ***
Establish Connection
    Load testbed
    Connect to devices "${DUTS}"

Get Version
    Use device "cxtm_ios"
    ${version_data_raw}=   run "${command}"
```

> Run the test again and view the error in the log.html file:

Error Message: `AttributeError: 'list' object has no attribute 'split'`

We passed a list into a keyword that was expecting a string. This incorrect variable type caused the keyword to fail. To fix this, we just need to create `${DUTS}` as a semi-colon separated string of device names.


##### Solution

```
# 15_debugging_cxta.robot
*** Settings ***
Library  Collections
Library  CXTA
Resource  cxta.robot

*** Variables ***
${command}  show version
${DUTS}  cxtm_ios; cxtm_iox

*** Test Cases ***
Establish Connection
    Load testbed
    Connect to devices "${DUTS}"

Get Version
    Use device "cxtm_ios"
    ${version_data_raw}=   run "${command}"
```
