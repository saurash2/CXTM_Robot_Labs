## Lab 3 - Dictionaries

### Task 1 - Creating Dictionaries

Dictionaries are similar to lists in that they are collections. The difference between lists and dictionaries is that lists where indexed by numbers corresponding the the position in the list, dictionaries are indexed based on keys. A dictionary is made up of items, key / value pairs which are stored in an unordered collection. Each key is unique and corresponds to a stored value. This data type is useful since it allows complex data to be stored in a way that maintains its context.



##### Step 1

The `Collections` library contains many useful keywords for working with dictionaries, just like we saw with lists in the lists lab.

> Inside TC03 (Dictionaries) within your CXTM project, click on `Configure Automation` and include the `Collections` library in your Robot file:

```
# 03_creating_dictionaries.robot
*** Settings ***
Library  Collections
```



##### Step 2

To define a dictionary, the `&` symbol is used instead of the `$` or `@` symbols. To create one in the `Variables` section you provide a series of key / value pairs separated by two spaces. There are several ways to write the key / value pairs in Robot but the syntax `key=value` is common.

> Define a dictionary in the `Variables` section containing device facts:

```
# 03_creating_dictionaries.robot
*** Variables ***
&{facts}  vendor=cisco  os=nxos  platform=nexus

*** Test Cases ***
Log Facts Dictionary
    Log dictionary  ${facts}
```

In the above example the `Log Dictionary` keyword is being used to print the dictionary to the execution log. You can check that your keyword is created successfully by checking your log.html.



##### Step 3

Creating a dictionary in a test case requires the `Create Dictionary` keyword. Just like in the `Variables` section, you provide key / value pairs in the form of `key=value`.

> Define a dictionary in the `Test Cases` section containing device facts:

```
# 03_creating_dictionaries.robot
*** Test Cases ***
Create Dictionary in Test Case
    &{switch}=  create dictionary  hostname=sw1  mgmt_ip=10.1.100.1/24     
    ...  mac=00:00:00:00:00:01
    Log dictionary  ${switch}
```



##### Solution

```
# 03_creating_dictionaries.robot
*** Settings ***
Library  Collections

*** Variables ***
&{facts}  vendor=cisco  os=nxos  platform=nexus

*** Test Cases ***
Log Facts Dictionary
    Log dictionary  ${facts}

Create Dictionary in Test Case
    &{switch}=  create dictionary  hostname=sw1  mgmt_ip=10.1.100.1/24       
    ...  mac=00:00:00:00:00:01
    Log dictionary  ${switch}
```



### Task 2 - Using Dictionaries

##### Step 1

The most powerful feature of dictionaries is that it is a key / value store of information, making it convenient to save and retrieve data. In Robot you can set a key / value pair for an existing dictionary using the `Set To Dictionary` keyword, which takes in the dictionary to be modified, the key, and the value. Just like with the list data type, most of the time when a dictionary is being passed as an input to a keyword it will use the `$` symbol instead of the `&` regardless of how it was defined.

> Create a dictionary, then in a test case add a new key / value pair:

```
# 03_using_dictionaries.robot
*** Settings ***
Library     Collections

*** Variables ***
&{facts}    hostname=Pod0X-N9Kv    vendor=cisco      os=nxos       platform=nexus

*** Test Cases ***
Update Dictionary with Inserted New Key / Value Pair
    Set to dictionary  ${facts}  version  7.1

```



##### Step 2

Just like with the list data type, the `Get Length` keyword can be used to get the number of items in a dictionary. The keyword just takes in the dictionary in question, and returns an integer corresponding the the number of key / values pairs.

> Get the length of your facts dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get the number of key / value pairs in the facts dictionary
    ${number_of_facts}=     get length     ${facts}
    Should be equal as integers     ${number_of_facts}      5
```



##### Step 3

If you need to update a key / value pair that already exists in a dictionary, the syntax is the same as adding a new key / value pair. You use the `Set To Dictionary` keyword similar to what was done in Step 1. If the key exists it updates its value, otherwise it adds the new key / value pair.

> Update the `version` key of your dictionary to have the value `7.3`:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Update the version key's value
    Set to dictionary  ${facts}  version  7.3
```



##### Step 4

After you store information in your dictionary, you will need a way to retrieve it for your test cases. For this you use the `Get From Dictionary` keyword, you provide the dictionary you are accessing and the key that corresponds the the value you want.

> Get the value of the `os` key from your dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get the OS from the facts dictionary
    ${os}=  get from dictionary  ${facts}  os
