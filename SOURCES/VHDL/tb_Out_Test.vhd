--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:13:06 11/11/2013
-- Design Name:   
-- Module Name:   Z:/ADAT DeEncoder/ADAT_De-Encoder/tb_Out_Test.vhd
-- Project Name:  ADAT_De-Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ADAT_Out_Test
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_Out_Test IS
	generic( SCHNITTSTELLEN : natural := 3);
END tb_Out_Test;
 
ARCHITECTURE behavior OF tb_Out_Test IS 
    COMPONENT ADAT_Out_Test
	 generic (AdatSchnittstellen : natural := 3;
				PUFFERLAENGE : natural := 2);
    PORT(
         in_Platinentakt: in std_logic;
			 Out_ADAT : out bit_vector(0 to SCHNITTSTELLEN-1);
			 --Debug_Audio: out bit_vector(23 downto 0);
			 Debug_Schneller_Takt: out std_logic;
			 Debug_ADAT_Takt: out std_logic;
			 
			 Out_PufferVoll : out bit := '0';
			 Out_PufferLeer : out bit := '1';
			 Out_PufferUeberlauf : out bit := '0';
			 Out_PufferUnterlauf : out bit := '0';
			 
			 Out_EsLebt : out bit :='0'
        );
    END COMPONENT;

   --Inputs
   signal tb_Platinentakt : std_logic := '0';
	signal tb_ADAT_Out : bit_vector(0 to SCHNITTSTELLEN-1);
	
	signal tb_Out_PufferVoll : bit;
   signal tb_Out_PufferLeer : bit;
   signal tb_Out_PufferUeberlauf : bit;
   signal tb_Out_PufferUnterlauf : bit;
	signal tb_Out_EsLebt : bit;
	
	signal tb_Debug_Audio: bit_vector(23 downto 0);
	signal tb_Debug_Schneller_Takt: std_logic;
	signal tb_Debug_ADAT_Takt: std_logic;
 
   constant tb_Platinentakt_period : time := 20 ns; --50MHz, wie auf der Platine
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: ADAT_Out_Test 
		generic map( 
			 AdatSchnittstellen => SCHNITTSTELLEN
			 )
		PORT MAP (
          in_Platinentakt => tb_Platinentakt,
			 Out_ADAT => tb_ADAT_Out,
			 --Debug_Audio => tb_Debug_Audio,
			 Debug_Schneller_Takt => tb_Debug_Schneller_Takt,
			 Debug_ADAT_Takt => tb_Debug_ADAT_Takt,
			 Out_PufferVoll => tb_Out_PufferVoll,
			 Out_PufferLeer => tb_Out_PufferLeer,
			 Out_PufferUeberlauf => tb_Out_PufferUeberlauf,
			 Out_PufferUnterlauf => tb_Out_PufferUnterlauf,
			 Out_EsLebt => tb_Out_EsLebt
        );

   -- Clock process definitions
   Platinentakt_process :process
   begin
		tb_Platinentakt<= '0';
		wait for tb_Platinentakt_period/2;
		tb_Platinentakt <= '1';
		wait for tb_Platinentakt_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for tb_Platinentakt_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
