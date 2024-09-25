----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: alu
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Performs arithmetic and logic operations on two operands.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.pkg_mips.ALL;

ENTITY alu IS
    PORT(
        A : IN reg32;
        B : IN reg32;
        op : IN inst_type_t;
        zero : OUT STD_LOGIC;
        Q : OUT reg32
    );
END alu;

ARCHITECTURE behavioral OF alu IS
    CONSTANT CONST_ZERO : reg32 := (OTHERS => '0');
    
    SIGNAL res : reg32;
BEGIN
    Q <= res;
    
    WITH op SELECT
        res <=  (reg32(sreg32(A) - sreg32(B)))  WHEN SUBU,
                (A AND B)                       WHEN AAND,
                (A OR B)                        WHEN OOR | ORI,
                (A XOR B)                       WHEN XXOR,
                (A NOR B)                       WHEN NNOR,
                (reg32(sreg32(A) + sreg32(B)))  WHEN OTHERS;
	
	zero <= '1' WHEN (res = CONST_ZERO) ELSE '0';
END ARCHITECTURE;
