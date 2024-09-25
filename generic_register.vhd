----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: generic_register
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: A generic n-bit register. 
-- 
-- Dependencies: none.
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY register_nbit IS
    PORT (
        D : IN reg32;
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT reg32
    );
END register_nbit;

ARCHITECTURE hardware OF register_nbit IS
BEGIN    
    PROCESS(rst, clk, ld)
    BEGIN
        IF(rst = '1') THEN
            Q <= (OTHERS => '0');
        ELSIF(RISING_EDGE(clk) AND ld = '1') THEN
            Q <= D;
        END IF;
    END PROCESS;
END hardware;