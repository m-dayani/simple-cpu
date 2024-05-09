----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:24:27 11/02/2017 
-- Design Name: 
-- Module Name:    REG_FILE_gen_16bit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REG_FILE_gen_16bit is
    Port ( R_DATA1 : out  STD_LOGIC_VECTOR (15 downto 0);
           R_DATA2 : out  STD_LOGIC_VECTOR (15 downto 0);
           WR_DATA : in  STD_LOGIC_VECTOR (15 downto 0);
           RD_SEL1 : in  STD_LOGIC_VECTOR (2 downto 0);
           RD_SEL2 : in  STD_LOGIC_VECTOR (2 downto 0);
           WR_SEL : in  STD_LOGIC_VECTOR (2 downto 0);
			  WR_EN : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end REG_FILE_gen_16bit;

architecture Behavioral of REG_FILE_gen_16bit is
	component Reg_16bit is
		Port ( D_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (15 downto 0);
           LOAD : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
	end component Reg_16bit;
	component MUX_8x1_16bit is
		Port ( D0 : in  STD_LOGIC_VECTOR (15 downto 0);
           D1 : in  STD_LOGIC_VECTOR (15 downto 0);
           D2 : in  STD_LOGIC_VECTOR (15 downto 0);
           D3 : in  STD_LOGIC_VECTOR (15 downto 0);
           D4 : in  STD_LOGIC_VECTOR (15 downto 0);
           D5 : in  STD_LOGIC_VECTOR (15 downto 0);
           D6 : in  STD_LOGIC_VECTOR (15 downto 0);
           D7 : in  STD_LOGIC_VECTOR (15 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0);
           SEL : in  STD_LOGIC_VECTOR (2 downto 0));
	end component MUX_8x1_16bit;
	component DECODER_3x8 is
		Port ( SEL : in  STD_LOGIC_VECTOR (2 downto 0);
           EN : in  STD_LOGIC;
           D_OUT : out  STD_LOGIC_VECTOR (7 downto 0));
	end component DECODER_3x8;
	
	signal r_out0, r_out1, r_out2, r_out3, r_out4, r_out5, r_out6, r_out7 : STD_LOGIC_VECTOR (15 downto 0);
	signal r_ld : STD_LOGIC_VECTOR (7 downto 0);
begin
	REG0: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out0, LOAD => r_ld(0), CLK => CLK);
	REG1: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out1, LOAD => r_ld(1), CLK => CLK);
	REG2: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out2, LOAD => r_ld(2), CLK => CLK);
	REG3: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out3, LOAD => r_ld(3), CLK => CLK);
	REG4: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out4, LOAD => r_ld(4), CLK => CLK);
	REG5: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out5, LOAD => r_ld(5), CLK => CLK);
	REG6: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out6, LOAD => r_ld(6), CLK => CLK);
	REG7: Reg_16bit port map (D_in => WR_DATA, Q_OUT => r_out7, LOAD => r_ld(7), CLK => CLK);
	
	DECODER_IN: DECODER_3x8 port map (SEL => WR_SEL, EN => WR_EN, D_OUT => r_ld);
	
	RD_MUX1: MUX_8x1_16bit port map (D0 => r_out0, D1 => r_out1, D2 => r_out2, D3 => r_out3,
												D4 => r_out4, D5 => r_out5, D6 => r_out6, D7 => r_out7,
												OUTPUT => R_DATA1, SEL => RD_SEL1);
	RD_MUX2: MUX_8x1_16bit port map (D0 => r_out0, D1 => r_out1, D2 => r_out2, D3 => r_out3,
												D4 => r_out4, D5 => r_out5, D6 => r_out6, D7 => r_out7,
												OUTPUT => R_DATA2, SEL => RD_SEL2);
end Behavioral;

