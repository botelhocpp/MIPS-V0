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
    
    PURE FUNCTION hex2bin(hex : CHARACTER) RETURN nibble;
    IMPURE FUNCTION InitMEM(file_name : STRING) RETURN mem_array_t;

END pkg_mips;

PACKAGE BODY pkg_mips IS
    PURE FUNCTION hex2bin(hex : CHARACTER) RETURN nibble IS
        VARIABLE bin : nibble;
    BEGIN
        CASE hex IS
            WHEN '0' => bin := "0000";
            WHEN '1' => bin := "0001";
            WHEN '2' => bin := "0010";
            WHEN '3' => bin := "0011";
            WHEN '4' => bin := "0100";
            WHEN '5' => bin := "0101";
            WHEN '6' => bin := "0110";
            WHEN '7' => bin := "0111";
            WHEN '8' => bin := "1000";
            WHEN '9' => bin := "1001";
            WHEN 'A' | 'a' => bin := "1010";
            WHEN 'B' | 'b' => bin := "1011";
            WHEN 'C' | 'c' => bin := "1100";
            WHEN 'D' | 'd' => bin := "1101";
            WHEN 'E' | 'e' => bin := "1110";   
            WHEN 'F' | 'f' => bin := "1111";
            WHEN OTHERS => bin := "0000";     
        END CASE;
        
        RETURN BIN;
    END hex2bin;

    
    IMPURE FUNCTION InitMEM(file_name : STRING) RETURN mem_array_t IS
      FILE text_file : TEXT;
      VARIABLE text_line : LINE;
      VARIABLE contents : mem_array_t;
      VARIABLE i : INTEGER := 0;
      VARIABLE success : FILE_OPEN_STATUS;
      VARIABLE hex_string : STRING(1 TO 8);
    BEGIN
        FILE_OPEN(success, text_file, file_name, READ_MODE);
        IF (success = OPEN_OK) THEN
          WHILE NOT ENDFILE(text_file) LOOP
            READLINE(text_file, text_line);
            READ(text_line, hex_string);
            
            FOR j IN 1 TO 8 LOOP
			     contents(i)((8 - j + 1)*4 - 1 DOWNTO (8 - j)*4) := hex2bin(hex_string(j));
            END LOOP;
            
            i := i + 1;
          END LOOP;
          
          FOR j IN i TO CONST_ADDR_NUM - 1 LOOP
            contents(j) := (OTHERS => '0');
          END LOOP;
      END IF;
      RETURN contents;
    END FUNCTION;
END pkg_mips;
