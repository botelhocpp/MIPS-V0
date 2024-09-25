----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: register_file
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Contains the general purpose registers of the processor.
-- 
-- Dependencies: generic_register
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY register_file IS
  PORT ( 
         DataWP : IN reg32;
         clk : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         ce : IN STD_LOGIC;
         AdRP1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
         AdRP2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
         AdWP : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
         DataRP1 : OUT reg32;
         DataRP2 : OUT reg32 
  );
END register_file;

ARCHITECTURE behavioral OF register_file IS
    TYPE register_array_t IS ARRAY (31 DOWNTO 0) OF reg32;
    
    SIGNAL registers : register_array_t;
    SIGNAL registers_ce : reg32;
BEGIN
    GENERATE_REGS:
    FOR i IN 31 DOWNTO 0 GENERATE
        registers_ce(i) <= '1' when (i /= 0 AND TO_INTEGER(UNSIGNED(AdWP)) = i AND ce = '1') else '0';
        
        GENERATE_SP_REG:
        IF (i = 29) GENERATE
        SP_REG: ENTITY WORK.generic_register
        GENERIC MAP ( INIT_VALUE => x"10010800" )
        PORT MAP (
            D => DataWP,
            ce => registers_ce(i),
            clk => clk,
            rst => rst,
            Q => registers(i)
        );
        END GENERATE;
        
        GENERATE_GP_REGS:
        IF (i /= 29) GENERATE
        GP_REGS: ENTITY WORK.generic_register
        PORT MAP (
            D => DataWP,
            ce => registers_ce(i),
            clk => clk,
            rst => rst,
            Q => registers(i)
        );
        END GENERATE;
    END GENERATE;

    DataRP1 <= registers( TO_INTEGER( UNSIGNED(AdRP1) ) );  
    DataRP2 <= registers( TO_INTEGER( UNSIGNED(AdRP2) ) );    
END behavioral;
