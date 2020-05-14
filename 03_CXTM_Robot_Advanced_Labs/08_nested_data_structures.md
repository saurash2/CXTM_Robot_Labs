# Lab 8 - Nested Data
Very often in network automation and automated testing you will need to traverse nested data structures to retrieve values. This could be either getting values from a shared variables file to accomplish a test case, or it might be getting values out of a parsed show command or API call.

### Task 1 - Lists Of Dictionaries
Whenever you are faced with a nested object, it is a good idea to understand the data types involved in getting the value you want. Is it a List of Dictionaries? A Dictionary of Dictionaries?

##### Step 1
In this task you will navigate a list of dictionaries. When working with a YAML file, a list of dictionaries can be identified with the following syntax (note the hyphens indicating a new list entry and the colons indicating a new set of key value pairs within that list):
```yaml
list:
- key: value
- key: value
- key: value
```
A dead giveaway is also seeing the same key listed multiple times at the same indentation level, since dictionaries require unique keys, having duplicate keys is not possible without a list of dictionaries, so each set of keys is separate from the others.

Similarly, the corresponding JSON would be:
```json
  "list": [
    {
      "key": "value"
    },
    {
      "key": "value"
    },
    {
      "key": "value"
    }
  ]
```

##### Step 2
>Create a new YAML variable file called `08_nested_variables.yaml` on your laptop with following contents and upload it to your `Project Attachments`. Also, include the file for Automation with path `/workspace`

```yaml
# 08_nested_variables.yaml
---
interfaces:
- name: Loopback0
  ip: 100.0.0.1
  mask: /32
- name: GigabitEthernet0/0/0/1
  ip: 10.21.1.2
  mask: /30
- name: MgmtEth0/0/CPU0/0
  ip: 172.31.6.73
  mask: /24
```

What type of nested object is this? What are the keys and values? How many list elements are there?

##### Step 3
> Inside TC08 (Nested Data Structures) within your CXTM project, click on `Configure Automation` and put the following code in the file:

```
# 08_list_of_dicts.robot
*** Settings ***
Library  Collections
Variables  /workspace/08_nested_variables.yaml

*** Test Cases ***
Looping Over A List Of Dictionaries
    FOR  ${interface}  IN  @{interfaces}
       Log dictionary  ${interface}
    END
```
Run the robot file and look at the nested dictionary keys and values.

##### Step 4

Now that you have used a loop to iterate over each dictionary in the list of dictionaries, you need to extract the values by looking up the keys each time the loop iterates.

> Add the following to your test case:

```
# 08_list_of_dicts.robot
*** Test Cases ***
Looping Over A List Of Dictionaries
    FOR  ${interface}  IN  @{interfaces}
       Log dictionary  ${interface}
       ${name}=  get from dictionary  ${interface}  name
       ${ip}=  get from dictionary  ${interface}  ip
      ${mask}=  get from dictionary  ${interface}  mask
    END
```
Using the `Get From Dictionary` keyword you are specifying that the `${interface}` dictionary on each iteration will look for a key of `name` and return the value to the new variable called `${name}`. The same logic is then applied to the other two keys in each dictionary `ip` and `mask`.

Run the test suite and note the logged output.

##### Step 5

> Now add some log statements using the extracted and saved values so you test case looks like this:

```
# 08_list_of_dicts.robot
*** Test Cases ***
Looping Over A List Of Dictionaries
    FOR  ${interface}  IN  @{interfaces}
      Log dictionary  ${interface}
       ${name}=  get from dictionary  ${interface}  name
       ${ip}=  get from dictionary  ${interface}  ip
       ${mask}=  get from dictionary  ${interface}  mask
       log  Interface Name ${name}
       log   Interface IP ${ip}
       log   Interface Mask ${mask}
    END
```

Run the test suite and follow the logic, noting the final logged statements.



##### Solution

```
# 08_list_of_dicts.robot
*** Settings ***
Library  Collections
Variables  /workspace/08_nested_variables.yaml

*** Test Cases ***
Looping Over A List Of Dictionaries
    FOR  ${interface}  IN  @{interfaces}
       Log dictionary  ${interface}
       ${name}=  get from dictionary  ${interface}  name
       ${ip}=  get from dictionary  ${interface}  ip
       ${mask}=  get from dictionary  ${interface}  mask
       log  Interface Name ${name}
       log   Interface IP ${ip}
       log   Interface Mask ${mask}
    END
```



### Task 2 - Dictionaries Of Dictionaries
Nested Dictionaries can be confusing without some practice and care. A key thing to remember for nested dictionaries is that there will be no hyphens on the YAML and that there will be no duplicate keys at the same indentation level.

##### Step 1
Take for example the testbed file, which has several dictionaries of dictionaries:
```yaml
devices:
  cxtm_iox:
    connections:
      vty:
        class: unicon.Unicon
        ip: 163.162.174.54
        password: 5602d925e01d8cbb11dfc1ca0f68f3c798cecb072414ee2f8c01b2aeed09fbeb
        port: 1122
        protocol: ssh
        username: cicd
      defaults:
        via: vty
    custom:
      categories:
      - ios
      - xr
      - asr
      - 9k
    os: iosxr
    passwords:
      linux: 5602d925e01d8cbb11dfc1ca0f68f3c798cecb072414ee2f8c01b2aeed09fbeb
    tacacs:
      username: cicd
    type: router
```

