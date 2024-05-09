----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:43:05 11/02/2017 
-- Design Name: 
-- Module Name:    DECODER_3x8 - Behavioral 
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

entity DECODER_3x8 is
    Port ( SEL : in  STD_LOGIC_VECTOR (2 downto 0);
           EN : in  STD_LOGIC;
           D_OUT : out  STD_LOGIC_VECTOR (7 downto 0));
end DECODER_3x8;

architecture Behavioral of DECODER_3x8 is

begin
	process(SEL, EN)
	begin
		if EN = '1' then
			case (SEL) is
				when "000" =>
					D_OUT <= "00000001";
				when "001" =>
					D_OUT <= "00000010";
				when "010" =>
					D_OUT <= "00000100";
				when "011" =>
					D_OUT <= "00001000";
				when "100" =>
					D_OUT <= "00010000";
				when "101" =>
					D_OUT <= "00100000";
				when "110" =>
					D_OUT <= "01000000";
				when "111" =>
					D_OUT <= "10000000";
				when others =>
					D_OUT <= "00000001";
			end case;
		else
			D_OUT <= (7 downto 0 => '0');
		end if;
	end process;
end Behavioral;

