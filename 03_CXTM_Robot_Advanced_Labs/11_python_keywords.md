## Lab 11 - Python Keywords

Robot is built in python, making writing python keywords a simple process. Keywords written in python have two primary benefits, they are faster and have more pre-build libraries to draw from.

### Task 1 - Basic Python Keywords

##### Step 1 - Create A Python File

To start creating python keywords, you need to create a python file to store them in.

> Create a python file (file with a .py extension) on your laptop and name it `11_hello_world.py`.

```
# 11_hello_world.py

# Python code here
```



##### Step 2 - Python Function As Robot Keyword

The simplest way to create a python keyword, is to make a function in python. A function is defined using the `def` reserved word, followed by a function name, and followed by `():`. Function names will map to keyword names, but spaces can't be used in python function names so underscores can be used to map to spaces.

> Write a keyword named `hello_world` in your python file which prints the string `Hello World!`:

```
# 11_hello_world.py

def hello_world():
    print("Hello World!")
```

This function will be callable in Robot as the keyword `hello world`, `hello_world`, `Hello World`, and any other combinations of capitalization.



##### Step 3 - Python Keyword With Arguments

If you want to write a keyword that takes in arguments, those arguments will be placed in he parenthesis `()` following the function name.

> Write a keyword named `print_message` in your python file which takes in a specific message to print:

```
# 11_hello_world.py

def hello_world():
    print("Hello World!")

def print_message(message):
    print(message)
```



##### Step 4 - Importing Python File Into Robot

Now that you have written your python keywords, you need to import them into Robot. Upload the python file to your `Project Attachments` and include it for Automation with path `/workspace`. You import your python keywords using the `Library` reserved word in the `Settings` section.

> Inside TC11 (Python Keywords) within your CXTM project, click on `Configure Automation` and put the following code in the file to import your python keywords.

```
# 11_basic_python_keyword.robot
*** Settings ***
Library  /workspace/11_hello_world.py
```



##### Step 5 - Using Python Keyword

After importing the python keywords, they can be used like Robot keywords. They are still case insensitive, underscores can be replaced with spaces, and arguments need to be separated with 2 spaces.

> Add test cases that utilize the python keywords:

```
# 11_basic_python_keyword.robot
*** Settings ***
Library  /workspace/11_hello_world.py

*** Variables ***
${message}  Text printed from python.

*** Test Cases ***
Test Basic Keyword
    Hello World

Test Keyword With Arguments
    Print Message  ${message}
```



##### Solution

```
# 11_basic_python_keyword.robot
*** Settings ***
Library  /workspace/11_hello_world.py

*** Variables ***
${message}  Text printed from python.

*** Test Cases ***
Test Basic Keyword
    Hello World

Test Keyword With Arguments
    Print Message  ${message}
```

```
# 11_hello_world.py
def hello_world():
    print("Hello World!")

def print_message(message):
    print(message)
```



### Task 2 - Complete Python Keywords

In task 1, we wrote python keywords in a very simple way. This is very useful for quick testing, but now we will see a more complete way to write keyword libraries in python.



##### Step 1 - Python Class As Robot Library

We are going to define a python class, this class will represent our keyword library. A class is defined with the `class` reserved word, followed by the class name, and followed by `():`.

Note: The class name needs to match the name of the python file.

> Create a python file named `my_library.py` on your laptop and add a class named `my_library`:

```
# my_library.py
class my_library():
    # Place code here
```



##### Step 2 - CXTA Imports

There are several useful python modules built for CXTA, these modules will need to be imported into the python file to use. We will see how these are used in further steps.

> Import the CXTA python modules into the `my_library.py` file:
>
> Note: In these examples we will be importing specific features, not the entire modules.

```
# my_library.py
from CXTA.core.logger import logger
from robot.api.deco import keyword
from CXTA.robot.CxtaException import CxtaException
from CXTA.robot.Util import Util

class my_library():
    # Place code here
```



##### Step 3 - Creating A Keyword

Now that the class is created, to create a keyword we will again write a python function. This time the function is indented to be a part of the class.

Note: The function name will still map to the keyword name.

> Define a function named `verify_addition` which takes in three arguments:

```
# my_library.py
from CXTA.core.logger import logger
from robot.api.deco import keyword
from CXTA.robot.CxtaException import CxtaException
from CXTA.robot.Util import Util

class my_library():
    def verify_addition(self, a, b, c):
        # Place code for keyword here
```

Note: Although we only meant to define three arguments, there are four in this example. The arguments are `self`, `a`, `b`, and `c`, the arguments we want to use in the function are `a`, `b`, and `c`. The `self` argument is a special feature of the python class, this will be used to refer to the class itself inside the function. For most basic applications, this can be ignored.



Another feature to consider when creating a python keyword this way is the keyword name. The name of the function is used as the keyword name by default, but you can use the `@keyword()` line to define a separate name for the keyword. The keyword name is put in between the parenthesis, as with Robot keywords the name will be case insensitive.