```



##### Step 5

Getting values from a dictionary can also be done using an alternate syntax.

> Access the value of he hostname key using the following syntax:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get the Hostname from the facts dictionary
    ${dev_hostname}=  set variable  ${facts.hostname}  
    # variable can't be named hostname since it would conflict with facts.hostname
```



##### Step 6

When your done with a piece of data, you might want to remove it from your dictionary. To do this you use the `Pop From Dicitonary` keyword passing in the dictionary you are modifying and the key of the key / value pair you want to remove. You can't have a value in a dictionary that doesn't correspond to a key, when you remove the key you also remove the value.

> Remove the `os` key from the dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get and remove the OS key from the facts dictionary
    ${os}=  pop from dictionary  ${facts}  os

```



##### Step 7

Besides the usually adding, removing, and getting functionalities you have available for the dictionary, you can also retrieve  the data in different formats. One way of doing this is using the `Get Dictionary Keys` keyword to return a list of keys in the dictionary. This keyword takes in a dictionary as input and returns just the keys as a list.

> Use the `Get Dictionary Keys` keyword to get all the keys from the dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get list of all keys in facts dictionary:
    ${facts_keys}=  get dictionary keys  ${facts}

```



##### Step 8

The `Get Dictionary Values` takes in the dictionary you are accessing and returns a list of all values in the dictionary. This allows you to access the values separately from the dictionary, this can be helpful in some cases but you lose the context that the keys provide.

> Retrieve a list of all values in the dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get list of all values in facts dictionary:
    ${values}=  get dictionary values  ${facts}

```



##### Step 9

If you want to retrieve both sets of data, you can use the `Get Dictionary Items` keyword to retrieve a list of key / value pairs. This keyword also takes a dictionary as input and returns a list. This time it is a list of key / value pairs instead of just a list of keys or values.

> Retrieve both keys and values from the dictionary using the `Get Dictionary Items` keyword:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get a list of all keys and values in facts dictionary
    ${items}=  get dictionary items  ${facts}

```



##### Step 10

The alternate syntax can be used to call python dictionary functions as well, you can use this to replace keywords like `Get Dictionary Keys`, `Get Dictionary Values`, and `Get Dictionary Items`.

> Retrieve the keys, values, and items from the dictionary using the alternate syntax:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Get lists of all keys, values, and items in facts dictionary:
    ${facts_keys}=  set variable  ${facts.keys()}
    ${facts_values}=  set variable  ${facts.values()}
    ${facts_items}=  set variable  ${facts.items()}

```



##### Step 11

Having multiple sources of information can be harder to work with, sometimes you can combine dictionaries using the `Set To Dictionary` keyword. You can pass the original dictionary in as the first input, and then pass a second dictionary in using the `&` symbol instead of the `$` symbol. All the key / value pairs form the second dictionary will be added to the first dictionary. Any keys that exist in both will have the value from the second dictionary since the first will be overwritten.

> Create a second dictionary with device information and combine it with the original dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Combine the values from the facts and interfaces dictionary to create a single dicitonary
    &{interfaces}=  create dictionary  Eth1=Up  Eth2=Down  Gig1/1=Up
    Set to dictionary   ${facts}     &{interfaces}
    Set suite variable   ${device}   ${facts}

```



##### Step 12

Now to get to some testing specific keywords, you can use `Dictionary Should Contain Key` to verify that a specific key exists in a dictionary. This keyword takes in the dictionary you are checking and the key you want to verify. The test case will continue if the key exists or fail if it doesn't.

> Verify that the key `Eth1` exists in the dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Check if device dictionary contains the key Eth1
   Dictionary should contain key       ${device}  Eth1

```



##### Step 13

There is also a keyword to verify that a value exists in a dictionary. You can use the keyword `Dictionary Should Contain Value` by passing in a dictionary to check and a value you are looking for. Like other verification keywords, if the value doesn't exist then the test case will fail.

> Verify that the value `Up` exists in your dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Check if device dictionary contains the value Up
   Dictionary should contain value         ${device}       Up

```



##### Step 14

Similar to the above two keywords, there is also a `Dictionary Should Contain Item` keyword to verify that a specific key / value pair exists in a dictionary.

> Verify that the key / value pair `Eth1 / Up` exists:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Check if device dictionary contains the key Eth1 with the value Up
    Dictionary should contain item   ${device}      Eth1    Up

