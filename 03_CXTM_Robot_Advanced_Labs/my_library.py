# my_library.py
from CXTA.core.logger import logger
#from CXTA.core.decorator import keyword
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