----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:41:09 12/30/2013 
-- Design Name: 
-- Module Name:    McBSP-Interface - McBSP_Verhalten 
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
use work.ADAT.all;

entity McBSP_Interface is
	 generic ( SCHNITTSTELLEN : natural := 1;
				  FSR_OUTPUT : boolean := false;
				  -- [Pegeleinstellungen] --
				  -- Empfangen
				  FSR_Aktiv : bit := '1';
				  --FSR_Inaktiv :bit := '0';
				  CLKR_Aktiv : bit := '0'; --Zustand nach der Flanke, an der die Daten gelesen werden sollen
				  --CLKR_Inaktiv :bit := '1';
				  FSR_Verzögerung : natural range 1 to 2 := 1;
				  -- Senden
				  FSX_Aktiv : bit := '1';
				  --FSX_Inaktiv :bit := '0';
				  CLKX_Aktiv : bit := '1'; --Zustand nach der Flanke, an der die Daten gesendet werden sollen (typischerweise ungleich CLKR-Aktiv)
				  --CLKX_Inaktiv :bit := '0';
				  FSX_Verzögerung : natural range 1 to 2 := 1
				  );
    PORT(
			-- McBSP
         CLKR : IN   bit;          
			 FSR : INOUT std_logic;
           DR : IN   bit;
         CLKX : IN   bit;
          FSX : OUT  bit := '0';
           DX : OUT  bit := '0';
         --CLKS : IN   std_logic; --Nicht verwendet
			
			-- ADAT-Puffer
			Daten_komplett_empfangen : OUT bit := '0';
			--Daten_komplett_gesendet  : OUT bit := '0';
			Neue_Daten_Zum_Senden : in bit;
			
			-- Daten
			Daten_Eingang : in ADAT_Daten_Array(0 to SCHNITTSTELLEN-1); --McbSP<-Interface[Daten-Eingang]<-FPGA
			Daten_Ausgang : out ADAT_Daten_Array(0 to SCHNITTSTELLEN-1); --McBSP->Interface[Daten-Ausgang]->FPGA
			
			--Debug
			dbg_R_Schnittstellennummer : out natural;
			dbg_R_Kanalnummer : out natural;
			dbg_R_Bitnummer : out natural;
			dbg_X_Schnittstellennummer : out natural;
			dbg_X_Kanalnummer : out natural;
			dbg_X_Bitnummer : out natural
        );
end McBSP_Interface;

architecture McBSP_Verhalten of McBSP_Interface is
	signal Neue_Daten_Zum_Senden_synchronisiert : bit;
	signal FSX_buf : bit;
	signal FSX_buf_bv : bit_vector(0 downto 0);
	signal FSX_buf_lv : std_logic_vector(0 downto 0);
	signal FSR_buf : bit;
begin
	FSX_buf_bv(0) <= FSX_buf;
	FSX_buf_lv <= to_stdlogicvector(FSX_buf_bv);
	
	
	FSX <= FSX_buf;
	FSR_buf <= to_bit(FSR) when (FSR_OUTPUT=false) else 
				  FSX_buf;
	FSR <= 'Z' when  (FSR_OUTPUT=false) else
				  FSX_buf_lv(0);
	 
	McBSP_Lesen: process(CLKR)
		variable Schnittstellennummer : natural range 0 to SCHNITTSTELLEN-1;
		variable Kanalnummer : natural range  0 to 7;
		variable Bitnummer : natural range 0 to 23;
		variable TempFiFo : bit_vector(0 to 23);

		type Übertragungsphase is (WartenAufFrameSync, FrameAnfangAbwarten, ADAT_AudioDaten, ADAT_Userbits, Benutzerdaten);
		variable Phase : Übertragungsphase := WartenAufFrameSync;
		variable FSR_VerzögerungsTimer : natural range 0 to FSR_Verzögerung;
		
		variable komplett_empfangen : bit := '0';
	begin
		if CLKR'event and CLKR = CLKR_Aktiv then -- Takt
			if FSR_buf = FSR_Aktiv then --Frame-Sync-Reset
				Schnittstellennummer := 0;
				Kanalnummer := 0;
				Bitnummer := 0;
				if FSR_Verzögerung = 0 then
					Phase := ADAT_Userbits;--ADAT_AudioDaten;
					--TempFiFo := TempFiFo(1 to 23) & DR; --Bit einlesen
					--Bitnummer := 1; --Bit 0 wurde bereits gelesen
				else
					Phase := FrameAnfangAbwarten;
				end if;
			end if;
			TempFiFo := TempFiFo(1 to 23) & DR; --Bit einlesen
			dbg_R_Bitnummer <= Bitnummer;
			dbg_R_Kanalnummer <= Kanalnummer;
			dbg_R_Schnittstellennummer <= Schnittstellennummer;				
			case Phase is
				when FrameAnfangAbwarten =>
					if FSR_VerzögerungsTimer = FSR_Verzögerung-1 then
						Phase := ADAT_Userbits;--ADAT_AudioDaten;
					else
						FSR_VerzögerungsTimer := FSR_VerzögerungsTimer + 1;
					end if;
				when ADAT_Userbits =>
					if Bitnummer = 23 then --normal:3, wegen auffüllen auf 24 bit hier 23 (minimal geringere Latenz noch möglich)
						Daten_Ausgang(Schnittstellennummer).Userbits <= TempFiFo(0 to 3);
