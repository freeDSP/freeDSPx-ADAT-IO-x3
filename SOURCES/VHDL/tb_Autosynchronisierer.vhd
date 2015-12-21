--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:51 05/27/2014
-- Design Name:   
-- Module Name:   D:/ADAT DeEncoder/ADAT_De-Encoder/tb_Autosynchronisierer.vhd
-- Project Name:  ADAT_De-Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AutoSynchronisierer
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
use work.ADAT.all;
  
ENTITY tb_Autosynchronisierer IS
END tb_Autosynchronisierer;
 
ARCHITECTURE behavior OF tb_Autosynchronisierer IS 
	--## Konfiguration ##--
	constant SCHNITTSTELLEN : natural :=3; 
	constant in_ADAT_Takt_period : time := 10 ns;
	constant Beispielframe : bit_vector(0 to 255) := "1111110000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000000000";
		type timearray is array (natural range <>) of time;
	constant verzögerungen : timearray(0 to 2):= (0*in_ADAT_takt_period, 
																0.51*in_ADAT_takt_period, 
																 130.6*in_ADAT_takt_period); 
	-----------------------
	
    COMPONENT AutoSynchronisierer
	 generic( AdatSchnittstellen : natural := SCHNITTSTELLEN);
    PORT(
         in_ADAT_Takt : IN  std_logic;
         In_ADAT : IN  bit_vector(0 to SCHNITTSTELLEN-1);
         Out_ADAT : out  bit_vector(0 to SCHNITTSTELLEN-1);
         Out_Framesync : OUT  bit;
         Out_Takt : OUT  std_logic;
			
			-- Debug
			debug_ADAT_CHN_FSDelay_Messung   : out AdatBitDelay(0 to SCHNITTSTELLEN-1);     -- Verzögerung der Schnittstelle (für ALLE, um geringste Latenz zu erzeugen)
			debug_ADAT_CHN_FSDelay_Korrektur : out AdatBitDelay(0 to SCHNITTSTELLEN-1);
			debug_ADAT_Framesync_CHN : out bit_vector(0 to SCHNITTSTELLEN-1);
			debug_ADAT_Takt_CHN: out std_logic_vector(0 to SCHNITTSTELLEN-1);
			debug_sLeitungsindex : out tLeitungsindex(0 to SCHNITTSTELLEN-1);
		   debug_ADAT_Langsam : out ADATLangsam(0 to SCHNITTSTELLEN-1);
		   debug_ADAT_in_phasenkorrigiert : out bit_vector(0 to SCHNITTSTELLEN-1)
        );
    END COMPONENT;
    

   --Inputs
   signal tb_in_ADAT_Takt : std_logic := '0';
   signal tb_In_ADAT : bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0');

 	--Outputs
   signal tb_Out_ADAT : bit_vector(0 to SCHNITTSTELLEN-1);
   signal tb_Out_Framesync : bit;
   signal tb_Out_Takt : std_logic;
													 
	
	signal dbg_bitindex : bytearray (0 to SCHNITTSTELLEN-1);
	
	signal tb_debug_ADAT_CHN_FSDelay_Messung : AdatBitDelay(0 to SCHNITTSTELLEN-1);     -- Verzögerung der Schnittstelle (für ALLE, um geringste Latenz zu erzeugen)
	signal tb_debug_ADAT_CHN_FSDelay_Korrektur : AdatBitDelay(0 to SCHNITTSTELLEN-1);
	signal tb_debug_ADAT_Framesync_CHN : bit_vector(0 to SCHNITTSTELLEN-1);
	signal tb_debug_ADAT_Takt_CHN : std_logic_vector(0 to SCHNITTSTELLEN-1);
	signal debug_Adat_outs_gleich: bit;
	signal tb_debug_sLeitungsindex : tLeitungsindex(0 to SCHNITTSTELLEN-1);
	signal tb_debug_ADAT_Langsam : ADATLangsam(0 to SCHNITTSTELLEN-1);
	signal tb_debug_ADAT_in_phasenkorrigiert : bit_vector(0 to SCHNITTSTELLEN-1);
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AutoSynchronisierer PORT MAP (
          in_ADAT_Takt => tb_in_ADAT_Takt,
          In_ADAT => tb_In_ADAT,
          Out_ADAT => tb_Out_ADAT,
          Out_Framesync => tb_Out_Framesync,
          Out_Takt => tb_Out_Takt,
			 
			 debug_ADAT_CHN_FSDelay_Messung => tb_debug_ADAT_CHN_FSDelay_Messung,
			 debug_ADAT_CHN_FSDelay_Korrektur => tb_debug_ADAT_CHN_FSDelay_Korrektur,
			 debug_ADAT_Framesync_CHN => tb_debug_ADAT_Framesync_CHN,
			 debug_ADAT_Takt_CHN => tb_debug_ADAT_Takt_CHN,
			 debug_sLeitungsindex => tb_debug_sLeitungsindex,
			 debug_ADAT_Langsam => tb_debug_ADAT_Langsam,
			 debug_ADAT_in_phasenkorrigiert => tb_debug_ADAT_in_phasenkorrigiert
        );

   -- Clock process definitions
   in_ADAT_Takt_process :process
   begin
		tb_in_ADAT_Takt <= '0';
		wait for in_ADAT_Takt_period/2;
		tb_in_ADAT_takt <= '1';
		wait for in_ADAT_Takt_period/2;
   end process;
 

   EinmalProAdatSchnittstelle: for Schnittstelle in 0 to SCHNITTSTELLEN-1 generate
		-- Stimulus process
		stim_proc: process
			variable bitindex : natural range 0 to 255 := 0;
			variable adat_leitung : bit := '0';
		begin		
			-- hold reset state for 100 ns.
			wait for 100 ns;	
			wait for in_ADAT_Takt_period*10;

			-- insert stimulus here 
			--Verzögerung:
			wait for verzögerungen(Schnittstelle);
			--Senden:
			for i in 1 to 100*256 loop
				if Beispielframe(bitindex)='1' then -- NRZI
					adat_leitung := not adat_leitung;
					tb_In_ADAT(Schnittstelle) <= adat_leitung;
				else
					--nichts
				end if;
				
				if bitindex /= 255 then
					bitindex := bitindex + 1;
				else
					bitindex := 0;
				end if;
				dbg_bitindex(Schnittstelle) <= bitindex;
				
				wait for in_ADAT_takt_period;
			end loop;
			
			wait;
		end process;
	end generate;
	debug_Adat_outs_gleich <= not( (tb_Out_ADAT(0) xor tb_Out_ADAT(1)) or (tb_Out_ADAT(0) xor tb_Out_ADAT(2)));
END;
