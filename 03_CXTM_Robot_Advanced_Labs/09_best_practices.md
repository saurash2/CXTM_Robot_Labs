## Lab 9 - Best Practices
When building test suites with the Robot Framework and CXTA, there are often many paths to choose to accomplish the same task. A test can accomplish the intended goal, but be hard for others to read, understand and maintain. These best practices help maintain a certain level of quality and excellence for the entire organisation so the test suites and test cases are easy to maintain and easy to understand.

Some of these best practices are cosmetic, and some are including additional Robot Framework functionality. The key thing to keep in mind when adopting best practices is that you are investing in the future, not just worrying about getting the immediate result done with whatever means possible.

### Task 1 - SVS Standards
Without introducing any new concepts, there are some things that can help make your test cases and test suites more organised and easier to read and maintain. In this test you will be creating a test suite which enables and verifies LLDP is functioning.

##### Step 1
> Inside TC09 (Best Practices) within your CXTM project, click on `Configure Automation` and put the following code in the file:

```
# 09_svs_standards.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Variables ***
${DUT}  cxtm_iox

*** Test Cases ***
Connect to Device
    load testbed
    connect to device "${DUT}" via "vty"
```

Note that your Device Under Test variable name is all capitalized, this is to indicate to users of the test that they are global variables, meant to be accessed or updated anywhere in the test suite. Even though Robot Framework does not change any functionality by using all caps, it helps other users understand that these variables are special, in that they are global in scope.

Variabalising your inputs is a very important best practice when writing your Robot tests. You can write this same example replacing `"${DUT}"` in the Test Cases section with the value `cxtm_iox` and it will work just fine. The problem occurs if you have a test with multiple test cases and that value is used in each, then to change it would require you to change the value in each place. Variables allow you to change the value in a single place and have that change affect each spot it is used in your code. If you wanted to change this test script to work on a different device, you would only need to change the line `${DUT}  cxtm_iox` in the Variables section.

Another important note in this example is how the arguments are used for the CXTA keywords. Each argument is an **embedded argument**, which means it is a part of the keyword name and is **only** separated from the rest of the name by a **single space** instead of two spaces.

In contrast, open source keywords will probably be using a regular keyword, which will be separated from the keyword name by two spaces. Also the arguments are wrapped in double quotes, which is something you won't see in many examples of open source keywords. The string `"vty"` is the same as the string `vty` in Robot, it is a CXTA best practice to wrap theses keyword arguments in double quotes.

##### Step 2
In the test we want to enable and verify LLDP. Some sample lines of configuration and verification would be:

```
run "show run | include lldp"
lldp holdtime 150
no lldp
run "show run | include lldp"
```

Since these are a specific and isolated tasks, it is better to take each component and make them into reusable keywords. This will help others who want to extend or use our test follow along.

##### Step 3

When building a keyword it is important to keep the number of inputs to a minimum, add documentation, and variable names which are intuitive and not ambiguous.

> This example here is a keyword for verifying LLDP:

```
# 09_svs_standards.robot
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
```
Notice that it has a specific scope and returns whether LLDP is running as a Boolean variable. Also notice that it has an example on how to use it, what the arguments mean, what is the expected return value type and who created it.

> Another example of a keyword to use to enable or disable LLDP globally:

```
# 09_svs_standards.robot
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
```

Notice how the keyword accounts for the fact that the commit may fail and let's the user know if it did. The keyword also account for the fact that the feature of lldp may want to be enabled or disabled, with an example of those inputs in the documentation.

##### Step 4

> Now integrate those two keywords into your test suite, and add a global variable for the LLDP hold timer called `${LLDP_HOLDTIMER}` and set it to 150:

```
# 09_svs_standards.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Variables ***
${DUT}  ${DUT}  cxtm_iox
${LLDP_HOLDTIMER}  150

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

*** Test Cases ***
Connect to Device
    load testbed
    connect to device "${DUT}" via "vty"
```

##### Step 5

These keywords can be stored in the Keywords section of the Robot test we are writing, but the best practice is to store them in a separate Robot file and import them into your test. Keywords should accomplish a specific task, and this task can be something you want to reuse in other tests. For this reason, storing keywords in their own files will make it easier to use them in multiple test.

> Move your custom keywords to a separate Robot file, create a new file called 09_lldp_keywords.robot with the following information and and upload it to your `Project Attachments`. Also, include the file for Automation with path `/workspace`

```
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
```

> These keywords can then be imported into your Robot test in the Settings section:

```
# 09_svs_standards.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Resource  /workspace/09_lldp_keywords.robot
```

You can see an example of another Resource statement in the Settings for this test, `Resource  cxta.robot` is the line that is importing the CXTA keywords into your test case.

##### Step 6

In addition to storing custom keywords in a Robot file, we should store our variables in a variables file. Variable files are YAML files, containing each variable for your Robot test as a key / value pair.

> Move your variables to a variables file 09_variables.yaml. Upload it to your `Project Attachments`. Also, include the file for Automation with path `/workspace`

```
# 09_variables.yaml
DUT: cxtm_iox
LLDP_HOLDTIMER: 150

```

> Now that you have a variables file, you can import it into your Robot test in the Settings section:

```
# 09_svs_standards.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Resource  /workspace/09_lldp_keywords.robot
Variables  /workspace/09_variables.yaml
```

##### Step 7