--						if Schnittstellennummer = SCHNITTSTELLEN-1 then
--							Phase := WartenAufFrameSync; --> Phasenwechsel -->
--							komplett_empfangen := not komplett_empfangen;
--							Daten_komplett_empfangen <= komplett_empfangen;
--						else
--						Schnittstellennummer := Schnittstellennummer + 1;
						Bitnummer := 0;
						Kanalnummer := 0;
						Phase := ADAT_AudioDaten; --> Phasenwechsel -->
--						end if;
					else
						Bitnummer := Bitnummer + 1;
					end if;
				when ADAT_AudioDaten =>
					if Bitnummer = 23 then --Daten für einen Kanal komplett?
						if Kanalnummer = 7 then
							Daten_Ausgang(Schnittstellennummer).Kanaele(Kanalnummer) <= TempFiFo;
							if Schnittstellennummer = SCHNITTSTELLEN-1 then
								Phase := WartenAufFrameSync; --> Phasenwechsel -->
								komplett_empfangen := not komplett_empfangen;
								Daten_komplett_empfangen <= komplett_empfangen;
							else
								Kanalnummer := 0;
								Phase := ADAT_Userbits; --> Phasenwechsel -->
							end if;
							Schnittstellennummer := Schnittstellennummer + 1;
						else
							Daten_Ausgang(Schnittstellennummer).Kanaele(Kanalnummer) <= TempFiFo;
							Kanalnummer := Kanalnummer + 1;
						end if;
						Bitnummer := 0;
					else
						Bitnummer := Bitnummer + 1;
					end if;
					
				when WartenAufFrameSync =>
					--nichts tun
					
				when others =>
					Phase := WartenAufFrameSync;
			end case;
		end if;
	end process;
	
	McBSP_Schreiben: process(CLKX)
		variable Schnittstellennummer : natural range 0 to SCHNITTSTELLEN-1;
		variable Kanalnummer : natural range  0 to 7;
		variable Bitnummer : natural range 0 to 23;
		--variable Eingangspuffer : ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
		--variable TempFiFo : bit_vector(0 to 23);

		type Übertragungsphase is (WartenAufDaten, FrameAnfangAbwarten, ADAT_AudioDaten, ADAT_Userbits, Benutzerdaten);
		variable Phase : Übertragungsphase := WartenAufDaten;
		variable FSX_VerzögerungsTimer : natural range 0 to FSX_Verzögerung := 0;
		
		variable komplett_gesendet : bit := '0';
		variable Neue_Daten_Zum_Senden_alt : bit;
		
	begin
			if CLKX'event and CLKX = CLKX_Aktiv then -- Takt
				dbg_X_Bitnummer <= Bitnummer;
				dbg_X_Kanalnummer <= Kanalnummer;
				dbg_X_Schnittstellennummer <= Schnittstellennummer;
				
				Neue_Daten_Zum_Senden_synchronisiert <= Neue_Daten_Zum_Senden;
				
				case Phase is
					when WartenAufDaten =>
						if Neue_Daten_Zum_Senden_synchronisiert /= Neue_Daten_Zum_Senden_alt then
							--Eingangspuffer := Daten_Eingang;
							Neue_Daten_Zum_Senden_alt := Neue_Daten_Zum_Senden_synchronisiert;
							Bitnummer := 0;
							Kanalnummer := 0;
							Schnittstellennummer := 0;
							FSX_buf <= FSX_Aktiv;
							if FSX_Verzögerung=1 then
								Phase := ADAT_AudioDaten;
							else
								Phase := FrameAnfangAbwarten;
							end if;
						end if;
						
					when FrameAnfangAbwarten =>
						FSX_buf <= not FSX_Aktiv;
						if FSX_VerzögerungsTimer = FSX_Verzögerung-1 then
							Phase := ADAT_AudioDaten; --> Phasenwechsel -->
						else
							FSX_VerzögerungsTimer := FSX_VerzögerungsTimer + 1;
						end if;
						
					when ADAT_AudioDaten =>
						FSX_buf <= not FSX_Aktiv;
						--DX <= Eingangspuffer(Schnittstellennummer).Kanaele(Kanalnummer)(23-Bitnummer);
						DX <= Daten_Eingang(Schnittstellennummer).Kanaele(Kanalnummer)(23-Bitnummer);
						if Bitnummer = 23 then --Daten für einen Kanal komplett?
							if Kanalnummer = 7 then
								Kanalnummer := 0;
								Phase := ADAT_Userbits; --> Phasenwechsel -->
							else
								Kanalnummer := Kanalnummer + 1;
							end if;
							Bitnummer := 0;
						else
							Bitnummer := Bitnummer + 1;
						end if;
					when ADAT_Userbits =>
						--DX <= Eingangspuffer(Schnittstellennummer).Userbits(3-Bitnummer);
						if Bitnummer < 4 then --Daten senden, danach warten bis insgesamt 24 bit
							DX <= Daten_Eingang(Schnittstellennummer).Userbits(3-Bitnummer);
						end if;
						if Bitnummer = 23 then
							if Schnittstellennummer = SCHNITTSTELLEN-1 then
								Phase := WartenAufDaten; --> Phasenwechsel -->
							else
								Schnittstellennummer := Schnittstellennummer + 1;
								Bitnummer := 0;
								Kanalnummer := 0;
								Phase := ADAT_AudioDaten; --> Phasenwechsel -->
							end if;
						else
							Bitnummer := Bitnummer + 1;
						end if;
					when others =>
						Phase := WartenAufDaten;
				end case;
			end if;
	end process;
	
	
	--## alte Version: ##
