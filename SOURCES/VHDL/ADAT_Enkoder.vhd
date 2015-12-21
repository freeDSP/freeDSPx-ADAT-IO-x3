----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:21:33 11/05/2013 
-- Design Name: 
-- Module Name:    ADAT_Enkoder - Behavioral 
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


entity ADAT_Enkoder is
	generic( AdatSchnittstellen : integer := 3);--Anzahl der Adat-Schnittstellen, von denen Daten entgegen genommen werden sollen
   Port(	ADAT_Frame_Sync: in bit;
			ADAT_Bit_Clock: in std_logic;
			Daten: in ADAT_Daten_Array(0 to AdatSchnittstellen-1);
			DatenUebernommen : out bit; --Ändert sich, wenn die Daten übernommen wurden
			Out_ADAT : out bit_vector(0 to AdatSchnittstellen-1) := (others => '0');
			--Out_Wordclock : out bit;
			--Debug
			dbg_Bitnummer : out natural range 0 to 255
			);
end ADAT_Enkoder;

architecture Behavioral of ADAT_Enkoder is
	--komponenten

	--signale etc.
	--signal ADAT_Frame : ADAT_Frame_Array(0 to AdatSchnittstellen-1);
														--:=(0 | 5   | 10  | 15  | 20  | 25  | 30  | 35  | 40  | 45  | 50   -- Passende Initialisierung erlaubt
															--	 | 55  | 60  | 65  | 70  | 75  | 80  | 85  | 90  | 95  | 100  -- eine bessere Optimierung bei der
															--	 | 105 | 110 | 115 | 120 | 125 | 130 | 135 | 140 | 145 | 150  -- Synthese ("This FF/Latch will be 
															--	 | 155 | 160 | 165 | 170 | 175 | 180 | 185 | 190 | 195 | 200  -- trimmed during the optimization 
															--	 | 205 | 210 | 215 | 220 | 225 | 230 | 235 | 240 | 245 => '1' -- process") 
															--	 , others => '0');														  -- => Bitstuffing & Sync sind Konstanten!
begin
	ADAT_Senden: process (ADAT_Bit_Clock, ADAT_Frame_Sync)
		variable intern_ADAT : bit_vector(0 to AdatSchnittstellen-1) := (others => '0');
		variable BitNummer : natural range 0 to 255 := 0;
		variable BitNummer_Reset : bit := '0';
		variable BitNummer_Reset_alt : bit := '0';
		variable Uebernommen : bit := '0';
		
		--variable WordClock : bit := '0';
		
		variable LokaleBitNummer : natural range 0 to 23 := 0;
		variable Kanalnummer : natural range 0 to 7 := 0;
		
		type EnkoderPhase is (ADAT_Userbits, ADAT_AudioDaten, ADAT_Sync);
		variable Phase : EnkoderPhase := ADAT_AudioDaten;
	begin
		-- Frame-Sync --
		if ADAT_Frame_Sync'event and ADAT_Frame_Sync='0' then --fallende Flanke
			BitNummer_Reset:= not BitNummer_Reset;
		end if;
		
		-- Senden --
		if rising_edge(ADAT_Bit_Clock) then
			if Bitnummer_Reset /= Bitnummer_Reset_alt then
				Bitnummer := 0;
				Kanalnummer := 0;
				LokaleBitNUmmer := 0;
				Phase := ADAT_Userbits;
				Bitnummer_Reset_alt := Bitnummer_Reset;
				--WordClock := not WordClock;
			end if;
			dbg_Bitnummer <= Bitnummer;
				case Phase is
					when ADAT_Userbits =>
						if (Bitnummer = 0) then --or (Bitnummer = 5) then -- jedes 5. Bit eine "1" einschieben (rem und mod gehen nur bei 2er-Potenzen)
							for Schnittstelle in 0 to AdatSchnittstellen-1 loop 
								Intern_ADAT(Schnittstelle) := not Intern_ADAT(Schnittstelle); --"1"
							end loop;
						else
							for Schnittstelle in 0 to AdatSchnittstellen-1 loop 
								if Daten(Schnittstelle).Userbits(3-LokaleBitNummer)='1' then --NRZI 1:Wechsel 0:kein Wechsel
									Intern_ADAT(Schnittstelle) := not Intern_ADAT(Schnittstelle);
								end if;
							end loop;
							LokaleBitNummer := LokaleBitNummer + 1;
						end if;
						Bitnummer := Bitnummer + 1;
						if Bitnummer = 5 then 
							Phase := ADAT_AudioDaten;
							LokaleBitNummer := 0;
							Kanalnummer := 0;
						end if;
						
					when ADAT_AudioDaten =>
						if (Bitnummer = 5)or(Bitnummer =  10)or(Bitnummer =  15)or(Bitnummer =  20)or(Bitnummer =  25)or(Bitnummer =  30)or(Bitnummer =  35)or(Bitnummer =  40)or(Bitnummer =  45)or 
							(Bitnummer =  50)or(Bitnummer =  55)or(Bitnummer =  60)or(Bitnummer =  65)or(Bitnummer =  70)or(Bitnummer =  75)or(Bitnummer =  80)or(Bitnummer =  85)or 
							(Bitnummer =  90)or(Bitnummer =  95)or(Bitnummer = 100)or(Bitnummer = 105)or(Bitnummer = 110)or(Bitnummer = 115)or(Bitnummer = 120)or(Bitnummer = 125)or 
							(Bitnummer = 130)or(Bitnummer = 135)or(Bitnummer = 140)or(Bitnummer = 145)or(Bitnummer = 150)or(Bitnummer = 155)or(Bitnummer = 160)or(Bitnummer = 165)or 
							(Bitnummer = 170)or(Bitnummer = 175)or(Bitnummer = 180)or(Bitnummer = 185)or(Bitnummer = 190)or(Bitnummer = 195)or(Bitnummer = 200)or(Bitnummer = 205)or
							(Bitnummer = 210)or(Bitnummer = 215)or(Bitnummer = 220)or(Bitnummer = 225)or(Bitnummer = 230)or(Bitnummer = 235)or(Bitnummer = 240)or(Bitnummer = 245)
						then -- jedes 5. Bit eine "1" einschieben, mod geht nicht mit "5"
							for Schnittstelle in 0 to AdatSchnittstellen-1 loop 
								Intern_ADAT(Schnittstelle) := not Intern_ADAT(Schnittstelle); --"1"
							end loop;
						else
							for Schnittstelle in 0 to AdatSchnittstellen-1 loop 
								if Daten(Schnittstelle).Kanaele(Kanalnummer)(23-LokaleBitNummer)='1' then --NRZI 1:Wechsel 0:kein Wechsel
									Intern_ADAT(Schnittstelle) := not Intern_ADAT(Schnittstelle);
								end if;
							end loop;
							if LokaleBitNummer = 23 then
								if Kanalnummer = 7 then
									Kanalnummer := 0;
								else
									Kanalnummer := Kanalnummer+1;
								end if;
								LokaleBitNummer := 0;
							else
								LokaleBitNummer := LokaleBitNummer +1;
							end if;
						end if;
						Bitnummer := Bitnummer + 1;
						if Bitnummer = 246 then --Bitstuffing noch von hier
							Phase := ADAT_Sync;
							Uebernommen := not Uebernommen;
							DatenUebernommen <= Uebernommen;
						end if;
						
					when ADAT_Sync =>
						--10x nichts tun! -> "0"
						if Bitnummer = 255 then
							Bitnummer := 0;
							Kanalnummer := 0;
							LokaleBitNUmmer := 0;
							Phase := ADAT_Userbits;
						else
							Bitnummer := Bitnummer + 1;
						end if;
						
				end case;
			end if;
		Out_ADAT <= Intern_ADAT;
	end process;
--ADAT_Senden: process (ADAT_Bit_Clock, ADAT_Frame_Sync)
--		variable intern_ADAT : bit_vector(0 to AdatSchnittstellen-1) := (others => '0');
--		variable BitNummer : natural range 0 to 255 := 0;
--		variable BitNummer_Reset : bit := '0';
--		variable BitNummer_Reset_alt : bit := '0';
--		variable Uebernommen : bit := '0';
--		
--		variable ADAT_Frame : ADAT_Frame_Array(0 to AdatSchnittstellen-1);
--	begin
--		-- Frame-Sync --
--		if ADAT_Frame_Sync'event and ADAT_Frame_Sync='0' then --fallende Flanke
--			BitNummer_Reset:= not BitNummer_Reset;
--		end if;
--		
--		-- Senden --
--		if falling_edge(ADAT_Bit_Clock) then --fallende Flanke (TODO: klären, ob fallend oder steigend sinnvoller)
--			for kanal in 0 to AdatSchnittstellen-1 loop 
--			--#Array-Zugriff:#
--				if ADAT_Frame(kanal)(BitNummer)='1' then --NRZI 1:Wechsel 0:kein Wechsel
--					Intern_ADAT(kanal) := not Intern_ADAT(kanal);
--				end if;
--			--#Shiftregister-Zugriff:# -> Spart leider nichts, sondern braucht mehr Slices
----				if ADAT_Frame(kanal)(0)='1' then --NRZI 1:Wechsel 0:kein Wechsel
----					Intern_ADAT(kanal) := not Intern_ADAT(kanal);
----				end if;
----				ADAT_Frame(kanal) := ADAT_Frame(kanal) rol 1;
--			end loop;
--			--zum Schluss Bitnummer erhöhen
--			BitNummer := (BitNummer + 1) mod 256;
--			if BitNummer_Reset/=BitNummer_Reset_alt then
--				BitNummer := 0;
--				BitNummer_Reset_alt := BitNummer_Reset;
--			end if;
--			
--			if BitNummer = 0 then
--				--Frames übernehmen
--				for kanal in 0 to AdatSchnittstellen-1 loop 
--					ADAT_Frame(kanal)	:=	
--								'1' & Daten(kanal).UserBits(3 downto 0)
--								
--							 & '1' & Daten(kanal).Kanaele(0)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(0)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(0)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(0)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(0)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(0)( 3 downto  0)
--							 
--							 & '1' & Daten(kanal).Kanaele(1)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(1)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(1)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(1)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(1)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(1)( 3 downto  0)
--							 
--							 & '1' & Daten(kanal).Kanaele(2)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(2)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(2)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(2)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(2)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(2)( 3 downto  0)
--							 
--							 & '1' & Daten(kanal).Kanaele(3)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(3)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(3)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(3)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(3)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(3)( 3 downto  0)
--							 
--							 & '1' & Daten(kanal).Kanaele(4)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(4)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(4)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(4)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(4)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(4)( 3 downto  0)
--							 
--							 & '1' & Daten(kanal).Kanaele(5)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(5)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(5)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(5)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(5)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(5)( 3 downto  0)
--							 
--							 & '1' & Daten(kanal).Kanaele(6)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(6)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(6)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(6)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(6)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(6)( 3 downto  0)
--							 
--							 & '1' & Daten(kanal).Kanaele(7)(23 downto 20)
--							 & '1' & Daten(kanal).Kanaele(7)(19 downto 16)
--							 & '1' & Daten(kanal).Kanaele(7)(15 downto 12)
--							 & '1' & Daten(kanal).Kanaele(7)(11 downto  8)
--							 & '1' & Daten(kanal).Kanaele(7)( 7 downto  4)
--							 & '1' & Daten(kanal).Kanaele(7)( 3 downto  0)
--							 
--							 & "10000000000";
--				end loop;
--				Uebernommen := not Uebernommen;
--				DatenUebernommen <= Uebernommen;
--			end if;
--		end if;
--		Out_ADAT <= Intern_ADAT;
--	end process;
end Behavioral;

