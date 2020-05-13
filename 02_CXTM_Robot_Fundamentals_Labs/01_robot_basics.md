## Lab 1 - Robot Basics

This lab is an introduction to Robot Framework showing the layout of a Robot jobfile and the basics to writing and executing your first tests in CXTM environment.


### Task 1 - Layout of a Robot File and Executing Tests

##### Step 1

Robot jobfiles are basic text files with a .robot file extension. They have four sections: settings, variables, keywords, and test cases. Each section is denoted by three asterisks, the name of the section, and another set of three asterisks. The section name is case insensitive, Settings can be written as Settings, settings, or SETTINGS. The sections don't need to be ordered in this way, you could put `Settings` at the end of the file and it would run the same way. That said, it is best to write your Robot jobfiles in this order as a best practice.

> Inside TC01 (Robot Basics) within your CXTM project, click on `Configure Automation` and place the following section headings inside:

```
# 01_layout.robot
*** Settings ***

*** Variables ***

*** Keywords ***

*** Test Cases ***

```

To save the jobfile in CXTM, select `Job File Type` to `Script in CXTM`, `Runtime Image Type` to `cxta`, `Runtime Image Version` to `cxta: 19.12` and click on `Save`.
Each Robot jobfile creates a Suite by default, a Suite is a collection of Robot test cases. When your execute a jobfile containing Robot tests, it organizes itself as a suite or is added to a larger Suite depending on how you configure it. You don't need to manage suite when using a single jobfile, we'll see in later labs how your can combine multiple jobfiles into larger test suites.



##### Step 2

The `Test Cases` section contains the test cases that you write. Each test case has a name, which is case insensitive, followed by lines or Robot code. In this example, `Log Hostname By Value` is the name of the test case, the following indented line is the Robot code which belongs to that test case. For this example, the line `Log  cxtm_iox` prints the value cxtm_iox. An important note is the two spaces separating `Log` and `cxtm_iox` , in Robot Framework white-space is used to separate different elements.

> Log the hostname cxtm_iox using the `Log` keyword:

```
# 01_layout.robot
*** Test Cases ***
Log Hostname By Value
	Log  cxtm_iox
```



##### Step 3

> Run the jobfile using the `[Run]` command on CXTM jobfile page. When the prompt appears to select a topology file, you can click `Skip This Step` to run the test without any reference to topology.

> Once the test run is complete, reload the screen and the output should be seen in `Run History`. Click it and then open `log.html` file to view the test result.

You can click the `+` buttons to see additional information and the `-` buttons to see less information. If you click the `+` for the test case `Log Hostname By Value` and then click the `+` for the `Log  cxtm_iox` keyword you will the value being logged, which is `cxtm_iox`.

The first item is the name of the test suite, Jobfile, which is the name of the Robot file that is used by CXTM by default. Following that is the name of each test case in the file and its execution status. `Log Hostname By Value` is the only test case in this suite, and it executed successfully so the status is `PASS`. Following all of the test cases is the status of the collective suite, if any test cases fail then the suite also fails. Next are metrics on how many test cases passed or failed. Throughout these lines there are `INFO` lines which contain information about the tests you are running.


> Open the report.html file in your browser and view the contents:

The background color of the page is green to indicate that the test suite ran successfully and passed all of its tests. If there was a problem causing a test case to fail, then the page would have a red background color instead. Similar to the log.html file, you can drill down and see additional information by clicking the blue links.



##### Step 4

The next section we will look at is the `Variables` section. Here you can defined variables that can be accessed in all of your test cases. A variable is used to store information, when you use a variable in a test case it will produce the same output as just using a value in a test case. The syntax for variables in Robot is a $ followed by a set of braces {}, the name of the variable is placed inside the braces.

> The following is an example of defining a variable named hostname which contains the value cxtm_iox:

```
# 01_layout.robot
*** Variables ***
${hostname}  cxtm_iox

*** Test Cases ***
Log Hostname By Variable
	# ${hostname} variable contains the value cxtm_iox, defined in the Variables section
	Log  ${hostname}
```

When you add the above variable and test case to the previous example and execute, you can see that both test cases pass, and the log for each displays the same value, `cxtm_iox`. `Log  cxtm_iox` and `Log  ${hostname}`  are equivalent lines since the variable `${hostname}` contains the value `cxtm_iox`. Another topic introduced in the above example, is a comment. A comment is a line that doesn't effect the execution of the file, but allows the developer to add information about their code for people to read. The `#` symbol is used to start a comment, all the text after this symbol will be ignored as Robot executes the file. It is good practice to use comments to describe what your code is doing to make it easier to maintain.



