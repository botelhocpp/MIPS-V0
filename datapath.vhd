----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: datapath
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The data processing part of the processor.
-- 
-- Dependencies: register_file, alu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY datapath IS
  PORT ( 
    instruction : IN reg32;
    uins : IN instruction_t;
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    zero : OUT STD_LOGIC;
    carry : OUT STD_LOGIC;
    d_address : OUT reg32;
    data : INOUT reg32
  );
END datapath;

ARCHITECTURE behavioral OF datapath IS
    SIGNAL R1 : reg32;
    SIGNAL R2 : reg32;
    SIGNAL result : reg32;
    SIGNAL reg_dest : reg32;
    SIGNAL op2 : reg32;
    SIGNAL ext32 : reg32;
    SIGNAL flags_input : reg32;
    SIGNAL flags_output : reg32;
    
    SIGNAL alu_zero : STD_LOGIC;
    SIGNAL alu_carry : STD_LOGIC;
    SIGNAL instR : STD_LOGIC;
    SIGNAL adD : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
    REGS_COMP : ENTITY WORK.register_file
    PORT MAP(
        clk => clk, 
        rst => rst, 
        ce => uins.wreg,
        AdRP1 => instruction(25 DOWNTO 21), 
        AdRP2 => instruction(20 DOWNTO 16), 
        AdWP => adD,
        DataWP => reg_dest,
        DataRP1 => R1, 
        DataRP2 => R2
    );
    ALU_COMP : ENTITY WORK.alu
    PORT MAP(
        op1 => R1, 
        op2 => op2,
        sel => uins.i,
        zero => alu_zero,
        carry => alu_carry,
        res => result
    );
    FLAGS_REG: ENTITY WORK.generic_register 
    PORT MAP(
        D => flags_input,
        ce => instR, 
        clk => clk, 
        rst => rst, 
        Q => flags_output
    );
    flags_input <= (1 => alu_carry, 0 => alu_zero, OTHERS => '0');
    
    -- R Type Instructions Detector
    instR <= '1' WHEN (uins.i = ADDU OR uins.i = SUBU OR uins.i = AAND OR 
                       uins.i = OOR  OR uins.i = XXOR OR uins.i = NNOR OR
                       uins.i = CMP) ELSE '0';
                       
    -- Multiplexer 1
    M1 : adD <= instruction(15 DOWNTO 11) WHEN (instR = '1') ELSE instruction(20 DOWNTO 16);
            
    -- Multiplexer 2
    M2 : ext32 <= reg32(RESIZE(sreg32(instruction(15 DOWNTO 0)), 32)) WHEN (
                    (uins.i = LW) OR (uins.i = SW)
                  ) ELSE
                  reg32(RESIZE(ureg32(instruction(15 DOWNTO 0)), 32));
                  
    -- Multiplexer 3
    M3 : op2 <= R2 WHEN (instR = '1') ELSE ext32;
    
    -- Multiplexer 4                                              
    M4 : reg_dest <= data WHEN (uins.i = LW) ELSE result;
    
    -- Data bus Buffer
    WMem : data <= R2 WHEN (uins.rw = '0' AND uins.ce = '1') ELSE (OTHERS => 'Z'); 
                    
    d_address <= result;
    zero <= flags_output(0);
    carry <= flags_output(1);
END Behavioral;
