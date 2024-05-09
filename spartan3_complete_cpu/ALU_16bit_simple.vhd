----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:08:44 10/31/2017 
-- Design Name: 
-- Module Name:    ALU_16bit_simple - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY ALU_16bit_simple IS
	port(
		  a, b : in std_logic_vector(15 downto 0);	-- a and b are busses
		  op   : in std_logic_vector(2 downto 0);
		  zero : out std_logic;
	     f    : out std_logic_vector(15 downto 0)
		 );
END ALU_16bit_simple;

architecture behavioral of ALU_16bit_simple is
begin
	process(op)
	variable temp: std_logic_vector(15 downto 0);
	begin
	case op is
		when "000" =>
			temp := a and b;
		when "100" =>
			temp := "0000000000000000"; --clear command
		when "001" =>
			temp := a or b;
		when "101" =>
			temp := "1111111111111111"; --set command
		when "010" =>
			temp := a + b;
		when "011" =>
			temp := not a;
		when "110" =>
			temp := a - b;
		when "111" =>
			if a < b then
			temp := "1111111111111111";
			else
			temp := "0000000000000000";
			end if;
		when others =>
			temp := a - b;
	end case;
	if temp="00000000" then
	zero <= '1';
	else
	zero <= '0';
	end if;
	f <= temp;
	end process;
end behavioral;