```



##### Step 15

If you want to check that multiple key value pairs exist in a dictionary you can use the `Dictionary Should Contain Sub Dictionary` keyword, this will check that all key / value pairs of the second dictionary exist in the first.

> Verify that the `${facts}` dictionary is a sub dictionary of the `${device}` dictionary:

```
# 03_using_dictionaries.robot
*** Test Cases ***
Check if device dictionary contains subset of key / value pairs
    Dictionary should contain sub dictionary  ${device}  ${facts}

```



##### Solution

```
# 03_using_dictionaries.robot
*** Settings ***
Library     Collections

*** Variables ***
&{facts}    hostname=Pod0X-N9Kv    vendor=cisco      os=nxos       platform=nexus

*** Test Cases ***
Update Dictionary with Inserted New Key / Value Pair
    Set to dictionary       ${facts}     version    7.1

Get the number of key / value pairs in the facts dictionary
    ${number of facts}=     get length     ${facts}
    Should be equal as integers     ${number_of_facts}      5

Update the version key's value
    Set to dictionary  ${facts}  version  7.3

Get the OS from the facts dictionary
    ${os}=  get from dictionary  ${facts}  os

Get the Hostname from the facts dictionary
    ${dev_hostname}=  set variable  ${facts.hostname}  
    # variable can't be named hostname since it would conflict with facts.hostname

Get and remove the OS key from the facts dictionary
    ${os}=  pop from dictionary  ${facts}  os

Get list of all keys in facts dictionary:
    ${facts_keys}=  get dictionary keys  ${facts}

Get list of all values in facts dictionary:
    ${values}=  get dictionary values  ${facts}

Get a list of all keys and values in facts dictionary
    ${items}=  get dictionary items  ${facts}

Get lists of all keys, values, and items in facts dictionary:
    ${facts_keys}=  set variable  ${facts.keys()}
    ${facts_values}=  set variable  ${facts.values()}
    ${facts_items}=  set variable  ${facts.items()}

Combine the values from the facts and interfaces dictionary to create a single dicitonary
    &{interfaces}=  create dictionary  Eth1=Up  Eth2=Down  Gig1/1=Up
    Set to dictionary   ${facts}     &{interfaces}
    Set suite variable   ${device}   ${facts}

Check if device dictionary contains the key Eth1
   Dictionary should contain key       ${device}  Eth1

Check if device dictionary contains the value Up
   Dictionary should contain value         ${device}       Up

Check if device dictionary contains the key Eth1 with the value Up
    Dictionary should contain item   ${device}      Eth1    Up

Check if device dictionary contains subset of key / value pairs
    Dictionary should contain sub dictionary  ${device}  ${facts}

```



### Storing Network Facts

In the previous lab on lists we stored device facts using lists, now we will see how dictionaries can be used to improve the storage of this data. The facts we will be looking to store are `os`, `platform`, `vendor`, `hostname`, `location`, and `device_type`.

The first method of storing these facts using lists, was to store the value of each fact in a specific position of the list. We use a dictionary to store each of these values, but instead of relying on a consistent index to position the data we can use a key. Using a key helps us to maintain the context of the information without having to maintain a consistent order and mapping numerical indexes to values.

Example of a dictionary holding facts for a device:

```
# 03_storing_facts.robot
*** Variables ***
&{device_1_facts}  os=nxos  platform=nexus  vendor=cisco  hostname=sw01  location=nyc  device_type=switch
```

This format will allow you to store this data and use it by referencing the descriptive key name rather than by using a mapped index. This not only helps when you are developing your tests, but it makes the code more readable for whoever needs to maintain the test in the future.

Two more examples:

```
# 03_storing_facts.robot
*** Variables ***
&{device_2_facts}  os=nxos  platform=nexus  vendor=cisco  hostname=sw02  location=nyc  device_type=switch
&{device_3_facts}  os=ios  platform=catalyst  vendor=cisco  hostname=rt01  location=nyc  device_type=router
```

The second example of lists could be mimicked using dictionaries but there isn't much need for it. Since the first example here keeps both the context of the facts and the device name there is no need to sperate each fact into its own dictionary.

In later labs you will see how to traverse these data structures using loops, as well as how to include more complex data using nested data structures.



##### Solution

```
# 03_storing_facts.robot
*** Variables ***
&{device_1_facts}  os=nxos  platform=nexus  vendor=cisco  hostname=sw01  location=nyc  device_type=switch
&{device_2_facts}  os=nxos  platform=nexus  vendor=cisco  hostname=sw02  location=nyc  device_type=switch
&{device_3_facts}  os=ios  platform=catalyst  vendor=cisco  hostname=rt01  location=nyc  device_type=router
```
