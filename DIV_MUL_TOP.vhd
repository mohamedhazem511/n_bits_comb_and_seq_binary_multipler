LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.MATH_REAL.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;


ENTITY DIV_MUL_TOP IS 
GENERIC (DATA_WIDTH: INTEGER:=4);
PORT    (   CLK:            IN  STD_LOGIC;
            RST:            IN  STD_LOGIC;
            MODE:           IN  STD_LOGIC;
            A:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0) ;
            B:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0) ;        
            M:              OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0) ;
            R:              OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0) ;
            BUSY:           OUT STD_LOGIC                       ;
            VALID:          OUT STD_LOGIC                       ;
            ERROR_FLAG:     OUT STD_LOGIC                       

);
END ENTITY  DIV_MUL_TOP;

ARCHITECTURE COMBINATIONAL OF DIV_MUL_TOP IS 
COMPONENT DIV_MUL IS 
GENERIC (DATA_WIDTH: INTEGER:=4);
PORT    (   CLK:            IN  STD_LOGIC;
            RST:            IN  STD_LOGIC;
            MODE:           IN  STD_LOGIC;
            A:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
            B:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;        
            M:              OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
            R:              OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
            BUSY:           OUT STD_LOGIC                                   ;
            VALID:          OUT STD_LOGIC                                   ;
            ERROR_FLAG:     OUT STD_LOGIC                       

);
END COMPONENT DIV_MUL;

COMPONENT MUX2X1 IS 
GENERIC (DATA_WIDTH: INTEGER:=4);
PORT    (   SEL:            IN  STD_LOGIC;
            A:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0) ;
            B:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0) ;
            RES:            OUT STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0)      
);
END COMPONENT MUX2X1;

FOR MUL_COMP: DIV_MUL USE ENTITY WORK.DIV_MUL(COMBINATIONAL_MUL);
FOR DIV_COMP: DIV_MUL USE ENTITY WORK.DIV_MUL(COMBINATIONAL_DIV);

SIGNAL    M_MUL:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL    R_MUL:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL    BUSY_MUL:            STD_LOGIC                                   ;
SIGNAL    VALID_MUL:           STD_LOGIC                                   ;
SIGNAL    ERROR_FLAG_MUL:      STD_LOGIC                                   ;

SIGNAL    M_DIV:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL    R_DIV:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL    BUSY_DIV:            STD_LOGIC                                   ;
SIGNAL    VALID_DIV:           STD_LOGIC                                   ;
SIGNAL    ERROR_FLAG_DIV:      STD_LOGIC                                   ;

BEGIN 
    MUL_COMP: DIV_MUL
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        CLK        => CLK            ,
                        RST        => RST            ,
                        MODE       => MODE            ,
                        A          => A               ,
                        B          => B               ,
                        M          => M_MUL           ,    
                        R          => R_MUL           ,    
                        BUSY       => BUSY_MUL        ,     
                        VALID      => VALID_MUL       ,    
                        ERROR_FLAG => ERROR_FLAG_MUL  
                    );
    DIV_COMP: DIV_MUL
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        CLK        => CLK             ,
                        RST        => RST             ,
                        MODE       => MODE            ,
                        A          => A               ,
                        B          => B               ,
                        M          => M_DIV           ,    
                        R          => R_DIV           ,    
                        BUSY       => BUSY_DIV        ,     
                        VALID      => VALID_DIV       ,    
                        ERROR_FLAG => ERROR_FLAG_DIV  
                    );
    M_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        A   =>  M_DIV,
                        B   =>  M_MUL,
                        SEL =>  MODE,
                        RES =>  M      
                    );
    R_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        A   =>  R_DIV,
                        B   =>  R_MUL,
                        SEL =>  MODE,
                        RES =>  R      
                    );
    ERROR_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => 1)
        PORT MAP    (
                        A(0)    =>  ERROR_FLAG_DIV,
                        B(0)    =>  ERROR_FLAG_MUL,
                        SEL     =>  MODE,
                        RES(0)  =>  ERROR_FLAG      
                    );
    BUSY_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => 1)
        PORT MAP    (
                        A(0)    =>  BUSY_DIV,
                        B(0)    =>  BUSY_MUL,
                        SEL     =>  MODE,
                        RES(0)  =>  BUSY      
                    );
    VALID_MUX: MUX2X1 
    GENERIC MAP (DATA_WIDTH => 1)
    PORT MAP    (
                    A(0)    =>  VALID_DIV,
                    B(0)    =>  VALID_MUL,
                    SEL     =>  MODE,
                    RES(0)  =>  VALID      
                );