```
# my_library.py
from CXTA.core.logger import logger
from robot.api.deco import keyword
from CXTA.robot.CxtaException import CxtaException
from CXTA.robot.Util import Util

class my_library():
    @keyword('verify addition of "${a}" and "${b}" is "${c}"')
    def verify_addition(self, a, b, c):
        # Place code for keyword here
```

In the above example, we are creating a keyword with embedded arguments. The variables a, b, and c are included in the keyword name, each one using the variable syntax from Robot.



##### Step 4 - Class Scope

You can define the scope of your keyword library in the python class. Make a variable named `ROBOT_LIBRARY_SCOPE` and set it equal to either `"GLOBAL"`, `"TEST CASE"`, or `"TEST SUITE"`.

> Define your library to have `"GLOBAL"` scope:

```
# my_library.py
from CXTA.core.logger import logger
from robot.api.deco import keyword
from CXTA.robot.CxtaException import CxtaException
from CXTA.robot.Util import Util

class my_library():

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    @keyword('verify addition of "${a}" and "${b}" is "${c}"')
    def verify_addition(self, a, b, c):
        # Place code for keyword here
```



##### Step 5 - Logging

Logging is a very important part of developing keywords, you will need to log information as your debugging and log information about the execution of the keyword to its user. We will be using the `logger` which is imported from the CXTA module. You can log information at different log levels, indicated by the function you use the log it. `logger().info()` will log the message on the info level and `logger().debug()` will log information on the debug level. This only changes when and where the information is available, for our testing logging with either will be visible in the log.html file.

> Log each parameter of the `verify_addition` function:

```
# my_library.py
from CXTA.core.logger import logger
from robot.api.deco import keyword
from CXTA.robot.CxtaException import CxtaException
from CXTA.robot.Util import Util

class my_library():

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    @keyword('verify addition of "${a}" and "${b}" is "${c}"')
    def verify_addition(self, a, b, c):
        logger().info(a)
        logger().debug(b)
        logger().info(c)
```



##### Step 6 - Failing Keyword

Now were going to add the logic of our function, the code that will add the numbers and verify the result. After adding `a` and `b`, we store the value in the `result` variable. Then we write a conditional to check if `result` is equal to `c`. If so we log a message to the user indicating it was a success, else we fail the keyword by using the `CxtaException` imported from the CXTA module.

> Finish the keyword by adding the verification logic:

```
# my_library.py
from CXTA.core.logger import logger
from robot.api.deco import keyword
from CXTA.robot.CxtaException import CxtaException
from CXTA.robot.Util import Util

class my_library():

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    @keyword('verify addition of "${a}" and "${b}" is "${c}"')
    def verify_addition(self, a, b, c):
        logger().info(a)
        logger().debug(b)
        logger().info(c)

        result = a + b
        if result == c:
            logger().info(f'Sum of {a} and {b} is as expected {c}')
        else:
            raise CxtaException(f'Sum of {a} and {b} is not {c} but instead it is {result}')
```

Note: Every keyword in Robot either passes or fails, if you don't use `CxtaException` then Robot will think the keyword passed.



##### Step 7 - Importing In Robot

With the keyword finished, now we just need to import and use it in Robot. Upload `my_library.py` file to your `Project Attachments` and also, include the file for Automation with path `/workspace` Just like with the basic example from task 1, we import it using the `Library` reserved word in the `Settings` section. You can provide either the absolute path or the relative path to the library file.

> Import the `my_library.py` keyword library into a Robot test and use the `verify addition` keyword:

```
# 11_complete_python_keywords.robot
*** Settings ***
Library  /workspace/my_library.py

*** Test Cases ***
My first python based keyword
    ${value 1}=  set variable  ${10}
    ${value 2}=  set variable  ${20}
    ${expected result}=  set variable  ${30}
    verify addition of "${value 1}" and "${value 2}" is "${expected result}"
```



##### Solution

```
# 11_complete_python_keywords.robot
*** Settings ***
Library  /workspace/my_library.py

*** Test Cases ***
My first python based keyword
    ${value 1}=  set variable  ${10}
    ${value 2}=  set variable  ${20}
    ${expected result}=  set variable  ${30}
    verify addition of "${value 1}" and "${value 2}" is "${expected result}"
```

```
# my_library.py
from CXTA.core.logger import logger
from robot.api.deco import keyword
from CXTA.robot.CxtaException import CxtaException
from CXTA.robot.Util import Util

class my_library():

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    @keyword('verify addition of "${a}" and "${b}" is "${c}"')
    def verify_addition(self, a, b, c):
        logger().info(a)
        logger().debug(b)
        logger().info(c)

        result = a + b
        if result == c:
            logger().info(f'Sum of {a} and {b} is as expected {c}')
        else:
            raise CxtaException(f'Sum of {a} and {b} is not {c} but instead it is {result}')
```
