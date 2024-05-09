----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:32:45 11/02/2017 
-- Design Name: 
-- Module Name:    MUX_8x1_16bit - Behavioral 
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

entity MUX_8x1_16bit is
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
end MUX_8x1_16bit;

architecture Behavioral of MUX_8x1_16bit is

begin
	process(SEL, D0, D1, D2, D3, D4, D5, D6, D7)
	begin
		case (SEL) is
			when "000" =>
				OUTPUT <= D0;
			when "001" =>
				OUTPUT <= D1;
			when "010" =>
				OUTPUT <= D2;
			when "011" =>
				OUTPUT <= D3;
			when "100" =>
				OUTPUT <= D4;
			when "101" =>
				OUTPUT <= D5;
			when "110" =>
				OUTPUT <= D6;
			when "111" =>
				OUTPUT <= D7;
			when others =>
				OUTPUT <= D0;
		end case;
	end process;
end Behavioral;