> Update the `08_nested_variables.yaml` file to include the above YAML testbed snippet several lines below the interfaces YAML.

##### Step 2
The testbed data structure is a bit more complicated than the previous task's example because the nesting goes several layers deep before any values are able to be accessed.

The end goal in this task is to access the `username` value. First you need to peel back the first layer of the onion, and review what the data structure is after looking up the first visible key of the device name `cxtm_iox` by using the `Get From Dictionary ` keyword on the `devices` dictionary from the YAML file and logging the output.

> Inside TC08 (Nested Data Structures) within your CXTM project, click on `Configure Automation` and put the following code in the file and run the test.

```
# 08_dict_of_dicts.robot
*** Settings ***
Library  Collections
Variables  /workspace/08_nested_variables.yaml

*** Test Cases ***
Navigating A Dictionaries Of Dictionaries
    ${connections_dict}=  get from dictionary  ${devices}  cxtm_iox
    Log dictionary  ${connections_dict}
```

##### Step 3
Open the logged output, and note the existing keys, with `connections` being the next layer needing to be extracted:

```yaml
Dictionary size is 6 and it contains following items:
connections: {'vty': {'class': 'unicon.Unicon', 'ip': '163.162.174.54', 'password': '5602d925e01d8cbb11dfc1ca0f68f3c798cecb072414ee2f8c01b2aeed09fbeb', 'port': 1122, 'protocol': 'ssh', 'username': 'cicd'}, 'defaults': {'via': 'vty'}}
custom: {'categories': ['ios', 'xr', 'asr', '9k']}
os: iosxr
passwords: {'linux': '5602d925e01d8cbb11dfc1ca0f68f3c798cecb072414ee2f8c01b2aeed09fbeb'}
tacacs: {'username': 'cicd'}
type: router
```

It can be easier to see the relationships between data with some indentation, here is the `connections` object with some better formatting:
```json
{
    "vty": {
        "class": "unicon.Unicon",
        "ip": "163.162.174.54",
        "password": "5602d925e01d8cbb11dfc1ca0f68f3c798cecb072414ee2f8c01b2aeed09fbeb",
        "port": 1122,
        "protocol": "ssh",
        "username": "cicd"
    }
}
```
So there is still two more layers remaining, `vty` as a key, and then `username` as a key.

##### Step 4

> Add the following to your robot test case to look up the `connections` key:

```
    ${vty_dict}=  get from dictionary  ${connections_dict}  connections
    Log dictionary  ${vty_dict}
```
Run the test suite and view the output.

##### Step 5
> Add the following to your robot test case to look up the `vty` key:

```
    ${username_dict}=  get from dictionary  ${vty_dict}  vty
    Log dictionary  ${username_dict}
```
Run the test suite and view the output.

##### Step 6
> Add the following to your robot test case to look up the `username` key:

```
    ${username}=  get from dictionary  ${username_dict}  username
    Log  Username is ${username}
```
Run the test suite and view the output. Review the flow from the original YAML file, tracing the keys looked up to extract the username, and compare those keys to the keys used in your Robot file.



##### Solution

```
# 08_dict_of_dicts.robot
*** Settings ***
Library  Collections
Variables  /workspace/08_nested_variables.yaml

*** Test Cases ***
Navigating A Dictionaries Of Dictionaries
    ${connections_dict}=  get from dictionary  ${devices}  cxtm_iox
    Log dictionary  ${connections_dict}
    ${vty_dict}=  get from dictionary  ${connections_dict}  connections
    Log dictionary  ${vty_dict}
    ${username_dict}=  get from dictionary  ${vty_dict}  vty
    Log dictionary  ${username_dict}
    ${username}=  get from dictionary  ${username_dict}  username
    Log  Username is ${username}

```

#### Attribute style dictionary

Robot supports attribute style dictionary indexing which can be used as well. This means you can use the attribute syntax of an object to access it. You can use the following statement to get the username from the hierarchical structure directly:

```
Accessing hierarchical dictionary
    ${username}=   set variable  ${devices.cxtm_iox.connections.vty.username}
    Log  ${username}
```

If the dictionary key has characters that are invalid for a python variable, e.g. the `-` sign, you can use the following syntax:

```
${username}=   set variable  ${devices["cxtm_iox"].connections.vty.username}
```


### Task 3 - Spirent Data

When working with larger data sets, it is important to just take things piece by piece. Spirent often provides larger data sets that are auto-generated. Think of each piece of data in relation to the next layer of nesting, rather than trying to read it all at once.

##### Step 1

The following is a sample of Spirent data, it is a list of dictionaries where each dictionary is a piece of Spirent data. This data has a consistent format, each dictionary shares the same keys, meaning that any operation you can perform on one dictionary can be done to the others as well.

