----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:44:11 11/03/2017 
-- Design Name: 
-- Module Name:    REG_FILE_ALL - Behavioral 
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

entity REG_FILE_ALL is
    Port ( RD_N1 : in  STD_LOGIC_VECTOR (2 downto 0);
           RD_N2 : in  STD_LOGIC_VECTOR (2 downto 0);
           LD_CTRL : in  STD_LOGIC_VECTOR (5 downto 0);
			  RD_CTRL : in  STD_LOGIC_VECTOR (5 downto 0);
           WR_D : in  STD_LOGIC_VECTOR (15 downto 0);		--from alu or mem_db
			  D_IN : in  STD_LOGIC_VECTOR (15 downto 0);		--from input switch
			  IMMEDIATE : in  STD_LOGIC_VECTOR (11 downto 0);
           ALU_F : in  STD_LOGIC_VECTOR (7 downto 0);
			  INT_OFFSET : in  STD_LOGIC_VECTOR (2 downto 0);
           CLK : in  STD_LOGIC;
           RD_OUT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           RD_OUT2 : out  STD_LOGIC_VECTOR (15 downto 0);
           MEM_DB : out  STD_LOGIC_VECTOR (15 downto 0);
           RD_F : out  STD_LOGIC_VECTOR (7 downto 0);
           PC_OUT : out  STD_LOGIC_VECTOR (11 downto 0);
           SP_OUT : out  STD_LOGIC_VECTOR (11 downto 0));
end REG_FILE_ALL;

architecture Behavioral of REG_FILE_ALL is
	component REG_FILE_gen_16bit is
		Port ( R_DATA1 : out  STD_LOGIC_VECTOR (15 downto 0);
           R_DATA2 : out  STD_LOGIC_VECTOR (15 downto 0);
           WR_DATA : in  STD_LOGIC_VECTOR (15 downto 0);
           RD_SEL1 : in  STD_LOGIC_VECTOR (2 downto 0);
           RD_SEL2 : in  STD_LOGIC_VECTOR (2 downto 0);
           WR_SEL : in  STD_LOGIC_VECTOR (2 downto 0);
			  WR_EN : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
	end component REG_FILE_gen_16bit;
	component COUNTER_UN_12bit is
		Port ( D_in : in  STD_LOGIC_VECTOR (11 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (11 downto 0);
           SEL : in  STD_LOGIC_VECTOR (1 downto 0);
           RESET : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
	end component COUNTER_UN_12bit;
	component Reg_16bit is
		Port ( D_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (15 downto 0);
           LOAD : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
	end component Reg_16bit;
	component Reg_8bit is
		Port ( D_in : in  STD_LOGIC_VECTOR (7 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (7 downto 0);
           LOAD : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
	end component Reg_8bit;
	component DECODER_3x8 is
		Port ( SEL : in  STD_LOGIC_VECTOR (2 downto 0);
           EN : in  STD_LOGIC;
           D_OUT : out  STD_LOGIC_VECTOR (7 downto 0));
	end component DECODER_3x8;
	component MUX_4x1_16bit is
		Port ( D0 : in  STD_LOGIC_VECTOR (15 downto 0);
           D1 : in  STD_LOGIC_VECTOR (15 downto 0);
           D2 : in  STD_LOGIC_VECTOR (15 downto 0);
           D3 : in  STD_LOGIC_VECTOR (15 downto 0);
           SEL : in  STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0));
	end component MUX_4x1_16bit;
	
	signal rd1_mux_in, rd2_mux_in, epc_mux_in, input_mux_in,
			 out_mux_in, mux41_out, mux42_out : STD_LOGIC_VECTOR (15 downto 0);
	signal pc_mux_in : STD_LOGIC_VECTOR (11 downto 0) := x"000";
	signal sp_mux_in : STD_LOGIC_VECTOR (11 downto 0) := x"c00";
	signal wr_sel, flags_in, f_mux_in, ib_mux_in : STD_LOGIC_VECTOR (7 downto 0);
begin
	WR_DECODER: DECODER_3x8 port map (SEL => LD_CTRL(2 downto 0), EN => LD_CTRL(5), D_OUT => wr_sel);
	GEN_REGS: REG_FILE_gen_16bit port map (RD_SEL1 => RD_N1, RD_SEL2 => RD_N2, WR_SEL => RD_N2, CLK => CLK,
													R_DATA1 => rd1_mux_in, R_DATA2 => rd2_mux_in, 
													WR_DATA => WR_D, WR_EN => wr_sel(0));
	PC: COUNTER_UN_12bit port map (D_in => WR_D(11 downto 0), Q_out => pc_mux_in, SEL(1) => LD_CTRL(3),
												SEL(0) => wr_sel(1), RESET => '0', CLK => CLK);
	SP: COUNTER_UN_12bit port map (D_in => WR_D(11 downto 0), Q_out => sp_mux_in, SEL(1) => LD_CTRL(4),
											 SEL(0) => wr_sel(2), RESET => '0', CLK => CLK);
	EPC: Reg_16bit port map (D_in(15 downto 12) => x"0", D_in(11 downto 0) => pc_mux_in,
										Q_out => epc_mux_in, LOAD => wr_sel(1), CLK => CLK);
	process(wr_sel(3), ALU_F, WR_D(7 downto 0))
	begin
		if wr_sel(3) = '0' then
			flags_in <= ALU_F;
		else
			flags_in <= WR_D(7 downto 0);
		end if;
	end process;
	
	FLAGS: Reg_8bit port map (D_in => flags_in, Q_out => f_mux_in, LOAD => '1', CLK => CLK);
	INT_BASE: Reg_8bit port map (D_in => WR_D(7 downto 0), Q_out => ib_mux_in, LOAD => wr_sel(4), CLK => CLK);
	IN_REG: Reg_16bit port map (D_in => D_IN, Q_out => input_mux_in, LOAD => '1', CLK => CLK);
	OUT_REG: Reg_16bit port map (D_in => WR_D, Q_out => out_mux_in, LOAD => wr_sel(5), CLK => CLK);
	
	OUT_MUX41: MUX_4x1_16bit port map (D0 => rd1_mux_in, D1 => input_mux_in, D2 => epc_mux_in, 
													D3(15 downto 8) => x"00", D3(7 downto 0) => f_mux_in, 
													SEL => RD_CTRL(1 downto 0), OUTPUT => mux41_out);
	OUT_MUX42: MUX_4x1_16bit port map (D0(15 downto 12) => x"0", D0(11 downto 0) => pc_mux_in, D1(15 downto 12) => x"0",
													D1(11 downto 0) => sp_mux_in, D2(15 downto 11) => "00000", 
													D2(10 downto 3) => ib_mux_in, D2(2 downto 0) => INT_OFFSET,
													D3 => out_mux_in, SEL => RD_CTRL(4 downto 3), OUTPUT => mux42_out);
	process(RD_CTRL(2), RD_CTRL(5), mux41_out, mux42_out, IMMEDIATE, rd2_mux_in)
	begin
		if RD_CTRL(2) = '0' then
			RD_OUT1 <= mux41_out;
		else 
			RD_OUT1 <= (3 downto 0 => '0') & IMMEDIATE;
		end if;
		if RD_CTRL(5) = '0' then
			RD_OUT2 <= rd2_mux_in;
		else 
			RD_OUT2 <= mux42_out;
		end if;
	end process;
	
	MEM_DB <= mux41_out;
	RD_F <= f_mux_in;
	PC_OUT <= pc_mux_in;
	SP_OUT <= sp_mux_in;
end Behavioral;

