----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:22:38 06/24/2014 
-- Design Name: 
-- Module Name:    Delayline_BRAM - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Ringpuffer im Block-RAM, bei dem Schreib und Leseadresse automatisch
-- hochgezählt werden. Außerdem kann über "delay" der Abstand zwischen
-- Schreib- und Leseadresse eingestellt werden.
--
-- Effektiv entspricht dies einer zur Laufzeit einstellbaren Verzögerung.

entity Delayline_BRAM is
    Generic (
           Addrbreite  : natural := 8;  -- Speicherlänge = 2^Addrbreite
           Wortbreite  : natural := 8
           );
    Port ( clk   : in  std_logic;
           input : in  bit_vector(Wortbreite-1 downto 0);
           delay : in  natural range 0 to (2**Addrbreite)-1;
           output: out bit_vector(Wortbreite-1 downto 0)--;
         );
end Delayline_BRAM;

architecture BlockRAM of Delayline_BRAM is
	component DualAdress_BRAM is
		 Generic (
				  Addrbreite  : natural := 8;  -- Speicherlänge = 2^Addrbreite
				  Wortbreite  : natural := 8
				  );
		 Port ( clk   : in  std_logic;
				  Write : in  bit;
				  Awr   : in  natural range 0 to 2**Addrbreite-1;
				  Ard   : in  natural range 0 to 2**Addrbreite-1;
				  Din   : in  bit_VECTOR (Wortbreite-1 downto 0);
				  Dout  : out bit_VECTOR (Wortbreite-1 downto 0)
				);
	end component;
	
	--signale
	signal AddrWrite : natural range 0 to 2**Addrbreite-1;
	signal AddrRead  : natural range 0 to 2**Addrbreite-1;
	--signal BRAMoutput: bit_vector(Wortbreite-1 downto 0);
begin
	inst_BRAM: DualAdress_BRAM
		generic map(Addrbreite => Addrbreite,
					   Wortbreite => Wortbreite)
		port map (
			clk => clk,
			Write => '1',
			Awr => AddrWrite,
			Ard => AddrRead,
			Din => input,
			Dout => output--BRAMoutput
		);

	-- Sorgt dafür, dass aus einem normalen BRAM eine Delayline wird
	Adresslogik: process (CLK)
		variable Leseadresse:    natural range 0 to 2**Addrbreite-1 := 0;
		variable Schreibadresse: natural range 0 to 2**Addrbreite-1 := 0;
	begin
		if rising_edge(CLK) then
			Leseadresse := (Leseadresse + 1) mod 2**Addrbreite;
			Schreibadresse := (Leseadresse + delay) mod 2**Addrbreite; 
			AddrRead <= Leseadresse;
			AddrWrite <= Schreibadresse;
		end if;
	end process;
	
	--output <= input when delay=0 else BRAMoutput;
end BlockRAM;