##### Step 5

The next section we will look at is the `Keywords` section. In this section you define keywords, keywords are blocks of Robot code that can be reused. They are similar to functions and/or methods in programming, they help with code refactoring and making your tests more readable. Each keyword has a name, which is case insensitive, and a set of Robot commands.

> In the following example, a keyword named `Get Hostname` is defined which returns the value of the `${hostname}` variable:

```
# 01_layout.robot
*** Keywords ***
Get Hostname
	[Return]  ${hostname}

*** Test Cases ***
Log Hostname By Keyword
	${hostname}=  Get Hostname
    Log  ${hostname}
```

Similar to the previous example, when adding this keyword and test case to the previous code, each of these test cases should output the same value to the log. This new test case named `Log Hostname By Keyword` is getting the Hostname by using the custom defined keyword `Get Hostname` instead of just using the `${hostname}` or the value `cxtm_iox`.



##### Step 6

The final section we will look at is the `Settings` section. In this section the environment for the Robot tests is defined. You can include libraries and variables and also define metadata for the test suite and test cases. A library is a collection of Robot keywords that you can use in your test cases, for example, the String library contains useful keywords for working with string variables. The line `Library  Builtin` is displayed below, the `Builtin` library is included by default in all Robot files so you never need to include it like this. It contains some basic keywords, like the `Log` keyword you have seen. Variables can be stored in external files and imported in this section, we'll look at this in more detail in a future lab.

> The line `Documentation  Description of Robot Test Suite` below is an example of metadata being defined the for the Robot suite.

```
# 01_layout.robot
*** Settings ***
Documentation  Description of Robot Test Suite
Library  BuiltIn
Library  String
Library  Collections
```



##### Solution

```
# 01_layout.robot
*** Settings ***
Library  BuiltIn
Library  String
Library  Collections

*** Variables ***
${hostname}  cxtm_iox

*** Keywords ***
Get Hostname
	[Return]  ${hostname}

*** Test Cases ***
Log Hostname By Value
	Log  cxtm_iox

Log Hostname By Variable
	# ${hostname} variable contains the value cxtm_iox, defined in the Variables section
	Log  ${hostname}

Log Hostname By Keyword
	${hostname}=  Get Hostname
    Log  ${hostname}
```



### Task 2 - Logging

##### Step 1

We've seen the `Log` keyword used in several tests already. This keyword is used to print a value to the execution log.

> We are going to see several examples of logging different data types, first we will define some variables as follows:

```
# 01_logging.robot
*** Variables ***
${hostname}  cxtm_iox
${version}  16
${is_up?}  true
@{neighbor_hostnames}  cxtm_ios  cxtm_junos
&{device_facts}  hostname=${hostname}  version=${version}  os=ios  vendor=cisco

```



##### Step 2

> These first two test cases show examples of logging strings, booleans, and numbers:

```
# 01_logging.robot
*** Test Cases ***
Logging String Variables
    ${os}=  set variable  ios
    ${vendor}=  set variable  cisco
    Log  ${hostname}
    Log  ${os}
    Log  ${vendor}

Logging Boolean and Number Variables
    Log  ${is_up?}
    Log  ${version}

```

The `Logging String Variables` test case defines two string variables, then logs those variables along with the `${hostname}` variable defined in the previous step. The second test case, `Logging Boolean and Number Variables` shows the boolean variable `${is_up?}` and the number variable `${version}` being logged.



##### Step 3

Next we will see how to log lists and dictionaries. You can log either one with the `Log` keyword, and it will be outputted as a string value. If you want to see it in the log formatted as a list or dictionary, you can use a different logging keyword provided in the `Collections` library.

> There is a `Log List` keyword available to log lists and a `Log Dictionary` keyword for dictionaries.

```
# 01_logging.robot
*** Settings ***
Library  Collections

*** Test Cases ***
Logging Lists
    Log  ${neighbor_hostnames}
    Log list  ${neighbor_hostnames}

Logging Dictionaries
    Log  ${device_facts}
    Log dictionary  ${device_facts}

```


##### Solution

