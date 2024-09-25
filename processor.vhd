----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: processor
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Pairing of the datapath and the control unit to form a processor.
-- 
-- Dependencies: datapath, control_unit
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY processor IS
  PORT ( 
    instruction : IN reg32;
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    ce : OUT STD_LOGIC;
    rw : OUT STD_LOGIC;
    i_address : OUT reg32;
    d_address : OUT reg32;
    data : INOUT reg32
  );
END processor;

ARCHITECTURE behavioral OF processor IS
    SIGNAL uins : instruction_t;
BEGIN
    DP_COMP: ENTITY WORK.datapath
    PORT MAP(
        instruction => instruction, 
        uins => uins, 
        clk => clk, 
        rst => rst, 
        d_address => d_address,
        data => data
    );
    UC_COMP: ENTITY WORK.control_unit
    PORT MAP(
        instruction => instruction,
        clk => clk, 
        rst => rst, 
        uins => uins, 
        i_address => i_address
    );
        
    ce <= uins.ce;
    rw <= uins.rw;
    
END behavioral;
