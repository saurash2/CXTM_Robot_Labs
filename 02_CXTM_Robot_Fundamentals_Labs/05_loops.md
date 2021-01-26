## Lab 5 - Loops

Loops are a powerful concept in most programming languages, allowing for code to be refactored by removing redundant operations. Commands can be placed inside a loop, and they will run for each iteration of the loop.



### Task 1 - For Loops

##### Step 1

> Inside TC05 (Loops) within your CXTM project, click on `Configure Automation`. First we can define several variables to use in our example:

```
# 05_for_loops.robot
*** Variables ***
${hostname}  cxtm_ios
${vendor}  cisco
${os}  ios
${ip_addr}  163.162.174.54

```



##### Step 2

> We can use a for loop to run the same test over multiple inputs, write a test case that logs each of these values to the console using a loop:

```
# 05_for_loops.robot
*** Test Cases ***
Basic For Loop
    FOR  ${item}  IN  ${hostname}  ${vendor}  ${os}  ${ip_addr}
        Log to console  ${item}\n
    END

```



##### Step 3

If you want to repeat a set of tests a certain number of times, you can loop over a range of numbers instead of a list of inputs. The syntax for this uses `IN RANGE` instead of `IN`, followed by one or more numbers. If a single number follows `IN RANGE` then the loop will run from 0 to that number minus 1. In the below example the number 5 is used, so that loop will print the numbers 0, 1, 2, 3 and 4 to the console. In the second loop two numbers are used, so that loop will run from the first number to the second number minus one. The numbers 5 and 10 are used below so the loop will print 5, 6, 7, 8, and 9 to the console. In the next loop a third number is added, this number will determine how the range counts from one number to the next. Since the number is 2, instead of printing every value between the numbers the loop will only print every other value between the numbers. In this example that loop will print 5, 7, and 9 to the console. If that third number was negative, then the loop would count down.

> Test the following examples of the IN RANGE feature of for loops:

```
# 05_for_loops.robot
*** Test Cases ***
Range For Loop
    FOR  ${count}  IN RANGE  5
        Log to console  ${count}\n
    END

    FOR  ${count}  IN RANGE  5  10
        Log to console  ${count}\n
    END

    FOR  ${count}  IN RANGE  5  10  2
        Log to console  ${count}\n
    END

```

It is always important to remember when writing your loop that the numbers you choose won't cause the loop to run forever. If the numbers 5, 10, and -2 were used it would start at 5 and count down by 2 until it reaches 10. Since this count will never reach 10, the loop will continue forever failing your test.



##### Solution

```
# 05_for_loops.robot
*** Variables ***
${hostname}  cxtm_ios
${vendor}  cisco
${os}  ios
${ip_addr}  163.162.174.54

*** Test Cases ***
Basic For Loop
    FOR  ${item}  IN  ${hostname}  ${vendor}  ${os}  ${ip_addr}
        Log to console  ${item}\n
    END

Range For Loop
    FOR  ${count}  IN RANGE  5
        Log to console  ${count}\n
    END

    FOR  ${count}  IN RANGE  5  10
        Log to console  ${count}\n
    END

    FOR  ${count}  IN RANGE  5  10  2
        Log to console  ${count}\n
    END

```



### Task 2 - Looping Over Lists

For loops are a type of loop which have a defined set they operate over. For example, a for loop can be written to loop for a specific number of iterations like 1 through 10. In most cases though you are using for loops to run an operation on a list or dictionary of values so the set iterations will depend on the list of the data structure being used.



##### Step 1

> We will start by created a list to use as our bounds for the for loop:

```
# 05_looping_over_lists.robot
*** Variables ***
@{commands}  interface Eth2/1  description Configured by Robot  speed 100  duplex full
```



##### Step 2

> Loop over the commands list:

```
# 05_looping_over_lists.robot
*** Test Cases ***
Logging Lists
    FOR  ${command}  IN  @{commands}
        Log to console  ${command}
    END
```

`@{commands}` is the name of the list we are using for the bounds of our loop. The `${command}` variable is the current element of the list that the loop is operating on. The commands run on each iteration of the loop are indented following the FOR loop line. The above example logs the value of each element in the `@{commands}` list.



##### Step 3

Another way to loop in Robot is to use `IN ZIP` which allows you to loop over multiple loops at the same time. If you have several related lists, like keys and values from a dictionary, then it can be useful to get an item from each list at the same index. When using `IN ZIP` you define a separate variable in the loop for each list you are looping over.

