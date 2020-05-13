## Lab 2 - Lists and Reviewing Data Types



### Task 1 - Reviewing Data Types

##### Step 1 - Strings

###### Creating Strings

Strings are a textual data type which can contain letters, numbers, spaces, and special characters. In Robot strings can be written without quotes, they just can't contain more than one consecutive space. `interface GigabitEthernet1/1` is a string and `interface  GigabitEthernet1/1` is two separate strings since two spaces are used to separate elements in Robot.

> Inside TC02 (Lists) within your CXTM project, click on `Configure Automation` and define the following two string variables in the `Variables` section:

```
# 02_creating_strings.robot
*** Variables ***
${hostname}  ROUTER1
${config_lines}  interface GigabitEthernet1/1 ; shutdown
```

Now that the string variables have been defined in the `Variables` section, you can define some string variables in the `Test Cases` section. This can be done with the `Set Variable` keyword.

> Create two string variables in a test case and log them:

```
# 02_creating_strings.robot
*** Test Cases ***
Creating Strings In Tests
    ${vendor}=  Set Variable  cisco
    ${os}=  Set Variable  ios

    Log  ${vendor}
    Log  ${os}
```

Checking the type of a variable can be very useful when writing tests, it is important to verify that you are receiving a specific type of value. There isn't a built in keyword in Robot Framework to check the type of a variable, but this can be done using a combination of the `Evaluate` keyword and the python code `type($variable_name).__name__` . The `Evaluate` keyword runs python code and returns the result, and in python there is a function called `type` which checks the type of a variable.

> Use the `Evaluate` keyword to check the type of one of your variables:

```
# 02_creating_strings.robot
*** Test Cases ***
Check Type Of Variable
    ${type}=  Evaluate  type($hostname).__name__
```



###### Solution

```
# 02_creating_strings.robot
*** Variables ***
${hostname}  ROUTER1
${config_lines}  interface GigabitEthernet1/1 ; shutdown

*** Test Cases ***
Creating Strings In Tests
    ${vendor}=  set variable  cisco
    ${os}=  set variable  ios

    Log  ${vendor}
    Log  ${os}

Check Type Of Variable
    ${type}=  Evaluate  type($hostname).__name__
```



###### Using Strings

The first operation were looking at is concatenation, or joining strings together. In Robot this is achieved using the `Catenate` keyword. This keyword takes multiple strings as input and returns a single string containing all the string values. When this value is returned it can be stored in a variable, that variable can already be declared or it can be a new variable. The `Catenate` keyword by default will insert a space between strings when combining them, so there is a `SEPARATOR` option you can use to change the space separator.

> Write a Robot test where you define two variables and concatenate them into a single variable:

```
# 02_working_with_strings.robot
*** Test Cases ***
Add Subnet Mask To IP Address
    ${ip_addr}=  set variable  10.1.100.1
    ${subnet_mask}=  set variable  28
    ${ip_addr_with_mask}=  catenate  ${ip_addr}  /  ${subnet_mask}
    ${ip_addr_with_mask}=  catenate  SEPARATOR=  ${ip_addr}  /  ${subnet_mask}
```

> The `Catenate` keyword is included in the `BuiltIn` library, the rest of the keywords were going to be using are from the `String` library, you need to include it in your Robot file:

```
# 02_working_with_strings.robot
*** Settings ***
Library  String
```

Another useful tool when working with strings is changing text from lowercase to uppercase or from uppercase to lowercase. There are two keywords to perform these changes, the `Convert To Lowercase` and `Convert To Uppercase` keywords. These keywords take a string as input and return the modified string. Along with converting the string values to lowercase or uppercase, there are keywords to verify that strings are lowercase or uppercase. These keywords are called `Should Be Lowercase` and `Should Be Uppercase` , they take a string as input and fail the test if the condition is false.

> Write a test case that converts an interface name to lowercase and then to uppercase, verify each step:

```
# 02_working_with_strings.robot
*** Test Cases ***
Verify Upper and Lower Case Conversion
    ${gig_interface}=  set variable  GigabitEthernet1/1
    ${gig_interface}=  convert to lowercase  ${gig_interface}
    Should be lowercase  ${gig_interface}
    ${gig_interface}=  convert to uppercase  ${gig_interface}
    Should be uppercase  ${gig_interface}
```

Sometimes when working with strings you will only need a small portion of the string, there are several keywords in Robot to help you subdivide strings. If the portion of the string you want to retrieve is all to one side, you can use either the `Fetch From Right` or `Fetch From Left` keywords. For these keywords you provide the keyword you are searching and a string to search for, all characters in the first string up to the second input are returned as a single string. If the piece you want is in the middle of the string you can use the `Get Substring` keyword. For this keyword you provide the string you are searching and two numbers as input. The two numbers are the starting and ending index of the string you want to achieve. The starting index is inclusive and the ending index is exclusive. The piece of the string that falls on those indexes is returned.

