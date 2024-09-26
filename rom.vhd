----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: rom
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The program memory of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY rom IS
    GENERIC (
        START_ADDR : reg32 := (OTHERS => '0')
    );
    PORT (
        address : IN reg32;
        data : OUT reg32
    );
END rom;

ARCHITECTURE behavioral OF rom IS 
    CONSTANT contents : mem_array_t := InitMEM("code.txt");
 
    SIGNAL rom_address : ureg32;
    
BEGIN 
    rom_address <= ureg32(address) - ureg32(START_ADDR);
    data <= contents( TO_INTEGER(rom_address(31 DOWNTO 2) ) );
END behavioral;