```
[{'StreamId': '65536', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.14', 'IPv4Dest': '12.42.220.14', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}, {'StreamId': '65537', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.15', 'IPv4Dest': '12.42.220.15', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}, {'StreamId': '65538', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.16', 'IPv4Dest': '12.42.220.16', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}, {'StreamId': '65539', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.17', 'IPv4Dest': '12.42.220.17', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}, {'StreamId': '65540', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.18', 'IPv4Dest': '12.42.220.18', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}, {'StreamId': '65541', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.19', 'IPv4Dest': '12.42.220.19', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}, {'StreamId': '65542', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.20', 'IPv4Dest': '12.42.220.20', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}, {'StreamId': '65543', 'StreamName': '3264_E_W_3064_IPv4', 'IPv4Source': '12.41.210.21', 'IPv4Dest': '12.42.220.21', 'IPv6Source': '0', 'IPv6Dest': '0', 'Convergence': 30.1, 'convergence_sec': 30.1, 'convergence_ms': 30053.5, 'convergence_us': 30053548.0, 'dropped_frame_duration_us': '0.0'}]
```

This is the same data as above, just spaced out to make it more readably.

> Create a Python variable file called `spirent_data.py` on your laptop with the following data and upload it to your `Project Attachments`. Also, include the file for Automation with path `/workspace`

```
spirent_output = [
  {
    'StreamId': '65536',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.14',
    'IPv4Dest': '12.42.220.14',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  },
  {
    'StreamId': '65537',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.15',
    'IPv4Dest': '12.42.220.15',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  },
  {
    'StreamId': '65538',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.16',
    'IPv4Dest': '12.42.220.16',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  },
  {
    'StreamId': '65539',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.17',
    'IPv4Dest': '12.42.220.17',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  },
  {
    'StreamId': '65540',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.18',
    'IPv4Dest': '12.42.220.18',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  },
  {
    'StreamId': '65541',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.19',
    'IPv4Dest': '12.42.220.19',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  },
  {
    'StreamId': '65542',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.20',
    'IPv4Dest': '12.42.220.20',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  },
  {
    'StreamId': '65543',
    'StreamName': '3264_E_W_3064_IPv4',
    'IPv4Source': '12.41.210.21',
    'IPv4Dest': '12.42.220.21',
    'IPv6Source': '0',
    'IPv6Dest': '0',
    'Convergence': 30.1,
    'convergence_sec': 30.1,
    'convergence_ms': 30053.5,
    'convergence_us': 30053548.0,
    'dropped_frame_duration_us': '0.0'
  }
]
```



##### Step 2

First we will store this data in a variables file and import it into our Robot Test.

> Inside TC08 (Nested Data Structures) within your CXTM project, click on `Configure Automation` and put the following code in the file:

```
# 08_spirent_data.robot
*** Settings ***
Library  Collections
Variables  /workspace/spirent_data.py

*** Test Cases ***
Log Spirent Data
    Log list  ${spirent_output}
```



##### Step 3

Once we have the data available in our Robot file, we need to loop over the data structured. Since the Spirent data is a list of dictionaries you will want to loop over the list and store each dictionary in a temporary variable inside the loop.

> Loop over the Spirent data and log each dictionary:

```
# 08_spirent_data.robot
*** Test Cases ***
Looper Over Spirent Data
    FOR  ${item}  IN  @{spirent_output}
        Log dictionary  ${item}
    END
```



##### Step 4

Now finally we can apply a test to the data we are gathering. Looping over the data the same way we did in the previous step provides the dictionary to test, now we can verify that a certain condition is held.

Write a test that verifies that each element of the Spirent data has a convergence that is less than `50` seconds using the `get from dictionary` keyword with the `convergence_sec` dictionary key to get the value to make the comparison, which is using a conditional which if the value is over `50`, will fail:

```
# 08_spirent_data.robot
*** Test Cases ***
Check Convergence Against Max Value
    FOR   ${nested_dictionary}  IN  @{spirent_output}
        ${convergence_sec_from_dict}=  get from dictionary  ${nested_dictionary}  convergence_sec
        log  ${convergence_sec_from_dict}
        Run keyword unless  ${convergence_sec_from_dict} < ${50}  Fail
    END
```

__Note: Spirent and Ixia will both return data as a list of dictionaries and can be tested in this way__



##### Solution

```
# 08_spirent_data.robot
*** Settings ***
Library  Collections
Variables  /workspace/spirent_data.py

*** Test Cases ***
Log Spirent Data
    Log list  ${spirent_output}

Looper Over Spirent Data
    FOR  ${item}  IN  @{spirent_output}
        Log dictionary  ${item}
    END

Check Convergence Against Max Value
    FOR   ${nested_dictionary}  IN  @{spirent_output}
        ${convergence_sec_from_dict}=  get from dictionary  ${nested_dictionary}  convergence_sec
        log  ${convergence_sec_from_dict}
        Run keyword unless  ${convergence_sec_from_dict} < ${50}  Fail
    END
```
