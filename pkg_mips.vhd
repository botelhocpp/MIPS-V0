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
    
    CONSTANT CONST_ADDR_NUM : INTEGER := 2048;
    
    TYPE mem_array_t IS ARRAY (0 TO CONST_ADDR_NUM - 1) OF reg32;
    
    TYPE inst_type_t IS (
        ADDU,
        SUBU,
        AAND,
        OOR, 
        XXOR, 
        NNOR,
        RROR,
        RROL,
        CMP,
        PSH,
        POP,
        ORI, 
        SHRI,
        SHLI,
        LW, 
        SW, 
        B,
        BEQ,
        BLT,
        BGT,
        INVALID
    );
        
    TYPE instruction_t IS RECORD
        ce : STD_LOGIC;
        rw : STD_LOGIC;
        i : inst_type_t;
        wreg : STD_LOGIC;
    END RECORD;
    
    IMPURE FUNCTION InitMEM(file_name : STRING) RETURN mem_array_t;

END pkg_mips;

PACKAGE BODY pkg_mips IS
    IMPURE FUNCTION InitMEM(file_name : STRING) RETURN mem_array_t IS
      FILE text_file : TEXT OPEN READ_MODE IS file_name;
      VARIABLE text_line : LINE;
      VARIABLE contents : mem_array_t;
      VARIABLE i : INTEGER := 0;
    BEGIN
      WHILE NOT ENDFILE(text_file) LOOP
        READLINE(text_file, text_line);
        HREAD(text_line, contents(i));
        i := i + 1;
      END LOOP;
      
      FOR j IN i TO CONST_ADDR_NUM - 1 LOOP
        contents(j) := (OTHERS => '0');
      END LOOP;
      
      RETURN contents;
    END FUNCTION;
END pkg_mips;