--	McBSP_Schreiben: process(CLKX)
--		variable Schnittstellennummer : natural range 0 to SCHNITTSTELLEN-1;
--		variable Kanalnummer : natural range  0 to 7;
--		variable Bitnummer : natural range 0 to 23;
--		variable Eingangspuffer : ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
--		variable TempFiFo : bit_vector(0 to 23);
--
--		type Übertragungsphase is (WartenAufFrameSync, FrameAnfangAbwarten, ADAT_AudioDaten, ADAT_Userbits, Benutzerdaten);
--		variable Phase : Übertragungsphase := WartenAufFrameSync;
--		variable FSX_VerzögerungsTimer : natural range 0 to FSX_Verzögerung := 0;
--		
--		variable komplett_gesendet : bit := '0';
--		
--	begin
--			if CLKX'event and CLKX = CLKX_Aktiv then -- Takt
--					if FSX = FSX_Aktiv then --Frame-Sync-Reset
--						Schnittstellennummer := 0;
--						Kanalnummer := 0;
--						Bitnummer := 0;
--						Phase := FrameAnfangAbwarten;
--						if FSX_Verzögerung=1 then
--							TempFiFo := Eingangspuffer(0).Kanaele(0);
--							Phase := ADAT_AudioDaten;
--						end if;
--					end if;
--				--else 
--					--if Phase = FrameAnfangAbwarten and FSX_Verzögerung = 1 then
--					--	Phase := ADAT_AudioDaten;
--					
--					--end if;
--					DX <= TempFiFo(0); --Bit rausschieben (egal ob gerade gesendet wird oder nicht, sollte dem DSP egal sein und Logik sparen)
--					TempFiFo := TempFiFo sll 1; --logical shift left
--					dbg_X_Bitnummer <= Bitnummer;
--					dbg_X_Kanalnummer <= Kanalnummer;
--					dbg_X_Schnittstellennummer <= Schnittstellennummer;
--					case Phase is
--						when FrameAnfangAbwarten =>
--							if FSX_VerzögerungsTimer = FSX_Verzögerung-2 then
--								Phase := ADAT_AudioDaten; --> Phasenwechsel -->
--								TempFiFo := Eingangspuffer(0).Kanaele(0);
--							else
--								FSX_VerzögerungsTimer := FSX_VerzögerungsTimer + 1;
--							end if;
--						when ADAT_Userbits =>
--							if Bitnummer = 3 then
--								if Schnittstellennummer = SCHNITTSTELLEN-1 then
--									Phase := WartenAufFrameSync; --> Phasenwechsel -->
--									komplett_gesendet := not komplett_gesendet;
--									Daten_komplett_gesendet <= komplett_gesendet;
--								else
--									Schnittstellennummer := Schnittstellennummer + 1;
--									Bitnummer := 0;
--									Kanalnummer := 0;
--									Phase := ADAT_AudioDaten; --> Phasenwechsel -->
--									TempFiFo := Eingangspuffer(Schnittstellennummer).Kanaele(Kanalnummer);
--								end if;
--							else
--								Bitnummer := Bitnummer + 1;
--							end if;
--						when ADAT_AudioDaten =>
--							if Bitnummer = 23 then --Daten für einen Kanal komplett?
--								if Kanalnummer = 7 then
--									Kanalnummer := 0;
--									Phase := ADAT_Userbits; --> Phasenwechsel -->
--									TempFiFo(0 to 3):=Eingangspuffer(Schnittstellennummer).Userbits;
--								else
--									Kanalnummer := Kanalnummer + 1;
--								end if;
--								TempFiFo := Eingangspuffer(Schnittstellennummer).Kanaele(Kanalnummer);
--								Bitnummer := 0;
--							else
--								Bitnummer := Bitnummer + 1;
--							end if;
--						when WartenAufFrameSync =>
--							--nichts tun
--						when others =>
--							Phase := WartenAufFrameSync;
--					end case;
--				end if;
			--end if;
		--end if;
--	end process;

end McBSP_Verhalten;

