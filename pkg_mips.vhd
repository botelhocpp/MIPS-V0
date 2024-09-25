----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: pkg_mips
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Common parameters for the MIPS-V0 project.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY STD;
USE STD.TEXTIO.ALL;

PACKAGE pkg_mips IS
    SUBTYPE reg32 IS STD_LOGIC_VECTOR(31 DOWNTO 0);
    SUBTYPE ureg32 IS UNSIGNED(31 DOWNTO 0);
    SUBTYPE sreg32 IS SIGNED(31 DOWNTO 0);
    
    SUBTYPE byte IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    SUBTYPE nibble IS STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    TYPE inst_type_t IS (
        ADDU,
        SUBU,
        AAND,
        OOR, 
        XXOR, 
        NNOR, 
        LW, 
        SW, 
        ORI, 
        INVALID
    );
        
    TYPE instruction_t IS RECORD
        ce : STD_LOGIC;
        rw : STD_LOGIC;
        i : inst_type_t;
        wreg : STD_LOGIC;
    END RECORD;

END pkg_mips;

PACKAGE BODY pkg_mips IS
END pkg_mips;
