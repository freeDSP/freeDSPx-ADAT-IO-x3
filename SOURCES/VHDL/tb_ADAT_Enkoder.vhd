--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:55:27 11/05/2013
-- Design Name:   
-- Module Name:   Z:/ADAT DeEncoder/ADAT_De-Encoder/tb_ADAT_Enkoder.vhd
-- Project Name:  ADAT_De-Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ADAT_Enkoder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types bit and
-- bit_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use work.ADAT.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_ADAT_Enkoder IS
END tb_ADAT_Enkoder;
 
ARCHITECTURE behavior OF tb_ADAT_Enkoder IS 
	 constant TB_KANAELE : natural := 3;
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ADAT_Enkoder
	 generic( AdatSchnittstellen : integer);--Anzahl der Adat-Schnittstellen, von denen Daten entgegen genommen werden sollen
    PORT(
         ADAT_Frame_Sync  : in bit;
			ADAT_Bit_Clock   : in std_logic;
			Daten            : in ADAT_Daten_Array(0 to AdatSchnittstellen-1);
			DatenUebernommen : out bit; --Ändert sich, wenn die Daten übernommen wurden
			Out_ADAT         : out bit_vector(0 to AdatSchnittstellen-1);
			--Debug:
			dbg_Bitnummer : out natural range 0 to 255
        );
    END COMPONENT;
    

   --Inputs
   signal tb_ADAT_Frame_Sync : bit := '0';
   signal tb_ADAT_Bit_Clock : std_Logic := '0';
	signal tb_Daten : ADAT_Daten_Array(0 to TB_KANAELE-1);
 	--Outputs
   signal tb_Out_ADAT : bit_vector(0 to TB_KANAELE-1);
	signal tb_DatenUebernommen : bit;
	--Debug
	signal tb_dbg_Bitnummer : natural range 0 to 255;
   -- Clock period definitions
   constant ADAT_Bit_Clock_period : time := 81.38020833 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ADAT_Enkoder 
		generic map(AdatSchnittstellen => TB_KANAELE)
		PORT MAP (
          ADAT_Frame_Sync => tb_ADAT_Frame_Sync,
          ADAT_Bit_Clock => tb_ADAT_Bit_Clock,
          Daten => tb_Daten,
			 DatenUebernommen => tb_DatenUebernommen,
          Out_ADAT => tb_Out_ADAT,
			 dbg_Bitnummer => tb_dbg_Bitnummer
        );

   -- Clock process definitions
   ADAT_Bit_Clock_process :process
   begin
		tb_ADAT_Bit_Clock <= '0';
		wait for ADAT_Bit_Clock_period/2;
		tb_ADAT_Bit_Clock <= '1';
		wait for ADAT_Bit_Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for ADAT_Bit_Clock_period*10;

      -- insert stimulus here 
		tb_ADAT_Frame_Sync <= '1';
		wait for ADAT_Bit_Clock_period/2;
		tb_ADAT_Frame_Sync <= '0';
		wait for 255.5*ADAT_Bit_Clock_period;
		tb_ADAT_Frame_Sync <= '1';
		
		tb_Daten(0).Kanaele(0) <= "000011110000111100001111";
		wait for ADAT_Bit_Clock_period/2;
		tb_ADAT_Frame_Sync <= '0';
		tb_Daten(0).Kanaele(1) <= "111111111111111111111111" after 3ns; --mitten im Senden neue Daten reingeben
		wait for 255.5*ADAT_Bit_Clock_period;
		tb_ADAT_Frame_Sync <= '1';
		
		wait for ADAT_Bit_Clock_period/2;
		tb_ADAT_Frame_Sync <= '0';
		wait for 255.5*ADAT_Bit_Clock_period;
		tb_ADAT_Frame_Sync <= '1';
      wait;
   end process;

END;
