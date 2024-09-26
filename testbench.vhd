----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: testbench
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Testbench for the processor.
-- 
-- Dependencies: processor, rom, ram
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavioral OF testbench IS
    CONSTANT CLK_PERIOD : TIME := 20ns;
    
    SIGNAL data : reg32;
    SIGNAL d_address : reg32;
    SIGNAL i_address : reg32;
    SIGNAL instruction : reg32;
    SIGNAL ce : STD_LOGIC;
    SIGNAL rw : STD_LOGIC;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
BEGIN
    PROCESSOR_COMP: ENTITY WORK.processor
    PORT MAP ( 
        instruction => instruction,
        clk => clk,
        rst => rst,
        ce => ce,
        rw => rw,
        i_address => i_address,
        d_address => d_address,
        data => data
    );
    RAM_COMP: ENTITY WORK.ram
    -- GENERIC MAP ( START_ADDR => x"10010000" )
    GENERIC MAP ( START_ADDR => x"00000000" )
    PORT MAP ( 
        address => d_address,
        ce => ce,
        rw => rw,
        data => data
    );
    ROM_COMP: ENTITY WORK.rom
    GENERIC MAP ( START_ADDR => x"00400000" )
    PORT MAP ( 
        address => i_address,
        data => instruction
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR CLK_PERIOD/4;
        
        rst <= '0';
        WAIT;
    END PROCESS;
END behavioral;