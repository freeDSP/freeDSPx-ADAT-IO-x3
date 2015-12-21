library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_unsigned.all; -- für conv_integer()
use work.ADAT.all;
--------------------------------------------------------------------------------------------------
-- BlockRAM nach UG627 v14.5 S.143 "Single -Port RAM In No-Change Mode VHDL Coding Example Two" --
--------------------------------------------------------------------------------------------------
entity ADAT_BLOCKRAM is
	generic( ADAT_SCHNITTSTELLEN : natural := 3;
				PUFFER_LAENGE : natural := 6
				);
	port(clk  : in std_logic;
		  we   : in std_logic;
		  en 	 : in  std_logic;
		  --#addr : in std_logic_vector(PUFFER_ADRESSLAENGE-1 downto 0);
		  addr : in natural;
		  di	 : in bit_vector(ADAT_DATENMENGE*ADAT_SCHNITTSTELLEN-1 downto 0);
		  do	 : out bit_vector(ADAT_DATENMENGE*ADAT_SCHNITTSTELLEN-1 downto 0)
		  );
end ADAT_BLOCKRAM;

--architecture Verhalten_ReadFirst of ADAT_BLOCKRAM is --Wenn geschrieben wird, wird auch immer gelesen (selbe Adresse)
--	type ram_type is array (63 downto 0) of std_logic_vector (15 downto 0);
--	signal RAM : ram_type;
--begin
--	process (clk)
--		begin
--			if clk'event and clk = '1' then
--				if en = '1' then
--					RAM(conv_integer(addr)) <= di;
--				end if;
--				do <= RAM(conv_integer(addr));
--			end if;
--		end process;
--end Verhalten_ReadFirst;

architecture Verhalten_NoChange of ADAT_BLOCKRAM is --Es wird entweder gelesen oder geschrieben
	type ram_type is array (PUFFER_LAENGE-1 downto 0) of bit_vector (ADAT_DATENMENGE*ADAT_SCHNITTSTELLEN-1 downto 0);
	signal RAM : ram_type;
begin
	process (clk)
		begin
			if clk'event and clk = '1' then
				if en = '1' then
					if we ='1' then
						--#RAM(conv_integer(addr)) <= di;
						RAM(addr) <= di;
					else
						--#do <= RAM(conv_integer(addr));
						do <= RAM(addr);
					end if;
				end if;
			end if;
		end process;
end Verhalten_NoChange;
