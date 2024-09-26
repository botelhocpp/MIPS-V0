----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: ram
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The data memory of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY ram IS
    GENERIC (
        START_ADDR : reg32 := (OTHERS => '0')
    );
    PORT (
        address : IN reg32;
        ce : IN STD_LOGIC;
        rw : IN STD_LOGIC;
        data : INOUT reg32
    );
END ram;

ARCHITECTURE behavioral OF ram IS 
    SIGNAL contents : mem_array_t := InitMEM("data.txt");
    
    SIGNAL ram_address : ureg32;
    SIGNAL address_integer : INTEGER;
BEGIN 
    ram_address <= ureg32(address) - ureg32(START_ADDR);
    address_integer <= TO_INTEGER( ram_address(31 DOWNTO 2) );
    
    -- Read from Memory
    PROCESS(address_integer, ce, rw)
    BEGIN
        IF(address_integer < CONST_ADDR_NUM) THEN
            IF(ce = '1' AND rw = '1') THEN
                data <= contents(address_integer);
            ELSE
                data <= (OTHERS => 'Z');
            END IF;
        END IF;
    END PROCESS;
    
    -- Write into Memory    
    PROCESS(address_integer, ce, rw)
    BEGIN
        IF(address_integer < CONST_ADDR_NUM) THEN
            IF(ce = '1' AND rw = '0') THEN
                contents(address_integer) <= data;
            END IF;
        END IF;
    END PROCESS;
END behavioral;