> In this example keys and values are looped using `IN ZIP` and logged together to keep the context of the values:

```
# 05_for_loops.robot
*** Variables ***
# &{facts}  hostname=cxtm_ios  vendor=cisco  os=ios  ip_addr=163.162.174.54
@{keys}  hostname  vendor  os  ip_addr
@{values}  cxtm_ios  cisco  ios  163.162.174.54

*** Test Cases ***
Loop Over Two Lists With Zip
    FOR  ${key}  ${value}  IN ZIP  ${keys}  ${values}  # can't use @ for the IN ZIP
        Log to console  ${key}=${value}\n
    END
```



##### Step 4

When looping over values in a list, it can be useful to keep track of the index of item you are working with. The `IN ENUMERATE` feature allows you to define another variable to keep track of the index of the current item being looped over.

> Write a test looping over the commands again, this time also log the index of the item:

```
# 05_for_loops.robot
*** Test Cases ***
Enumerate For Loop
    FOR  ${index}  ${item}  IN ENUMERATE  @{commands}
        Log to console  ${index}: ${item}\n
    END

```



##### Solution

```
# 05_looping_over_lists.robot
*** Variables ***
@{commands}  interface Eth2/1  description Configured by Robot  speed 100  duplex full
# &{facts}  hostname=cxtm_ios  vendor=cisco  os=ios  ip_addr=163.162.174.54
@{keys}  hostname  vendor  os  ip_addr
@{values}  cxtm_ios  cisco  ios  163.162.174.54

*** Test Cases ***
Logging Lists
    FOR  ${command}  IN  @{commands}
        Log to console  ${command}
    END

Loop Over Two Lists With Zip
    FOR  ${key}  ${value}  IN ZIP  ${keys}  ${values}  # can't use @ for the IN ZIP
        Log to console  ${key}=${value}\n
    END

Enumerate For Loop
    FOR  ${index}  ${item}  IN ENUMERATE  @{commands}
        Log to console  ${index}: ${item}\n
    END

```



### Task 3 - Looping Over Dictionaries

##### Step 1

> Include the Collections library since were working with dictionary keywords, and add an interface dictionary to a file:

```
# 05_looping_over_dictionaries.robot
*** Settings ***
Library  Collections

*** Variables ***
&{interface}  duplex=full  speed=100  description=Configured by Robot
```



##### Step 2

Similar to looping over the list in Task 1, we can get the keys from the dictionary as a list using the `Get Dictionary Keys` keyword. Then using this as the bounds for the for loop, we are given access to each key from the dictionary in the `${key}` variable.

> Write a test case that logs each value from a dictionary separately using a for loop:

```
# 05_looping_over_dictionaries.robot
*** Test Cases ***
Looping Over A Dictionary By Keys
    @{keys}=  Get Dictionary Keys  ${interface}
    FOR  ${key}  IN  @{keys}
        Log  ${key}
        ${value}=  Get From Dictionary  ${interface}  ${key}
    END
```



##### Step 3

The same can be done using the keyword `Get Dictionary Values` and just logging each element using the for loop.

> The following is an example of that approach:

```
# 05_looping_over_dictionaries.robot
*** Test Cases ***
Looping Over A Dictionary By Values
    @{values}=  Get Dictionary Values  ${interface}
    FOR  ${value}  IN  @{values}
        Log  ${value}
    END
```

This won't be as useful since you lose access to the context that the key provides. In most cases you will want to work with the key so you can perform more operations like updating or removing the value instead of just getting it.



##### Step 4

You can loop through both the keys and values of a dictionary using the `Get Dictionary Items` keyword to return a list of key / value pairs.

> Loop over a dictionary using items:

```
# 05_looping_over_dictionaries.robot
*** Test Cases ***
Looping Over A Dictionary By Keys And Values
    @{items}=  Get Dictionary Items  ${interface}
    FOR  ${item}  IN  @{items}
        Log  ${item}
    END
```



##### Solution

```
# 05_looping_over_dictionaries.robot
*** Settings ***
Library  Collections

*** Variables ***
&{interface}  duplex=full  speed=100  description=Configured by Robot

*** Test Cases ***
Looping Over A Dictionary By Keys
    @{keys}=  Get Dictionary Keys  ${interface}
    FOR  ${key}  IN  @{keys}
        Log  ${key}
        ${value}=  Get From Dictionary  ${interface}  ${key}
    END

Looping Over A Dictionary By Values
    @{values}=  Get Dictionary Values  ${interface}
    FOR  ${value}  IN  @{values}
        Log  ${value}
    END

Looping Over A Dictionary By Keys And Values
    @{items}=  Get Dictionary Items  ${interface}
    FOR  ${item}  IN  @{items}
        Log  ${item}
    END
```