Now that the keywords and variables are in place, it is time to add a second test case to our test suite.

> Add the following test case below the `Connect to Device` one:

```
# 09_svs_standards.robot
*** Test Cases ***
Verify LLDP Disabled
    ${lldp_status}=  Verify LLDP Globally  ${DUT}
    Disable or Enable LLDP Globally  ${DUT}  enable  ${LLDP_HOLDTIMER}
    ${lldp_status}=  Verify LLDP Globally  ${DUT}
```
This test case checks the state before the change, makes the change, and then verifies it has been changed. By using our custom keywords it makes it much easier to read and follow the flow of the changes.

Run the test suite and view the output while following the flow of actions and how everything fits together.



##### Solution

```
# 09_svs_standards.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot
Resource  /workspace/09_lldp_keywords.robot
Variables  /workspace/09_variables.yaml


*** Test Cases ***
Connect to Device
    load testbed
    connect to device "${DUT}" via "vty"

Verify LLDP Disabled
    ${lldp_status}=  Verify LLDP Globally  ${DUT}
    Disable or Enable LLDP Globally  ${DUT}  enable  ${LLDP_HOLDTIMER}
    ${lldp_status}=  Verify LLDP Globally  ${DUT}
```



### Task 2 - Suite Setup and Teardown

One important concept in automated testing is Suite Setup and Suite Teardown. Rather than logging into each device manually and watching certain behaviours happen, Robot Framework enables you to automatically set up all the necessary pre-requisite configuration and data for your specific test, and then revert the test bed to the original state once you are done.

This is important so that the state of your testbed is not influenced by the actions of previous test runs. Using Suite Setup and Teardown, it allows you to plan out and have Robot Framework take care of all the steps needed, such as establishing a connection to a device, configuring some basic config, running some show commands, or removing the configuration you added.

The steps in the suite setup and teardown are not the things you are testing, but are the auxiliary things that you need to have in place to make your test happen cleanly.

In this test you will enable LLDP and then verify that it is enabled.

##### Step 1
> In order to define your test suite set up and teardown, it helps to have the process summarized in their own keywords:

```
# 09_suite_setup_and_teardown.robot
*** Keywords ***
Test Entry Procedure
    Initialize logging to "${DUT}_task2_lldp_test_results.txt"
    Activate report "${DUT}_task2_lldp_test_results.txt"
    Add report title "*** Pre-Test LLDP Global Status ***"
    load testbed
    connect to device "${DUT}" via "vty"

Test Exit Procedure
    Disable or Enable LLDP Globally  ${DUT}  disable  ${EMPTY}
    Activate report "${DUT}_task2_lldp_test_results.txt"
    Add report title "*** Test Ending ***"
    Add report comment "Test Completed"
```
Add these keywords into your keywords section on your robot file.

These keywords create a log file for each test per device name and add log titles. The test entry procedure also loads the testbed and connects to the device. When the test is over, you disable LLDP to revert the test back to the previous state.

##### Step 2
> In your `*** Settings ***` section add the following:

```
# 09_suite_setup_and_teardown.robot
*** Settings ***
Library  CXTA
Library  String
Resource  cxta.robot
Resource  /workspace/09_lldp_keywords.robot
Variables  /workspace/09_variables.yaml
Suite Setup  Test Entry Procedure
Suite Teardown  Test Exit Procedure
```
which will use the `Suite Setup` and `Suite Teardown` functionality of Robot framework, referencing the keywords you just created. This means that every time the test suite is run the `Test Entry Procedure` will run, and when the test suite is over, even if there is a failure, the `Test Exit Procedure` will run to clean things up.

##### Step 3

> Change your test cases to only keep the following:

```
# 09_suite_setup_and_teardown.robot
*** Test Cases ***
Test LLDP
    Disable or Enable LLDP Globally  ${DUT}  enable  ${LLDP_HOLDTIMER}
    Verify LLDP Globally  ${DUT}
    ${output}=  run "show lldp | include hold time"
```
Since your setup and teardown includes connecting to the device and removing the LLDP configuration once it is done, the actual test case information is minimal.

##### Step 4

Run your test suite, note that the log output shows the suite setup and teardown both at the top of the logfile, this does not mean they run sequentially, but rather are just at the top for organizational purposes.



##### Solution

```
# 09_svs_standards.robot
*** Settings ***
Library  CXTA
Library  String
Resource  cxta.robot
Resource  /workspace/09_lldp_keywords.robot
Variables  /workspace/09_variables.yaml
Suite Setup  Test Entry Procedure
Suite Teardown  Test Exit Procedure


*** Keywords ***
Test Entry Procedure
    Initialize logging to "${DUT}_task2_lldp_test_results.txt"
    Activate report "${DUT}_task2_lldp_test_results.txt"
    Add report title "*** Pre-Test LLDP Global Status ***"
    load testbed
    Connect to device "${DUT}" via "vty"

Test Exit Procedure
    Disable or Enable LLDP Globally  ${DUT}  disable  ${EMPTY}
    Activate report "${DUT}_task2_lldp_test_results.txt"
    Add report title "*** Test Ending ***"
    Add report comment "Test Completed"


*** Test Cases ***
Test LLDP
    Disable or Enable LLDP Globally  ${DUT}  enable  ${LLDP_HOLDTIMER}
    Verify LLDP Globally  ${DUT}
    ${output}=  run "show lldp | include hold time"
```
