## Lab 4 - Connectors and YAML



### Task 1 - YAML Basics

##### Step 1

YAML is a format for storing data, making it convenient to organize. YAML is a collection of key value pairs, using the `:` symbol to separate them. YAML is white space sensitive, spaces or tabs are used to differentiate where key value pairs are being stored.

There are several data types in YAML including strings, numbers, booleans, lists, and dictionaries. Strings can be represented with or without quotation marks. For lists and dictionaries the values start on the following lines indented.

> Create a YAML file `04_yaml_basics.yaml` on your laptop containing each type of data (String, Number, Boolean, List, and Dictionary). Once created, upload this file as project attachment within your CXTM project and edit it's `Automation` field to say Yes with an automation path set to `/workspace`.

```
# 04_yaml_basics.yaml
---
DUT: cxtm_iox
version: 16
is_up: true
neighbors:
  - cxtm_ios
  - cxtm_junos
facts:
  vendor: cisco
  os: ios-xr
  mac: 00:00:00:00:00:01
```

When using Robot Framework, you need to use the .yaml file extension instead of the .yml file extension. For most uses of YAML you can use either but Robot will only recognize .yaml files as YAML files.

##### Step 2

Lists and dictionaries can contain other lists and dictionaries allowing for nested data to be represented. When you create a list or dictionary you place the value on the following indented line, each new list or dictionary creates another level of indentation.

> Create a YAML file `04_nested_object.yaml` on your laptop containing nested data. Once created, upload this file as project attachment within your CXTM project and edit it's `Automation` field to say Yes with an automation path set to `/workspace`.

```
# 04_nested_object.yaml
---
devices:
  cxtm_iox:
    os: ios-xr
    neighbors:
      - cxtm_ios
      - cxtm_junos
  cxtm_ios:
    os: ios
    neighbors:
          - cxtm_iox
          - cxtm_junos
  cxtm_junos:
    os: junos
    neighbiors:
      - cxtm_iox
      - cxtm_ios
```



### Task 2 - Testbed

##### Step 1

CXTA uses a YAML file to represent the testing environment. This is referred to as the Testbed file, it contains the devices being tested and information regarding them. An important piece of information defined in the testbed is how to connect to the device. There can be several different ways to connect to the same device, so you have the option to define multiple connection types and differentiate between them when writing your Robot tests.

> Create a YAML file `testbed.yaml` on your laptop with the following information. Once created, click the hamburger menu within your CXTM project and navigate to `Topologies`. In the text box, copy the contents of this YAML file and then click `Save As`. Give your topology a name, for example, `testbed.yaml` and click `Save`.

```
# testbed.yaml
---
testbed:
  name: CXTM Robot Training
devices:
  cxtm_iox:
    connections:
      vty:
        class: unicon.Unicon
        ip: 163.162.174.54
        password: c1cd123
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
      linux: c1cd123
    tacacs:
      username: cicd
    type: router
  cxtm_ios:
    connections:
      vty:
        class: unicon.Unicon
        ip: 163.162.174.54
        password: c1cd123
        port: 1222
        protocol: ssh
        username: cicd
      defaults:
        via: vty
    custom:
       categories:
       - ios
    os: ios
    passwords:
      linux: c1cd123
    tacacs:
      username: cicd
    type: router
  cxtm_junos:
    connections:
      vty:
        class: unicon.Unicon
        ip: 163.162.174.54
        password: c1cd123
        port: 1322
        protocol: ssh
        username: cicd
      defaults:
        via: vty
    custom:
      categories:
      - junos
    os: junos
    passwords:
      linux: c1cd123
    tacacs:
      username: cicd
    type: router
```

> You can view the contents of your topology file any time by navigating to `Topologies` within your CXTM project and then click on `Open`. From the pop up dialog box, select your topology name `testbed.yaml` to view its contents.



##### Step 2

You can load the data from the topology file within your Robot file using `load testbed` keyword. Also in the `Settings` section, you can import the CXTA library, this includes all of the CXTA custom keywords utilized in these examples.

> Inside TC04 (Connectors and YAML) within your CXTM project, click on `Configure Automation` and import the testbed with the following lines:

```
# 04_testbed.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Test Cases ***
Load Testbed
    load testbed
```



##### Solution

```
# 04_testbed.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

*** Test Cases ***
Load Testbed
    load testbed
```



### Task 3 - SVS Connectors

Now you will explore several different SVS custom keywords for connecting to device in Robot. After connecting to devices, some examples will run the show version command to verify that a connection has been established.

##### Step 1

> Inside TC04 (Connectors and YAML) within your CXTM project, click on `Configure Automation` and import the YAML file `04_yaml_basics.yaml` within your jobfile by using `Variables` setting under `*** Settings ***` section

```
# 04_svs_connectors.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

# Upload these yaml files to your workspace location
Variables   /workspace/04_yaml_basics.yaml

*** Variables ***
${DUT}   cxtm_ios    # Device Under Testing

*** Test Cases ***
Load Testbed
    load testbed
```



##### Step 2

