----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:03:38 11/01/2017 
-- Design Name: 
-- Module Name:    BARREL_SHIFTER_16bit - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity BARREL_SHIFTER_16bit is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           Y : out  STD_LOGIC_VECTOR (15 downto 0);
           SH : in  STD_LOGIC_VECTOR (6 downto 0));
end BARREL_SHIFTER_16bit;

architecture Behavioral of BARREL_SHIFTER_16bit is
begin
	process(SH, A)
		variable s1, s2, s3, s4 : std_logic_vector(15 downto 0);		--intermidiary shifted signals
		variable shv : std_logic;		--shift amount
	begin
		if SH(6 downto 5) = "01" then		--arith shift
			shv := '1';
		else 				--other shifts
			shv := '0';
		end if;
		case SH(4) is
			when '0' =>			-- shift right
				if SH(0) = '1' and SH(6 downto 5) = "10" then --rotate	
					s1 := A(0) & A(15 downto 1);
				elsif SH(0) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s1 := shv & A(15 downto 1);
				else 
					s1 :=	A;
				end if;
				if SH(1) = '1' and SH(6 downto 5) = "10" then --rotate
					s2 := s1(1 downto 0) & s1(15 downto 2);  
				elsif SH(1) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s2 := (1 downto 0 => shv) & s1(15 downto 2);
				else 
					s2 := s1;
				end if;
				if SH(2) = '1' and SH(6 downto 5) = "10" then --rotate
					s3 := s2(3 downto 0) & s2(15 downto 4);
				elsif SH(2) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s3 := (3 downto 0 => shv) & s2(15 downto 4);
				else 
					s3 := s2;
				end if;
				if SH(3) = '1' and SH(6 downto 5) = "10" then --rotate
					s4 := s3(7 downto 0) & s3(15 downto 8);
				elsif SH(3) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s4 := (7 downto 0 => shv) & s3(15 downto 8);
				else 
					s4 := s3;
				end if;
			when others =>		-- shift left
				if SH(0) = '1' and SH(6 downto 5) = "10" then --rotate	
					s1 := A(14 downto 0) & A(15);
				elsif SH(0) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s1 := A(14 downto 0) & shv;
				else 
					s1 :=	A;
				end if;
				if SH(1) = '1' and SH(6 downto 5) = "10" then --rotate
					s2 := s1(13 downto 0) & s1(15 downto 14);  
				elsif SH(1) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s2 := s1(13 downto 0) & (1 downto 0 => shv);
				else 
					s2 := s1;
				end if;
				if SH(2) = '1' and SH(6 downto 5) = "10" then --rotate
					s3 := s2(11 downto 0) & s2(15 downto 12);
				elsif SH(2) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s3 := s2(11 downto 0) & (3 downto 0 => shv);
				else 
					s3 := s2;
				end if;
				if SH(3) = '1' and SH(6 downto 5) = "10" then --rotate
					s4 := s3(7 downto 0) & s3(15 downto 8);
				elsif SH(3) = '1' and SH(6 downto 5) /= "10" then --logical/arith
					s4 := s3(7 downto 0) & (7 downto 0 => shv);
				else 
					s4 := s3;
				end if;
			end case;
		Y <= s4;
	end process;
end Behavioral;

