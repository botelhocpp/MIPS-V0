----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: control_unit
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The control part of the processor.
-- 
-- Dependencies: generic_register
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY control_unit IS
    PORT ( 
        instruction : IN reg32;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        uins : OUT instruction_t;
        i_address : OUT reg32
    );
END control_unit;

ARCHITECTURE behavioral OF control_unit IS
    SIGNAL incpc : reg32;
    SIGNAL pc : reg32;
    SIGNAL i : inst_type_t;
BEGIN
    PC_REG: ENTITY WORK.generic_register 
    GENERIC MAP(INIT_VALUE => x"00400000")
    PORT MAP(
        D => incpc,
        ce => '1', 
        clk => clk, 
        rst => rst, 
        Q => pc
    );
    incpc <= reg32(ureg32(pc) + 4);
    
    i_address <= pc;
    
    -- Instruction Decoder
    uins.i <= i;  
    i <= ADDU WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100001" ELSE
         SUBU WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100011" ELSE
         AAND WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100100" ELSE
         OOR  WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100101" ELSE
         XXOR WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100110" ELSE
         NNOR WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100111" ELSE
         ORI  WHEN instruction(31 DOWNTO 26) = "001101" ELSE
         LW   WHEN instruction(31 DOWNTO 26) = "100011" ELSE
         SW   WHEN instruction(31 DOWNTO 26) = "101011" ELSE 
         INVALID;
     
    -- In case of exception
    ASSERT i /= INVALID
          REPORT "INVALID INSTRUCTION"
          SEVERITY ERROR;
          
   -- Main Control Signals
   uins.ce <= '1' WHEN (i = SW OR i = LW) ELSE '0';
   uins.rw <= '1' WHEN (i = LW) ELSE '0';
   uins.wreg <= '1' WHEN (i /= SW) ELSE '0';
END behavioral;