```
# 01_logging.robot
*** Settings ***
Library  Collections

*** Variables ***
${hostname}  cxtm_iox
${version}  16
${is_up?}  true
@{neighbor_hostnames}  cxtm_ios  cxtm_junos
&{device_facts}  hostname=${hostname}  version=${version}  os=ios  vendor=cisco

*** Test Cases ***
Logging String Variables
    ${os}=  set variable  ios
    ${vendor}=  set variable  cisco
    Log  ${hostname}
    Log  ${os}
    Log  ${vendor}

Logging Boolean and Number Variables
    Log  ${is_up?}
    Log  ${version}

Logging Lists
    Log  ${neighbor_hostnames}
    Log list  ${neighbor_hostnames}

Logging Dictionaries
    Log  ${device_facts}
    Log dictionary  ${device_facts}

```



### Task 3 - Variables and Scope

Scope is a programming concept that determines where a variable should be accessible. There are several different scopes in Robot including: test scope, suite scope, and global scope.



##### Step 1

Values defined in a test case have test scope, this means that they are only accessible inside that test case.

> In the following example you will see a variable called `${location}` which has test scope:

```
# 01_scope.robot
*** Test Cases ***
Test Defined Variables
    ${location}=  set variable  nyc
    Set test variable  ${ip_addr}  10.1.100.1
    Log  ${location}

Attempt To Access Test Variable From Another Test
    Run keyword and expect error  *  log  ${location}

```

The variable `${location}` is defined in the test case `Test Defined Variables` and has the value nyc. This variable has test scope since it was defined in a test case using the `Set Variable` keyword. Another way to define a test scope variable is shown in the line `Set Test Variable  ${ip_addr}  10.1.100.1`. The `Set Test Variable` keyword defines a test level variable called `${ip_addr}` with the value `10.1.100.1`. Since `${location}` is a test scope variable, it is available in that test case so it can be logged. In the second test case named `Attempt To Access Test Variable From Another Test` we attempt to log the same variable `${location}`. We expect this to fail since the variable `${location}` isn't available in this test case since it was defined in a separate test case with test scope. Since we expect it to fail, we use the keyword `Run Keyword And Expect Error` to run it and pass if there is a failure. This is important in regard to how you write tests, you want to write your tests to validate what you are expecting. In this test, we are expecting the `Log ` keyword to fail since it can't access `${location}` so we want to have our test case pass if it fails. Seems kind of backwards, but when you run it you will see that your tests pass even though you weren't able to log the variable out of scope.



##### Step 2

In this step we will be defining variables with suite level scoping. A variable with suite scope is available anywhere within the Robot file (or suite) it is defined in. Any variables defined in the `Variables` section have suite level scoping along with variables defined in test cases with the keyword `Set Suite Variables`.

> These tests show suite variables being defined in both the `Variables` section and a test case, then logged in a separate test case:

```
# 01_scope.robot
*** Variables ***
${hostname}  cxtm_iox

*** Test Cases ***
Suite Defined Variables
    Set suite variable  ${os}  ios
    Set suite variable  ${vendor}  cisco

Logging Suite Variables
    Log  ${hostname}
    Log  ${os}

```

This time the variables were logged successfully since they were available to all test cases.



##### Step 3

Global scope works similar to suite scope, the difference is that when multiple suites are run together global variables will be available to all suites.

> The following is the global version of the suite example we saw above:

```
# 01_scope.robot
*** Test Cases ***
Globaly Defined Variables
    Set global variable  ${version}  16
    Set global variable  ${is_up?}  true

Logging Global Variables
    Log  ${version}
    Log  ${is_up?}


```



##### Solution

```
# 01_scope.robot
*** Variables ***
${hostname}  cxtm_iox

*** Test Cases ***
Test Defined Variables
    ${location}=  set variable  nyc
    Set test variable  ${ip_addr}  10.1.100.1

Attempt To Access Test Variable From Another Test
    Run keyword and expect error  *  log  ${location}

Suite Defined Varaibles
    Set suite variable  ${os}  ios
    Set suite variable  ${vendor}  cisco

Logging Suite Variables
    Log  ${hostname}
    Log  ${os}

Globaly Defined Variables
    Set global variable  ${version}  16
    Set global variable  ${is_up?}  true

Logging Global Variables
    Log  ${version}
    Log  ${is_up?}


```