> Test these keywords by retrieving the first octet, second octet, and subnet mask of the IP address:

```
# 02_working_with_strings.robot
*** Test Cases ***
Verify Substrings in an IP Address
    ${ipaddr}=  set variable  10.1.100.1/28
    ${mask}=  fetch from right  ${ipaddr}  /
    ${first_octet}=  fetch from left  ${ipaddr}  .
    Should be equal as strings  ${first_octet}  10
    ${whole_ip}=  fetch from right  ${ipaddr}  X
    ${second_octet}=  get substring  ${ipaddr}  3  4
    Should be equal as strings  ${second_octet}  1
```

`Replace String` is a keyword used to replace a substring with another string. The keyword takes three strings as input: the string to change, the substring to replace, and the string to replace the substring with.

> Use the `Replace String` keyword to update the value of a string:

```
# 02_working_with_strings.robot
*** Test Cases ***
Change Device State
    ${is_up?}=  set variable  down
    ${is_up?}=  replace string  ${is_up?}  down  up  
```

You can create strings using the values from variables by putting them in a pattern. The `Format String` keyword takes in a pattern and variables to "fill in" the pattern with. Each set of `{}` brackets in the format indicate a location where a variable value will be filled in.

> Create a string using a format pattern and several other variables:

```
# 02_working_with_strings.robot
*** Test Cases ***
Format Values Into Device Type
    ${vendor}=  set variable  cisco
    ${os}=  set variable  ios
    ${device_type}=  format string  {}_{}  ${vendor}  ${os}
```

The next data type we will be investigating is Lists, which are a collection of values. A string can be broken down into pieces and stored in a list, it is split based on a search string. The keyword to do this split is `Split String`, it takes in the string to be split and the string to search for where to split. There is an alternate version of the keyword named `Split To Lines` which just takes in a single string and splits it based on newline characters (`\n`).

> Split some strings based on a custom delimiter and newline characters:

```
# 02_working_with_strings.robot
*** Test Cases ***
Seperate Commands Into List Based On Delimiters Or New Lines
    ${commands}=  set variable  
    ...  interface Ethernet1/1 ; switchport access vlan 10 ; shutdown
    ${commands_list}=  split string  ${commands}  ;
    ${commands}=  set variable  
    ...  interface Ethernet1/1 \n swtichport access vlan 10 \n shutdown
    ${commands_list}=  split to lines  ${commands}
```



###### Solution

```
# 02_working_with_strings.robot
*** Settings ***
Library  String

*** Test Cases ***
Add Subnet Mask To IP Address
    ${ip_addr}=  set variable  10.1.100.1
    ${subnet_mask}=  set variable  28
    ${ip_addr_with_mask}=  catenate  ${ip_addr}  /  ${subnet_mask}
    ${ip_addr_with_mask}=  catenate  SEPARATOR=  ${ip_addr}  /  ${subnet_mask}

Verify Upper and Lower Case Conversion
    ${gig_interface}=  set variable  GigabitEthernet1/1
    ${gig_interface}=  convert to lowercase  ${gig_interface}
    Should be lowercase  ${gig_interface}
    ${gig_interface}=  convert to uppercase  ${gig_interface}
    Should be uppercase  ${gig_interface}

Verify Substrings in an IP Address
    ${ipaddr}=  set variable  10.1.100.1/28
    ${mask}=  fetch from right  ${ipaddr}  /
    ${first_octet}=  fetch from left  ${ipaddr}  .
    Should be equal as strings  ${first_octet}  10
    ${whole_ip}=  fetch from right  ${ipaddr}  X
    ${second_octet}=  get substring  ${ipaddr}  3  4
    Should be equal as strings  ${second_octet}  1

Change Device State
    ${is_up?}=  set variable  down
    ${is_up?}=  replace string  ${is_up?}  down  up  

Format Values Into Device Type
    ${vendor}=  set variable  cisco
    ${os}=  set variable  ios
    ${device_type}=  format string  {}_{}  ${vendor}  ${os}

Seperate Commands Into List Based On Delimiters Or New Lines
    ${commands}=  set variable  
    ...  interface Ethernet1/1 ; switchport access vlan 10 ; shutdown
    ${commands_list}=  split string  ${commands}  ;
    ${commands}=  set variable  
    ...  interface Ethernet1/1 \n swtichport access vlan 10 \n shutdown
    ${commands_list}=  split to lines  ${commands}

```



##### Step 2 - Numbers

###### Integers