END ARCHITECTURE;


ARCHITECTURE SEQUENTIAL OF DIV_MUL_TOP IS 
COMPONENT DIV_MUL IS 
GENERIC (DATA_WIDTH: INTEGER:=4);
PORT    (   CLK:            IN  STD_LOGIC;
            RST:            IN  STD_LOGIC;
            MODE:           IN  STD_LOGIC;
            A:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
            B:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;        
            M:              OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
            R:              OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
            BUSY:           OUT STD_LOGIC                                   ;
            VALID:          OUT STD_LOGIC                                   ;
            ERROR_FLAG:     OUT STD_LOGIC                       

);
END COMPONENT DIV_MUL;

COMPONENT MUX2X1 IS 
GENERIC (DATA_WIDTH: INTEGER:=4);
PORT    (   SEL:            IN  STD_LOGIC;
            A:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0) ;
            B:              IN  STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0) ;
            RES:            OUT STD_LOGIC_VECTOR (DATA_WIDTH-1  DOWNTO  0)      
);
END COMPONENT MUX2X1;

FOR MUL_SEQ: DIV_MUL USE ENTITY WORK.DIV_MUL(SEQUENTIAL_MUL);
FOR DIV_SEQ: DIV_MUL USE ENTITY WORK.DIV_MUL(SEQUENTIAL_DIV);

SIGNAL  M_MUL:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL  R_MUL:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL  BUSY_MUL:            STD_LOGIC                                   ;
SIGNAL  VALID_MUL:           STD_LOGIC                                   ;
SIGNAL  ERROR_FLAG_MUL:      STD_LOGIC                                   ;
SIGNAL  M_DIV:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL  R_DIV:               STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)    ;
SIGNAL  BUSY_DIV:            STD_LOGIC                                   ;
SIGNAL  VALID_DIV:           STD_LOGIC                                   ;
SIGNAL  ERROR_FLAG_DIV:      STD_LOGIC                                   ;
BEGIN 
    MUL_SEQ: DIV_MUL
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        CLK        => CLK             ,
                        RST        => RST             ,
                        MODE       => MODE            ,
                        A          => A               ,
                        B          => B               ,
                        M          => M_MUL           ,    
                        R          => R_MUL           ,    
                        BUSY       => BUSY_MUL        ,     
                        VALID      => VALID_MUL       ,    
                        ERROR_FLAG => ERROR_FLAG_MUL  
                    );
    DIV_SEQ: DIV_MUL
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        CLK        => CLK             ,
                        RST        => RST             ,
                        MODE       => MODE            ,
                        A          => A               ,
                        B          => B               ,
                        M          => M_DIV           ,    
                        R          => R_DIV           ,    
                        BUSY       => BUSY_DIV        ,     
                        VALID      => VALID_DIV       ,    
                        ERROR_FLAG => ERROR_FLAG_DIV  
                    );
    M_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        A   =>  M_DIV,
                        B   =>  M_MUL,
                        SEL =>  MODE,
                        RES =>  M      
                    );
    R_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP    (
                        A   =>  R_DIV,
                        B   =>  R_MUL,
                        SEL =>  MODE,
                        RES =>  R      
                    );
    ERROR_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => 1)
        PORT MAP    (
                        A(0)    =>  ERROR_FLAG_DIV,
                        B(0)    =>  ERROR_FLAG_MUL,
                        SEL     =>  MODE,
                        RES(0)  =>  ERROR_FLAG      
                    );
    BUSY_MUX: MUX2X1 
        GENERIC MAP (DATA_WIDTH => 1)
        PORT MAP    (
                        A(0)    =>  BUSY_DIV,
                        B(0)    =>  BUSY_MUL,
                        SEL     =>  MODE,
                        RES(0)  =>  BUSY      
                    );
    VALID_MUX: MUX2X1 
    GENERIC MAP (DATA_WIDTH => 1)
    PORT MAP    (
                    A(0)    =>  VALID_DIV,
                    B(0)    =>  VALID_MUL,
                    SEL     =>  MODE,
                    RES(0)  =>  VALID      
                );
END ARCHITECTURE;