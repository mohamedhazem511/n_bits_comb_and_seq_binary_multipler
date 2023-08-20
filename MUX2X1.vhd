LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.MATH_REAL.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY MUX2X1 IS 
GENERIC (DATA_WIDTH: INTEGER:=4);
PORT    (   SEL:            IN  STD_LOGIC;
            A:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0) ;
            B:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0) ;
            RES:            OUT STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0)      
);
END ENTITY  MUX2X1;

ARCHITECTURE    RTL OF  MUX2X1  IS  

BEGIN 
WITH    SEL SELECT
RES <=  A               WHEN    '1',
        B               WHEN    '0',
        (OTHERS => '0') WHEN    OTHERS;    
END ARCHITECTURE;