Integers are a type of numerical data type available in Robot, they are used to store whole numbers (numbers that don't contain decimals).

> Numbers can be created using the `$` symbol and the `{}` brackets like the example below:

```
# 02_integers.robot
*** Variables ***
${number_as_number}  ${13}
${number_as_string}  13
```

When you write a number without the dollar sign or brackets then it is stored as a string instead of a number, it can converted and compared with numbers just not used for mathematical operations like addition or subtraction.

Integers can be created in test cases as well, utilizing the `Set Variable` keyword from the previous labs.

> Create an integer variable in a test case:

```
# 02_integers.robot
*** Test Cases ***
Creating Integer Variables In Test Cases
    ${device_version}=  set variable  ${6}
    Log  ${device_version}
```



###### Solution

```
# 02_integers.robot
*** Variables ***
${number_as_number}  ${13}
${number_as_string}  13

*** Test Cases ***
Creating Integer Variables In Test Cases
    ${device_version}=  set variable  ${6}
    Log  ${device_version}
```



###### Floats

Floats are another numerical data type, they are used to store numbers with decimals. Just like with the integer, it needs to be created using the `$` symbol and `{}` brackets otherwise it will be used as a string.

> Create some float variables in a test case and compare them using the keyword `Should Not Be Equal As Numbers`:

```
# 02_float.robot
*** Test Cases ***
Demonstrating Integer Not Equal To Decimal
    ${integer_value}=  set variable  ${13}
    ${decimal_value}=  set variable  ${13.4}
    Should not be equal as numbers  ${integer_value}  ${decimal_value}
```

Variables can be compared using conditional operators like `<`, `>`, and `==`.

> Write a test case that compares two float values like below:

```
# 02_float.robot
*** Test Cases ***
Verifying Connectivity
    ${ping_loss_result}=  set variable  ${3.33}
    ${ping_loss_acceptable_limit}=  set variable  ${80.0}
    Run keyword unless  ${ping_loss_result} < ${ping_loss_acceptable_limit}  Fail
```



###### Solution

```
# 02_float.robot
*** Test Cases ***
Demonstrating Integer Not Equal To Decimal
    ${integer_value}=  set variable  ${13}
    ${decimal_value}=  set variable  ${13.4}
    Should not be equal as numbers  ${integer_value}  ${decimal_value}

Verifying Connectivity
    ${ping_loss_result}=  set variable  ${3.33}
    ${ping_loss_acceptable_limit}=  set variable  ${80.0}
    Run keyword unless  ${ping_loss_result} < ${ping_loss_acceptable_limit}  Fail

```



###### Numerical Operations

The addition (+), subtraction (-), multiplication (*), and division (/) operators can be used inside the {} braces when creating a numerical value. Another way to accomplish numerical operations in Robot is to use the `Evaluate` keyword. This keyword takes in a string, and evaluates the result of running it as a Python expression.

> Test using the addition operator:

```
# 02_arithmatic.robot
*** Variables ***
${ten}  10

*** Test Cases ***
Addition
    ${result}=  evaluate  ${ten} + 5
    Log to console  ${result}
    Log to console  ${10+5}
```

> Test using the subtraction operator:

```
# 02_arithmatic.robot
*** Test Cases ***
Subtraction
    ${result}=  evaluate  ${ten} - 5
    Log to console  ${result}
    Log to console  ${10-5}
```

> Test using the multiplication operator:

```
# 02_arithmatic.robot
*** Test Cases ***
Multiplicaiton
    ${result}=  evaluate  ${ten} * 5
    Log to console  ${result}
    Log to console  ${10*5}
```

> Test using the division operator:

```
# 02_arithmatic.robot
*** Test Cases ***
Division
    ${result}=  evaluate  ${ten} / 5
    Log to console  ${result}
    Log to console  ${10/5}
```



###### Solution

```
# 02_arithmatic.robot
*** Variables ***
${ten}  10

*** Test Cases ***
Addition
    ${result}=  evaluate  ${ten} + 5
    Log to console  ${result}
    Log to console  ${10+5}

Subtraction
    ${result}=  evaluate  ${ten} - 5
    Log to console  ${result}
    Log to console  ${10-5}

Multiplicaiton
    ${result}=  evaluate  ${ten} * 5
    Log to console  ${result}
    Log to console  ${10*5}

Division
    ${result}=  evaluate  ${ten} / 5
    Log to console  ${result}
    Log to console  ${10/5}
```



###### Testing With Numbers

Being that numbers can be stored as either numerical or string data types, its important to check that variables are of an expected type.

> Verify that a number being stored as a string is actually being stored in a string variable:

```
# 02_testing_with_numbers.robot
*** Variables ***
${number_as_number}  ${13}
${number_as_string}  13

*** Test Cases ***
Verify Integers, Scalars, and Strings as Numbers
    ${number_of_vlans}=  set variable  ${5}
    ${number_of_neighbors}=  set variable  ${20}
    ${data_type}=   evaluate   type($number_as_string).__name__
```

When running comparisons on numbers, you can convert between strings and numbers when doing checks. As we saw in task 2, you can add `As Numbers` or `As Strings` to run a conversion on the values before running the comparison.

> Append `As Numbers` to a comparison keyword to check numerical values:

```
# 02_testing_with_numbers.robot
*** Test Cases ***
Verify Integers, Scalars, and Strings as Numbers
    ${number_of_vlans}=  set variable  ${5}
    ${number_of_neighbors}=  set variable  ${20}
    ${data_type}=   evaluate   type($number_as_string).__name__

    Should be equal as numbers  ${number_as_number}  ${number_of_vlans+8}
    Should be equal as numbers  ${number_as_number}  ${number_of_neighbors-7}
    Should be equal as numbers  ${20}  ${10*2}
    Should be equal as numbers  ${20}  ${40/2}
```

> Append `As Strings` to a comparison keyword to check numerical values:

```
# 02_testing_with_numbers.robot
*** Test Cases ***
Compare Numbers and Strings
    Should not be equal  ${number_as_number}  ${number_as_string}
    Should be equal as numbers  ${number_as_number}  ${number_as_string}

```



###### Solution

```
# 02_testing_with_numbers.robot
*** Variables ***
${number_as_number}  ${13}
${number_as_string}  13

*** Test Cases ***
Verify Integers, Scalars, and Strings as Numbers
    ${number_of_vlans}=  set variable  ${5}
    ${number_of_neighbors}=  set variable  ${20}
    ${data_type}=   evaluate   type($number_as_string).__name__

    Should be equal as numbers  ${number_as_number}  ${number_of_vlans+8}
    Should be equal as numbers  ${number_as_number}  ${number_of_neighbors-7}
    Should be equal as numbers  ${20}  ${10*2}
    Should be equal as numbers  ${20}  ${40/2}

Compare Numbers and Strings
    Should not be equal  ${number_as_number}  ${number_as_string}
    Should be equal as numbers  ${number_as_number}  ${number_as_string}


```



##### Step 3 - Booleans

###### Boolean Logic

Booleans are a data type with only 2 possible values, `True` and `False`. These are used to make decisions in your Robot test cases. A verification keyword can return a boolean value, which can then be used to either fail or pass a test case. You can also create more complex boolean expressions using both logical operators. Logical operators include `and`, `or`, and `not`. For understanding how these work, we will look at what are called Truth Tables:

AND

True	and	True	=	True

True	and	False	=	False

False	and	True	=	False

False	and	False	=	False



OR

True	or	True	=	True

True	or	False	=	True

False	or	True	=	True

False	or	False	=	False



NOT

not	True	=	False

not	False	=	True



Other operators include symbols like `<`, `>`, `==`, `<=`,  and `>=`. These operators can be used to convert non-boolean values to booleans. For example:

5	<	10	=	True

nyc-sw01	==	nyc-rt02	=	False



Robot includes many keywords that act as boolean tests, running a certain test and either passing or failing the test based on the result. Since Robot is a testing framework and not a traditional programming language, it is written in a way that if it breaks it fails and moves on. In a language like python you would have to handle errors that occur, here errors are an indication of a failed test and it gets reported in the output.

In Robot a boolean uses the same syntax as a number, the `$` symbol and the `{}` brackets surrounding the values `True` or `False`. Unlike numbers booleans don't need to be written in this notation, they can be written without it and still work as boolean values. These values are also case insensitive, can be written as `true` or `false`. We are going to start by using the keyword `Should Be Equal` to compare the boolean values `True` and `False`.

> Write a test case comparing the boolean values `True` and `False` in all possible combinations (there are four):

```
# 02_boolean_logic.robot
*** Test Cases ***
Verify True and False Are Not Equal
    Should be equal   ${True}  ${True}
    Run keyword and expect error  *  should be equal   ${True}  ${False}
    Should be equal   ${False}  ${False}
    Run keyword and expect error  *  should be equal   ${False}  ${True}
```

Values in Robot have a "truthiness", which means that if they are evaluated as a boolean they have a value. For strings, any string that is not empty is considered `True` and empty strings are considered `False`. Same with lists and dictionaries, numbers are considered `True` if they are a non-zero positive number. Zero and negative numbers would evaluate to a `False` boolean value.

> Write a test case combining booleans with other data types in boolean expressions:

```
# 02_boolean_logic.robot
*** Test Cases ***
Verify the Truthiness of Other Data Types
    Should be true  True and "true"
    Should be true  True and "device"  # nonempty string
    Should be true  True and ${TRUE}  # python true
    Should be true  True and 1337  #non-zero positive numbers are true
```

> Use the logical operators `and` and `or` to verify some values from the Truth Tables above:

```
# 02_boolean_logic.robot
*** Test Cases ***
Verify the Value of Boolean Expressions
    Should be true  ${True} and ${True}
    Should not be true  ${True} and ${False}
    Should be true  ${True} or ${False}
    Should be true  ${True} or ${True}
    Should be true  not ${False}
```

> Create a test case similar to step 3, this time make more complex expressions by using multiple operators:

```
# 02_boolean_logic.robot
*** Test Cases ***
Verify the Value of Complex Boolean Expressions
    Should be true  (True or False) and True
    Should be true  True or False and True
    Should be true  True and not False
```



###### Solution

```
# 02_boolean_logic.robot
*** Test Cases ***
Verify True and False Are Not Equal
    Should be equal   ${True}  ${True}
    Run keyword and expect error  *  should be equal   ${True}  ${False}
    Should be equal   ${False}  ${False}
    Run keyword and expect error  *  should be equal   ${False}  ${True}

Verify the Truthiness of Other Data Types
    Should be true  "True" and "true"
    Should be true  "True" and "device"  # nonempty string
    Should be true  "True" and ${TRUE}  # python true
    Should be true  "True" and ${1337}  #non-zero positive numbers are true

Verify the Value of Boolean Expressions
    Should be true  ${True} and ${True}
    Should not be true  ${True} and ${False}
    Should be true  ${True} or ${False}
    Should be true  ${True} or ${True}
    Should be true  not ${False}

Verify the Value of Complex Boolean Expressions
    Should be true  (True or False) and True
    Should be true  True or False and True
    Should be true  True and not False

```



###### Strings vs Booleans

It is important to understand how strings and booleans interact, specifically how strings can be used when evaluating boolean expressions.

> Define the value `true` as both a string and a boolean, check the type using the `Evaluate` keyword:

```
# 02_strings_vs_bools.robot
*** Variables ***
${bool_true}  ${true}
${string_true}  true

*** Test Cases ***
String True
    Log  ${string_true}
    ${data_type}=   evaluate   type($string_true).__name__
    Log  ${data_type}

Boolean True vs. String True
    Log  ${bool_true}
    ${data_type}=   evaluate   type($bool_true).__name__
    Log  ${data_type}
```

There are several ways to convert between different data types in Robot, for the case of converting to booleans there is a keyword named `Convert To Boolean`.

> Convert a string value to a boolean value and verify the results using the `Should Be Equal` keyword:

```
# 02_strings_vs_bools.robot
*** Test Cases ***
Convert String True to Boolean True
    Log  ${bool_true}
    Log  ${string_true}
    ${data_type}=   evaluate   type($bool_true).__name__
    Log  ${data_type}
    ${string_true} =   convert to boolean  ${string_true}
    ${data_type}=   evaluate   type($string_true).__name__
    Set suite variable   ${string_true}  ${string_true}
    Log  ${data_type}
    Log  ${bool_true}
    Log  ${string_true}

Verify Bool and String Are Now Equal
    Log  ${string_true}
    Log  ${bool_true}
    Should be equal   ${bool_true}  ${string_true}
```



###### Solution

```
# 02_strings_vs_bools.robot
*** Variables ***
${bool_true}  ${true}
${string_true}  true

*** Test Cases ***
String True
    Log  ${string_true}
    ${data_type}=   evaluate   type($string_true).__name__
    Log  ${data_type}

Boolean True vs. String True
    Log  ${bool_true}
    ${data_type}=   evaluate   type($bool_true).__name__
    Log  ${data_type}

Convert String True to Boolean True
    Log  ${bool_true}
    Log  ${string_true}
    ${data_type}=   evaluate   type($bool_true).__name__
    Log  ${data_type}
    ${string_true} =   convert to boolean  ${string_true}
    ${data_type}=   evaluate   type($string_true).__name__
    Set suite variable   ${string_true}  ${string_true}
    Log  ${data_type}
    Log  ${bool_true}
    Log  ${string_true}

Verify Bool and String Are Now Equal
    Log  ${string_true}
    Log  ${bool_true}
    Should be equal   ${bool_true}  ${string_true}

```



### Task 2 - Creating Lists

Lists are a very useful data type available in most programming languages, they allow you to store collection of elements. These collections are ordered, meaning that if you put them in a specific place they will remain there until modified. Lists can also contain nonuniform data types, you can have a list with strings and numbers or any other grouping of data types available in Robot including other lists.

##### Step 1

Lists in Robot are denoted with the `@` symbol instead of the `$` symbol seen on other variables so far. The `$` on other variables has indicated that it is a scalar value, which means that it only holds one value. We can use the `$` symbol to create or reference a list in some cases, but the `@` symbol is the preferred symbol for defining a list. The only other difference between creating a string and a list in the `Variables` section is that multiple values are provided to the list.

> Define a list of mac addresses in the `Variables` section:

```
# 02_creating_lists.robot
*** Settings ***
Library  Collections

*** Variables ***
@{mac_list}  00.00.00.00.11.11  00.00.00.00.22.22  00.00.00.00.33.33  00.00.00.00.44.44
```



##### Step 2

When working with scalar values we were able to just use the `Set Variable` keyword to create them inside test cases, lists require the `Create List` keyword instead. This keyword functions like `Set Variable` except it takes in multiple values to store in the list instead of a single value.

> Create a list of IP addresses inside a keyword.

```
# 02_creating_lists.robot
*** Test Cases ***
Create A List Of Valid IP Addresses
    ${ip_list}=  create list  10.1.100.1  10.2.1001.  10.3.100.1
    Log list  ${ip_list}
```

A note on the above example, a `$` symbol is used to define the list `${ip_list}`, this could have been replaced with a `@` and the same list would have been created. The `$` symbol is also used to pass the list to the `Log` keyword, this symbol can't be replaced with a `@` symbol. When a list is passed as an input to a keyword, it needs to be referenced with the `$` symbol regardless of what symbol was used to define it. This is because Robot needs to translate the list into a string (a scalar value) to pass it as input.



##### Solution

```
# 02_creating_lists.robot
*** Settings ***
Library  Collections

*** Variables ***
@{mac_list}  00.00.00.00.11.11  00.00.00.00.22.22  00.00.00.00.33.33  00.00.00.00.44.44

*** Test Cases ***
Create A List Of Valid IP Addresses
    ${ip_list}=  create list  10.1.100.1  10.2.1001.  10.3.100.1
    Log list  ${ip_list}
```



### Task 3 - Modifying Lists

In this task we will cover some of the common keywords for working with lists.



##### Step 1

The `Collections` library contains many useful keywords for working with lists.

> Include the `Collections` and `String` library in your robot file:

```
# 02_modifying_lists.robot
*** Settings ***
Library  Collections
Library  String
```



##### Step 2

The first keyword we are going to use is `Get Length`,this keyword takes a string, list, or dictionary as input and returns the length of the input. For strings it returns the number of characters in the string, for lists it returns the number of elements in the list, and for dictionaries it returns the number of items in the dictionary.

> Create a list of MAC addresses, then write a test to verify the length of the list using `Get Length`:

```
# 02_modifying_lists.robot
*** Variables ***
@{mac_list}  00.00.00.00.11.11  00.00.00.00.22.22  00.00.00.00.33.33  00.00.00.00.44.44

*** Test Cases ***
Get the length of a list
    ${number_of_mac_addresses}=  get length  ${mac_list}
    Should be equal as integers  ${number_of_mac_addresses}  4
```



##### Step 3

The `Get From List` keyword is used to retrieve elements from a list. It takes a list and a number as input, the list is where the element is being retrieved from and the number is the index denoting which element in the list to retrieve. Lists are indexed starting at 0 instead of 1. If you want to retrieve the first element of the list you have to use the index 0, if you want to retrieve the third element of a list you have to use the index 2.

> Create a test case that retrieves several MAC addresses from your list of MAC addresses:

```
# 02_modifying_lists.robot
*** Test Cases ***
Get the first and third MAC address in the list:
    ${first_mac}=  get from list  ${mac_list}  0
    ${third_mac}=  get from list  ${mac_list}  2
    Log  ${first_mac}
    Log  ${third_mac}
```



##### Step 4

To add elements to the end of a list, you can use the `Append To List` keyword. You pass the list you want modified and the new element to this keyword, this keyword doesn't return a list, instead it updates the list passed in.

> Add a few more MAC addresses to your list of MAC addresses:

```
# 02_modifying_lists.robot
*** Test Cases ***
Add MAC to List
    Append to list  ${mac_list}  00.00.00.00.55.55
    Append to list  ${mac_list}  00.00.00.00.55.55
    Log list  ${mac_list}
```



##### Step 5

If you want to add an element to a specific spot in a list, you need to use the `Insert Into LIst` keyword instead of the `Append To List` keyword. This keyword takes in the list you want to modify, the index where you want to put the new element, and the new element to insert into the list.

> Use the `Insert Into List` keyword to add a new MAC address as the second element of your list:

```
# 02_modifying_lists.robot
*** Test Cases ***
Add MAC to Second Element
    Insert into list  ${mac_list}  1  00.00.00.00.66.66
    Log list  ${mac_list}
```

When testing this step, you will see that the items you added in your previous test case are not in the list. If you remember back to the lesson about scoping, the changes made in the test cases only affects the variables in that test case. Although the variable is defined in the `Variables` section and has suite level scoping, the changes made in a single test case aren't carried over to the rest.



##### Step 6

Now lets look at removing elements from lists, you can do this by using the `Remove From List` keyword. This keyword takes in the list to be modified and the index of the element you want to remove as inputs. Unlike the keywords to add elements to the list, this keyword has a return value. The keyword returns the element that is removed from the list.

> Remove the third MAC address from the list:

```
# 02_modifying_lists.robot
*** Test Cases ***
Remove MAC address from the list
    ${removed_mac_address}=  remove from list  ${mac_list}  2
    Log  ${removed_mac_address}

```



##### Step 7

In some cases you will want to update the value of an element in a list without removing or adding elements, you can do this with the `Set List Value` keyword. This keyword takes the list to be modified, the index of the element to update, and the new value you want to update the current element with as inputs.

> Update the second MAC address in your list:

```
# 02_modifying_lists.robot
*** Test Cases ***
MAC Address in List
    Set list value  ${mac_list}  1  00.00.00.00.00.20
    Log list  ${mac_list}

```



##### Step 8

Lists by default are unordered, so they  won't change position in the list. Sometimes its more useful to work with a list of sorted elements, you can sort your lists in Robot using the `Sort List` keyword. This keyword only takes the list as input, and sorts it alphanumerically in ascending order.

> Sort the list of MAC addresses:

```
# 02_modifying_lists.robot
*** Test Cases ***
Sort MAC Address List
    Sort list  ${mac_list}
    Log list  ${mac_list}

```



##### Step 9

Verifying that expected conditions are true is an important part to testing, to check if an element already exists inside a list you use the `List Should Contain Value` keyword. This keyword takes in the list that is being verified and the element that is being checked.

> Verify that a specific MAC address exists in your list:

```
# 02_modifying_lists.robot
*** Test Cases ***
Check that the list contains a specific MAC address
    List should contain value  ${mac_list}  00.00.00.00.11.11
    Log list  ${mac_list}

```



##### Step 10

Lists can contain duplicate items, some tests you might run could populate a list with data where your expecting a certain number of duplicate entries. For cases like this you can use the `Count Values In List` keyword to count the occurrences of a given element in the list. This keyword takes in the list to be searched and the element that you want to count in the list.

> Count the occurrences of an element in a list:

```
# 02_modifying_lists.robot
*** Test Cases ***
Count Duplicates in a List
    @{nexus_linecards}=  create list  N7K-SUP1
                                ...  N7K-M132XP-12
                                ...  N7K-M148GT-11
                                ...  N7K-M148GT-11
                                ...  N7K-F132XP-15
                                ...  N7K-SUP1
                                ...  N7K-M132XP-12
                                ...  N7K-M132XP-12
                                ...  N7K-M148GT-11
                                ...  N7K-M148GT-11
    ${card_count}=  count values in list  ${nexus_linecards}  N7K-M132XP-12
    Log  ${card_count}
```

A note on this above example, there is a new syntax being introduced which is the `...` before the items in the list. In Robot you can separate your commands onto multiple lines, to do this you put the `...` characters on the second line and continue writing your command. This is useful for longer commands, like defining a long list.



##### Task 11

Before we saw the keyword `List Should Contain Value` which verified that a single element existed in a list, if you wanted to check if multiple elements existed in a list you could use the keyword `List Should Contain Sub List`. This keyword takes two lists as input and checks if every element from the second list exists in the first list.

> Verify that a list of MAC addresses all exist in your list:

```
# 02_modifying_lists.robot
*** Test Cases ***
Check that list contains a sub list of MAC addresses
    @{target_mac_addresses}=  create list  00.00.00.00.11.11  00.00.00.00.44.44
    List should contain sub list  ${mac_list}  ${target_mac_addresses}

```



##### Task 12

When looking at strings, we saw the `Split String` keyword used to turn a string into a list of strings. The reverse operation exists for lists using the `Catenate` keyword. Instead of passing in multiple elements to the `Catenate` keyword like we saw in the string lab, we can instead pass a list into the keyword to combine all the elements of the list into a single string.

> Use the `Split String` and `Catenate` keyword to convert between a string to a list and then back to a string:

```
# 02_modifying_lists.robot
*** Test Cases ***
Convert a list of strings into a single string
    ${commands_string}=  set variable  
    ...  interface Eth1/1 \n description configured by Python \n shutdown
    @{commands_list}=  split string  ${commands_string}  \n
    ${commands_string}=  catenate  SEPARATOR=\n  @{commands_list}
```

A note on the syntax above, the `@` symbol is being used when referencing the `@{commands_list}` list as an input to a keyword. Before it was mentioned that lists are passed into keywords as input using the `$` symbol, but there are a few exceptions to this convention. The `@` symbol is used when you are passing the list in to be used as a sequence of elements, the `$` symbol is just used to pass it in as an ordinary list. It is hard topic to get used to, but if you are ever confused about what kind of input a keyword uses you can check the documentation for that keyword.



##### Solution

```
# 02_modifying_lists.robot
*** Settings ***
Library  Collections
Library  String

*** Variables ***
@{mac_list}  00.00.00.00.11.11  00.00.00.00.22.22  00.00.00.00.33.33  00.00.00.00.44.44

*** Test Cases ***
Get the length of a list
    ${number_of_mac_addresses}=  get length  ${mac_list}
    Should be equal as integers  ${number_of_mac_addresses}  4

Get the first and third MAC address in the list:
    ${first_mac}=  get from list  ${mac_list}  0
    ${third_mac}=  get from list  ${mac_list}  2
    Log to console  ${first_mac}
    Log to console  ${third_mac}

Add MAC to List
    Append to list  ${mac_list}  00.00.00.00.55.55
    Append to list  ${mac_list}  00.00.00.00.55.55
    Log list  ${mac_list}

Add MAC to Second Element
    Insert into list  ${mac_list}  1  00.00.00.00.66.66
    Log list  ${mac_list}

Remove MAC address from the list
    ${removed_mac_address}=  remove from list  ${mac_list}  2
    Log  ${removed_mac_address}

MAC Address in List
    Set list value  ${mac_list}  1  00.00.00.00.00.20
    Log list  ${mac_list}

Sort MAC Address List
    Sort list  ${mac_list}
    Log list  ${mac_list}

Check that the list contains a specific MAC address
    List should contain value  ${mac_list}  00.00.00.00.11.11
    Log list  ${mac_list}

Count Duplicates in a List
    @{nexus_linecards}=  create list  N7K-SUP1
                                ...  N7K-M132XP-12
                                ...  N7K-M148GT-11
                                ...  N7K-M148GT-11
                                ...  N7K-F132XP-15
                                ...  N7K-SUP1
                                ...  N7K-M132XP-12
                                ...  N7K-M132XP-12
                                ...  N7K-M148GT-11
                                ...  N7K-M148GT-11
    ${card_count}=  count values in list  ${nexus_linecards}  N7K-M132XP-12
    Log to console  ${card_count}

Check that list contains a sub list of MAC addresses
    @{target_mac_addresses}=  create list  00.00.00.00.11.11  00.00.00.00.44.44
    List should contain sub list  ${mac_list}  ${target_mac_addresses}

Convert a list of strings into a single string
    ${commands_string}=  set variable  
    ...  interface Eth1/1 \n description configured by Python \n shutdown
    @{commands_list}=  split string  ${commands_string}  \n
    ${commands_string}=  catenate  SEPARATOR=\n  @{commands_list}

```



### Task 4 - Storing Network Facts

So far we have gone through a variety of list uses and keywords, since it is a data type its most common use will be to store data. More so that strings or numbers, lists will be used to store larger sets of data making them more useful for representing more complex sets of data.



##### Step 1

In this step, we will look at a way to store the facts of a network device using a list. The facts we will be looking to store are `os`, `platform`, `vendor`, `hostname`, `location`, and `device_type`.

> Create a list in the variables section that contains a value for each fact:

```
# 02_storing_facts.robot
*** Variables ***
@{device_1_facts}  nxos  nexus  cisco  sw01  nyc  switch
```

When storing data in this format, you can keep the index of each fact consistent across lists so that you can access each one the same way. For example, if you store all of the device types in the 6th position (index of 5) you will know that the value stored at this position is the device type.

> Two more examples include:

```
# 02_storing_facts.robot
*** Variables ***
@{device_2_facts}  nxos  nexus  cisco  sw02  nyc  switch
@{device_3_facts}  ios  catalyst  cisco  rt01  nyc  router
```



##### Step 2

There are many different ways to store the same data, the data structure you choose should make sense for how you plan on using the data. Another way you could store device facts using lists is by storing each fact in its own list, having an entry for each device being represented. For example, you could have a list that contains all the hostnames for the devices and a separate list that contains all of the vendors.

> Create a list for each fact:

```
# 02_storing_facts.robot
*** Variables ***
@{os}  nxos  nxos  ios
@{platform}  nexus  nexus  catalyst
@{vendor}  cisco  cisco  cisco
@{hostname}  sw01  sw02  rt01
@{location}  nyc  nyc  nyc
@{device_type}  switch  switch  router
```

In the first format from step 1, we kept the location of each fact consistent making it easier to access data. In this format we would want to keep the location of each devices data consistent. For example, the 2nd item in each list (index of 1) is the fact that belongs to device 2. Like in step 1, this consistency will make it possible to use the data in this format.

Each data structure has its pros and cons, so you will need to work with the one that makes the most sense for the specific test your trying to write. It is common to use loops to traverse lists, a topic that will be covered later in the course. In the next lab we will cover dictionaries which make storing data like device facts much easier.

> Note: This file won' t run since there are no test cases, its just to demonstrate how to create these types of variables.



##### Solution

```
# 02_storing_facts.robot
*** Variables ***
@{device_1_facts}  nxos  nexus  cisco  sw01  nyc  switch
@{device_2_facts}  nxos  nexus  cisco  sw02  nyc  switch
@{device_3_facts}  ios  catalyst  cisco  rt01  nyc  router

@{os}  nxos  nxos  ios
@{platform}  nexus  nexus  catalyst
@{vendor}  cisco  cisco  cisco
@{hostname}  sw01  sw02  rt01
@{location}  nyc  nyc  nyc
@{device_type}  switch  switch  router
```