### Task 4 - Nested Loop

For loops can't be nested by default in Robot. To nest loops you need to use a custom keyword. In your test case you can have a loop which runs a keyword, that keyword can then have a loop to give the behavior of a nested loop.

##### Step 1

> First we need a data set that requires a nested loop to traverse, for this example we will look at a list of lists containing IP addresses. Create a list of lists:

```
# 05_nested_loop.robot
*** Variables ***
@{eu-east}  10.1.100.1  10.1.100.2  10.1.100.3
@{eu-west}  1.1.1.1  2.2.2.2  3.3.3.3  4.4.4.4
@{regions}  ${eu-east}  ${eu-west}
```

##### Step 2

In a test case, we can write the first level of the loop. This loop will run the custom keyword we write for each iteration.

> Write a test case containing a for loop:

```
# 05_nested_loop.robot
*** Test Cases ***
Log IP Addresses From Regions
    FOR  ${region}  IN  @{regions}
        Loop Over Region  ${region}
    END
```

##### Step 3

Finally write a custom keyword which takes in the inner list as an argument, loops over it, and logs each IP address.

> Write the custom keyword:

```
# 05_nested_loop.robot
*** Keywords ***
Loop Over Region
    [Arguments]  @{region}
    FOR  ${ip_addr}  IN  @{region}
        Log  ${ip_addr}
    END
```

##### Solution

```
# 05_nested_loop.robot
*** Variables ***
@{eu-east}  10.1.100.1  10.1.100.2  10.1.100.3
@{eu-west}  1.1.1.1  2.2.2.2  3.3.3.3  4.4.4.4
@{regions}  ${eu-east}  ${eu-west}

*** Keywords ***
Loop Over Region
    [Arguments]  @{region}
    FOR  ${ip_addr}  IN  @{region}
        Log  ${ip_addr}
    END

*** Test Cases ***
Log IP Addresses From Regions
    FOR  ${region}  IN  @{regions}
        Loop Over Region  @{region}
    END

```



### Task 5 - Show Command To Multiple Devices

A common task you'll perform is running show commands against devices to verify their state. Without loops, you would need to write code for each device you want to test. This is how you can use loops to simplify your robot files and make your tests more maintainable.



##### Step 1

To work with devices, we need to start by setting up connections. As was demonstrated in the connections lab, we need to load the testbed to use the connection keywords in our test cases. We are also going to define a list of all device names so that we can run our tests on all included devices. Note: This can be done with alternate keywords to run on each device, but this helps to show which devices are being tested.

> Import the CXTA keywords and setup the testbed file similar to Lab 4:

```
# 05_multiple_devices.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Variables ***
@{devices}  cxtm_iosxe_1  cxtm_iosxe_2

*** Test Cases ***
Load Testbed
    load testbed
```



##### Step 2

Now that you have a list of devices to work with, we are going to write a for loop that will run over the list. Like we have seen above, the for loop defines a variable to store the current  value it is iterating over, named `${device}` in this case.

> Loop over the list of devices, make a variable named `${device}` containing the current device:

```
# 05_multiple_devices.robot
*** Test Cases ***
Show Command To Multiple Devices
    FOR  ${device}  IN  @{devices}
```



##### Step 3

Now we will introduce some CXTA custom keywords, `run "${command}"` and `connect to device "${device}"`. These keywords will be seen in more detail later, for the purpose of this example, they are connecting to the device and running the show version command on that device. Since this code is being written in the body of the for loop, it will execute for each device in the devices list.

> Send the command `show version` to the device:

```
# 05_multiple_devices.robot
*** Test Cases ***
Show Command To Multiple Devices
    FOR  ${device}  IN  @{devices}
       connect to device "${device}" over "vty"
       run "show version"
    END
```



##### Solution

```
# 05_multiple_devices.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Variables ***
@{devices}  cxtm_iosxe_1  cxtm_iosxe_2

*** Test Cases ***
Load Testbed
    load testbed

Show Command To Multiple Devices
    FOR  ${device}  IN  @{devices}
       connect to device "${device}" over "vty"
       run "show version"
    END
```