`connect to device “${device}” over “${connection}”` connects to a device using a specific connection type. Both the device name and connection name need to match with the testbed file. This should be your default keyword for connection to devices. `disconnect from current device connection "${connection}"` will end the connection to the current device.

> Connect to the device specifying the `vty` connection type, run a command, then disconnect:

```
# 04_svs_connectors.robot
*** Test Cases ***
Connect To Device By Name And Specify Connection
    connect to device "${DUT}" over "vty"
    run "show version"
    disconnect from current device

```



##### Step 3

`connect to device “${device}”` can be used to connect to a single device by name. This keyword requires a default connection to be set in the testbed, otherwise it will fail. `disconnect from device “${device}”` disconnects from the named device. Ensure there is a default connection set for the device before continuing.

> Connect to the device, run a command, then disconnect:

```
# 04_svs_connectors.robot
*** Test Cases ***
Connect To Device By Name
    #${DUT}=  Set Variable  cxtm_ios
    connect to device "${DUT}"
    run "show version"
    disconnect from device "${DUT}"

```



##### Step 4

The `connect to all devices` keyword will connect to each device that is listed in the testbed file. `disconnect from all devices` ends each connection that has been established.

> Write a test case that connects to and disconnects from each device:
>

```
# 04_svs_connectors.robot
*** Test Cases ***
Connect To All Devices
    connect to all devices
    disconnect from all devices

```



##### Step 5

In order to make use of multiple connected devices, you need a way to switch between each device that you are using. The `use device "${device}"` keyword allows you to switch between device, whichever device is currently "in use" will be the target of keywords like `"run "${command}"`.

> Connect to all devices in the testbed, run a command against the IOS device, and end all the connections:
>

```
# 04_svs_connectors.robot
*** Test Cases ***
Select Device To Use
    connect to all devices
    use device "${DUT}"
    run "show version"
    disconnect from all devices

```



##### Step 6

Next we will see how to setup multiple connections to a device. Before we write the Robot code for this, we need to add a second connection mechanism to our topology `testbed.yaml` file.

> Within your CXTM project, update the cxtm_ios device in the topology testbed file to read the following:

```
cxtm_ios:
    connections:
      vty:
        class: unicon.Unicon
        ip: 163.162.174.54
        password: c1cd123
        port: 1222
        protocol: ssh
        username: cicd
      vty2:
        class: unicon.Unicon
        ip: 163.162.174.54
        password: c1cd123
        port: 1222
        protocol: ssh
        username: cicd
      defaults:
        via: vty
    custom:
      categories:
      - ios
    os: ios
    passwords:
      linux: c1cd123
    tacacs:
      username: cicd
    type: router
```



##### Step 7

If you have multiple connections to the same device, then you can use the keyword `use device "${device}" connection "${connection_name}"` to specify which connection you want to use.

> Open multiple connections to the device, run a command on each connection, then end both connections:

```
# 04_svs_connectors.robot
*** Test Cases ***
Switch Between Connections
    connect to device "${DUT}" over "vty" as new connection "vty"
    connect to device "${DUT}" over "vty2" as new connection "vty2"
    use device "${DUT}" connection "vty"
    run "show version"
    use device "${DUT}" connection "vty2"
    run "show version"
    disconnect from all devices

```



##### Step 8

To connect to multiple devices, but not all devices, use the `Connect to devices “${devices}”` keyword. It takes a string as an argument, this string is the name of each device to connect to separated by a semicolon.

> Connect to the IOS and Junos devices, run a command against each, then end both connections:

```
# 04_svs_connectors.robot
*** Test Cases ***
Connect To Two Devices
    connect to devices "cxtm_ios;cxtm_junos"
    use device "cxtm_ios"
    run "show version"
    use device "cxtm_junos"
    run "set cli screen-length 0"
    run "show system commit"
    disconnect from all devices

```



##### Solution

```
# 04_svs_connectors.robot
*** Settings ***
Library  CXTA
Resource  cxta.robot

# Upload these yaml files to your workspace location
Variables   /workspace/04_yaml_basics.yaml

*** Variables ***
${DUT}   cxtm_ios    # Device Under Testing

*** Test Cases ***
Load Testbed
    load testbed

Connect To Device By Name And Specify Connection
    connect to device "${DUT}" over "vty"
    run "show version"
    disconnect from current device

Connect To Device By Name
    #${DUT}=  Set Variable  cxtm_ios
    connect to device "${DUT}"
    run "show version"
    disconnect from device "${DUT}"

Connect To All Devices
    connect to all devices
    disconnect from all devices

Select Device To Use
    connect to all devices
    use device "${DUT}"
    run "show version"
    disconnect from all devices

Switch Between Connections
    connect to device "${DUT}" over "vty" as new connection "vty"
    connect to device "${DUT}" over "vty2" as new connection "vty2"
    use device "${DUT}" connection "vty"
    run "show version"
    use device "${DUT}" connection "vty2"
    run "show version"
    disconnect from all devices

Connect To Two Devices
    connect to devices "cxtm_ios;cxtm_junos"
    use device "cxtm_ios"
    run "show version"
    use device "cxtm_junos"
    run "set cli screen-length 0"
    run "show system commit"
    disconnect from all devices
```
