----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:25:54 06/24/2014 
-- Design Name: 
-- Module Name:    DualAdressBRAM - Behavioral 
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


-- BLOCK-RAM mit separater Lese- und Schreibadresse
--   - "Write" bestimmt ob diesmal geschreiben wird
--   - gelesen wird immer
entity DualAdress_BRAM is
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
end DualAdress_BRAM;

architecture BlockRAM of DualAdress_BRAM is
type speicher is array(0 to (2**Addrbreite)-1) of bit_VECTOR(Wortbreite-1 downto 0);
signal memory : speicher;   
begin
  process begin
    wait until rising_edge(CLK);
    if (Write='1') then
      memory(Awr) <= Din;
    end if;
    Dout <= memory(Ard);
  end process;
end BlockRAM;
