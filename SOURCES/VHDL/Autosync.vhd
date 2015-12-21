----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:34 10/26/2013 
-- Design Name: 
-- Module Name:    Autosync - Behavioral 
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

--	[Funktion]
-- Korrigiert die Verz�gerungszeiten von verschiedenen ADAT-Signalen so, dass diese
-- parallel eingelesen werden k�nnen. Alle Parameter f�r die Synchronisation werden 
-- dabei automatisch anhand von m�glichen Signalfehlern (Framesync) bestimmt.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ADAT.all;

entity AutoSynchronisierer is	
	generic (AdatSchnittstellen : integer := 3;  --Anzahl der Adat-Schnittstellen, von denen Daten entgegen genommen werden sollen
				FehlerBisZurFlankenumschaltung : natural := 127); -- Anzahl Fehler, nach denen die andere Flanke verwendet werden soll
				
	Port   (-- Takt-Eingang
			  in_ADAT_Takt	  : in std_logic;
			  -- Daten-Eing�nge
			  In_ADAT 		  : in bit_vector(0 to AdatSchnittstellen-1);
			  
			  -- Daten-Ausgang			  
			  Out_ADAT 	  	  : out bit_vector(0 to AdatSchnittstellen-1);
			  Out_Framesync  : out bit := '0';
			  --Out_WordClock  : out bit := '0';
			  --Out_Takt		  : out std_logic := '0';
			  
			  -- Debug
			  debug_ADAT_CHN_FSDelay_Messung   : out AdatBitDelay(0 to AdatSchnittstellen-1);     -- Verz�gerung der Schnittstelle (f�r ALLE, um geringste Latenz zu erzeugen)
			  debug_ADAT_CHN_FSDelay_Korrektur : out AdatBitDelay(0 to AdatSchnittstellen-1);	  -- Verz�gerung der Schnittstelle (f�r ALLE, um geringste Latenz zu erzeugen)
			  debug_ADAT_Framesync_CHN : out bit_vector(0 to AdatSchnittstellen-1);
			  debug_ADAT_Takt_CHN: out std_logic_vector(0 to AdatSchnittstellen-1);
			  debug_sLeitungsindex : out tLeitungsindex(0 to AdatSchnittstellen-1);
			  debug_ADAT_Langsam :  out ADATLangsam(0 to AdatSchnittstellen-1);
			  debug_ADAT_in_phasenkorrigiert : out bit_vector(0 to AdatSchnittstellen-1)
			  );
end AutoSynchronisierer;

architecture Verhalten of AutoSynchronisierer is
	COMPONENT Delayline_BRAM
		 Generic (
				  Addrbreite  : natural := 8;  -- Speicherl�nge = 2^Addrbreite
				  Wortbreite  : natural := 8
				  );
		 PORT(
				clk    : IN  std_logic;
				input  : IN  bit_vector(Wortbreite-1 downto 0);
				delay  : IN  natural range 0 to (2**Addrbreite)-1;
				output : OUT bit_vector(Wortbreite-1 downto 0)
			  );
	END COMPONENT;

	signal ADAT_Takt_CHN       : std_logic_vector(0 to AdatSchnittstellen-1);  -- Passender ADAT-Takt zur ADAT-Schnittstelle
	signal ADAT_Framesync_CHN  : bit_vector(0 to AdatSchnittstellen-1);			-- Passendes Frame-Sync-Signal zur ADAT-Schnittstelle
	signal ADAT_CHN_Flanke     : bit_vector(0 to AdatSchnittstellen-1);
	signal ADAT_in_phasenkorrigiert : bit_vector(0 to AdatSchnittstellen-1);
	signal sLeitungsindex : tLeitungsindex(0 to AdatSchnittstellen-1);
	
	signal ADAT_Langsam : ADATLangsam(0 to AdatSchnittstellen-1);
	--type AdatBitDelay is array (natural range <>) of natural range 0 to 255; --im Package ADAT enthalten
	signal ADAT_CHN_FSDelay_Messung   : AdatBitDelay(0 to AdatSchnittstellen-1);     -- Verz�gerung der Schnittstelle (f�r ALLE, um geringste Latenz zu erzeugen)
	signal ADAT_CHN_FSDelay_Korrektur : AdatBitDelay(0 to AdatSchnittstellen-1);     -- Verz�gerung der Schnittstelle (f�r ALLE, um geringste Latenz zu erzeugen)
	signal OUT_ADAT_Kopie : bit_vector(0 to AdatSchnittstellen-1);
begin
	
	EinmalProAdatSchnittstelle: for Schnittstelle in 0 to AdatSchnittstellen-1 generate
	
		-- Frame-Sync-Erkennung f�r die ADAT-Eing�nge
		--   Frame-Sync von Ein und Ausgang ist nicht zwingend Synchron, daher muss Framsync 
		--   aus dem ADAT-Signal regeneriert werden
		--EinfacheFrameSyncErkennung: process (Adat_Takt_CHN(0))--(Adat_Takt_CHN(Schnittstelle))
		EinfacheFrameSyncErkennung: process (in_Adat_Takt)
			variable Periode : natural range 0 to 12 := 0;
			variable in_Adat_alt : bit := '0';
		begin
			--if rising_edge(Adat_Takt_CHN(0)) then
			--if (ADAT_Takt_CHN(0)'event and ADAT_Takt_CHN(0) = '1') then
			if (in_ADAT_Takt'event and in_ADAT_Takt = '1') then
				--if in_Adat(Schnittstelle) = in_Adat_alt then
				if ADAT_in_phasenkorrigiert(Schnittstelle) = in_Adat_alt then
					Periode := Periode + 1;
				else
					if Periode<7 then --Bei Wechseln am Ende von Sync nicht zur�cksetzen
						Periode := 0; 
					end if;
					in_Adat_alt := ADAT_in_phasenkorrigiert(Schnittstelle);
				end if;
				if Periode=10 then --FrameSync_Ende
					ADAT_Framesync_CHN(Schnittstelle) <= '0';
					Periode := 0;
				else
					if Periode > 4 then
						ADAT_Framesync_CHN(Schnittstelle) <= '1';
					end if;
				end if;
			end if;
		end process;
		
		

		-- Da die Phase des Taktes an den ADAT-Ein- und Ausg�ngen nicht gleich ist (warum eigentlich??)
		-- wird hier die Flanke, an der das ADAT-Signal gesampelt wird automatisch ausgew�hlt.
		-- Vorraussetzung f�r das Funktionieren ist, dass bei einer der Flanken sinnvoll gesampelt werden kann
		-- Da der ADAT-Takt zwei Flanken pro Bit hat, muss eine davon immer im Zeitraum liegen, 
		-- in dem die Daten g�ltig sind. Im Worst-Case muss das Sampling also innerhalb eines Viertel
		-- Taktes erfolgen. 
		-- TODO/TOCHECK: Bisher scheint das zu funktionieren, es w�re aber besser, dass durch Constraints auch sicherzustellen
		AutomatischeFlankenUmschaltung: process (ADAT_Takt_CHN(Schnittstelle))
			--Konfigurierbar:
			constant FehlerBisZurUmschaltung :natural := FehlerBisZurFlankenumschaltung;
			----------------
			variable Periode : natural range 0 to 256 := 0;
			variable ADAT_Frame_Sync_alt : bit := '0';
			variable PeriodenFehler : natural range 0 to FehlerBisZurUmschaltung := 0;
			variable Flanke : bit := '1';
		begin
			--if rising_edge(ADAT_Takt_CHN(Schnittstelle)) then
			if (ADAT_Takt_CHN(Schnittstelle)'event and ADAT_Takt_CHN(Schnittstelle) = '1') then
				if (ADAT_Framesync_CHN(Schnittstelle) /= ADAT_Frame_Sync_alt)then
					ADAT_Frame_Sync_alt := ADAT_Framesync_CHN(Schnittstelle); --F�r die Flankenerkennung im Framesync-Signal
					if ADAT_Framesync_CHN(Schnittstelle) = '0' then --Fallende Flanke Framesync (=Frameanfang)
						if Periode /= 255 then --man k�nnte auch noch einmal hochz�hlen und auf 256 vergleichen, das macht aber wenig Sinn
						-- d.h. Periode zu lang
							PeriodenFehler := PeriodenFehler + 1;
							if PeriodenFehler = FehlerBisZurUmschaltung then --Zu viele Fehler:
								Flanke := not Flanke; --schalte Flanke um
								PeriodenFehler := 0;  --Fehlerz�hler zur�cksetzen
							end if;
						end if;
						Periode := 1; --dieser Takt z�hlt schon
					end if;
				else
					Periode := Periode + 1 ;
				end if;
				Adat_CHN_Flanke(Schnittstelle) <= Flanke;
			end if;
		end process;
		
		ADAT_Takt_CHN(Schnittstelle) <= in_ADAT_Takt when Adat_CHN_Flanke(Schnittstelle) = '1' 
														else (not in_ADAT_Takt);
														
												
		-- Verz�gerung der Framesync-Pulse gegen�ber "Kanal" 0
		--Verzoegerungserkennung: process (Adat_Takt_CHN(0))--(Adat_Takt_CHN(Schnittstelle))
		Verzoegerungserkennung: process (in_Adat_Takt)--(Adat_Takt_CHN(Schnittstelle))
			variable ADAT_Frame_Sync_alt : bit := '0';
			variable ADAT_Frame_Sync_0_alt : bit := '0';
			variable Delay : natural range 0 to 255 := 0;
		begin
			--if rising_edge(ADAT_Takt_CHN(Schnittstelle)) then
			--if (ADAT_Takt_CHN(0)'event and ADAT_Takt_CHN(0) = '1') then
			if (in_ADAT_Takt'event and in_ADAT_Takt = '1') then
				if Schnittstelle = 0 then
					ADAT_CHN_FSDelay_Messung(Schnittstelle) <= 0; -- Kanal Null ist gegen�ber sich selbst nicht verschoben	
				else
					-- FrameSync ADAT-Schnittstelle "0" - Referenzpunkt f�r die Messung
					if (ADAT_Framesync_CHN(0) /= ADAT_Frame_Sync_0_alt) then   -- �nderung an Framesync
						if ADAT_Framesync_CHN(0) = '0' then 	--Fallende Flanke an Framesync (=Frameanfang)
							Delay := 0; --Ab hier wird gemessen
						end if;
						ADAT_Frame_sync_0_alt := ADAT_Framesync_CHN(0); --Aktuellen Wert f�r Vergleich merken
					end if;
					
					-- Zu vergleichender ADAT-Kanal
					if (ADAT_Framesync_CHN(Schnittstelle) /= ADAT_Frame_Sync_alt)then
						ADAT_Frame_Sync_alt := ADAT_Framesync_CHN(Schnittstelle); --F�r die Flankenerkennung im Framesync-Signal
						if ADAT_Framesync_CHN(Schnittstelle) = '0' then --Fallende Flanke Framesync (=Frameanfang)
							ADAT_CHN_FSDelay_Messung(Schnittstelle) <= Delay;
							--Delay:= 0; <-- Erledigt der FrameSync von Schnittstelle "0" (siehe oben)
						end if;
					end if;
					Delay := Delay + 1;
				end if; --schnittstelle=0?
			end if; --rising edge?
		end process;
		
		-- [Prinzip Flankenkorrektur]
		-- Das Eingangssignal wird zun�chst auf zwei halb so schnelle Leitungen verteilt,
		-- wodurch eine Abtastung mit beiden Flanken des Taktes m�glich wird - die langsamen
		-- Leitungen werden mit dem Zieltakt neu abgetastet und wieder zu einer schnellen
		-- Leitung zusammengefasst.
		FlankenkorrekturVerlangsamen: process (ADAT_Takt_CHN(Schnittstelle))
			variable Leitungsindex: natural range 0 to 1 := 0;
		begin
			--if rising_edge(ADAT_Takt_CHN(Schnittstelle)) then
			if (ADAT_Takt_CHN(Schnittstelle)'event and ADAT_Takt_CHN(Schnittstelle) = '1') then
				ADAT_Langsam(Schnittstelle)(Leitungsindex) <= in_ADAT(Schnittstelle);
				if Leitungsindex = 0 then -- Zwischen den beiden Langsamen Leitungen wechseln
					Leitungsindex := 1;
				else
					Leitungsindex := 0;
				end if;
				sLeitungsindex(Schnittstelle) <= Leitungsindex;
			end if;
		end process;
		
		FlankenkorrekturNeuTakten: process (in_ADAT_Takt)--(ADAT_Takt_CHN(0))
			variable Leitungsindex: natural range 0 to 1 := 0;
		begin
			--if rising_edge(ADAT_Takt_CHN(0)) then
			--if (ADAT_Takt_CHN(0)'event and ADAT_Takt_CHN(0) = '1') then
			if (in_ADAT_Takt'event and in_ADAT_Takt = '1') then
				ADAT_in_phasenkorrigiert(Schnittstelle) <= ADAT_Langsam(Schnittstelle)(Leitungsindex);
				if Leitungsindex = 0 then -- Zwischen den beiden Langsamen Leitungen wechseln
					Leitungsindex := 1;
				else
					Leitungsindex := 0;
				end if;
			end if;
		end process;
		
--		-- F�hrt die Verz�gerungskorrektur (in ganzen Takten) durch
--		Verzoegerungskorrektur: process (ADAT_Takt_CHN(0)) --# Geht, verbraucht aber zu viele Slices#
--			variable delayline : bit_vector(0 to 255) := (others =>'0');
--		begin
--			--if rising_edge(ADAT_Takt_CHN(0)) then
--			if (ADAT_Takt_CHN(0)'event and ADAT_Takt_CHN(0)='1') then
--				delayline := ADAT_in_phasenkorrigiert(Schnittstelle) & delayline(0 to 254);
--				Out_ADAT(Schnittstelle) <= delayline(ADAT_CHN_FSDelay_Korrektur(Schnittstelle));
--			end if;
--		end process;
      -- Instanz eines BRAM+Adresslogik, um Slices zu sparen:
		Verz�gerungskorrektur: Delayline_BRAM 
			Generic Map ( Addrbreite => 8, -- 2^8 = 256 Bits = 1 Frame
							  Wortbreite => 1) -- 1 BRAM pro Schnittstelle (wegen verschiedener Verz�gerungen)
			PORT MAP (
				 clk => in_ADAT_Takt,--ADAT_Takt_CHN(0),
				 input(0) => ADAT_in_phasenkorrigiert(Schnittstelle),
				 delay => ADAT_CHN_FSDelay_Korrektur(Schnittstelle),
				 output(0) => OUT_ADAT_Kopie(Schnittstelle)
			);

		OUT_ADAT(Schnittstelle) <= OUT_ADAT_Kopie(Schnittstelle);
		
	
	end generate;
	
	-- [Prinzip Verz�gerungskorrekturberechnung]
	-- Um alle Frame-Anf�nge m�glichst nahe zusammen zu bringen, wird zun�chst bestimmt, in welcher Richtung
	-- der Abstand zu Schnittstelle 0 (Referenz) mit der geringsten Verschiebung verbunden ist. Dabei werden
	-- zun�chst auch negative zeitliche Verschiebungen zugelassen.
	--   Hintergrund: Ob das Signal so weit verschoben wird, dass der Frameanfang von zwei Signalen zusammenf�llt,
	--                oder ob der Frameanfang der ersten und der Anfang des n�chsten Frames der zweiten
	--					 	Schnittstelle zusammenfallen, ist irrelevant, da aufgrund der unterschiedlichen Verz�gerungen
	--						die einzelnen Frames (bzw. Audiosamples) eh nicht als gleichzeitig angesehen werden k�nnen.
	-- Da negative zeitliche Verschiebung real nicht m�glich ist (Kausalit�t), wird das negative "Maximum"
	-- aller berechneten Verz�gerungskorrekturen bestimmt. Dann wird dieses negative "Maximum" von allen
	-- Korrekturwerten subtrahiert, womit diese alle Positiv werden.
	--KorrekturBerechnen: process (ADAT_Takt_CHN(0))
	KorrekturBerechnen: process (in_ADAT_Takt)
		type tmp_BitDelay is array (natural range <>) of integer range -255 to 255;
		variable temp_Korrektur: tmp_BitDelay(0 to AdatSchnittstellen-1);
		variable temp_negative_max: integer range -255 to 0;
	begin
		--if rising_edge(ADAT_Takt_CHN(0)) then
		--if (ADAT_Takt_CHN(0)'event and ADAT_Takt_CHN(0) = '1') then
		if (in_ADAT_Takt'event and in_ADAT_Takt = '1') then
			temp_negative_max := 0;
			for i in 0 to AdatSchnittstellen-1 loop
				if ADAT_CHN_FSDelay_Messung(i) < 128 then  -- Wenn Links n�her
					temp_Korrektur(i) := -ADAT_CHN_FSDelay_Messung(i); --nach Links schieben
					if temp_Korrektur(i) < temp_negative_max then -- "Negatives Maximum" finden
						temp_negative_max := temp_Korrektur(i);
					end if;
				else -- rechts n�her
					temp_Korrektur(i) := 256 - ADAT_CHN_FSDelay_Messung(i); --nach Rechts schieben
				end if;
			end loop;
			-- Negative Werte beseitigen (Kausalit�t)
			for i in 0 to AdatSchnittstellen-1 loop
				ADAT_CHN_FSDelay_Korrektur(i) <= temp_Korrektur(i) - temp_negative_max; -- Minus Negativ => Plus
			end loop;
		end if;
	end process;
	
	-- Korrigiert die Verz�gerung des Framsync-Signals von Schnittstelle 0
--	VerzoegerungskorrekturFrameSync: process (ADAT_Takt_CHN(0)) --# Geht, verbraucht aber viele Slices#
--		variable delayline : bit_vector(0 to 255) := (others =>'0');
--	begin
--		--if rising_edge(ADAT_Takt_CHN(0)) then
--		if (ADAT_Takt_CHN(0)'event and ADAT_Takt_CHN(0)='1') then
--			delayline := ADAT_Framesync_CHN(0) & delayline(0 to 254);
--			OUT_Framesync  <= delayline(ADAT_CHN_FSDelay_Korrektur(0));
--		end if;
--	end process; 

	--KorrigierterFrameSync: process (ADAT_Takt_CHN(0))
	KorrigierterFrameSync: process (in_ADAT_Takt)
		variable Periode : natural range 0 to 12 := 0;
		variable Adat_alt : bit := '0';
	begin
		--if rising_edge(Adat_Takt_CHN(0)) then
		--if (ADAT_Takt_CHN(0)'event and ADAT_Takt_CHN(0) = '1') then
		if (in_ADAT_Takt'event and in_ADAT_Takt = '1') then
			--if in_Adat(Schnittstelle) = in_Adat_alt then
			if OUT_ADAT_Kopie(0) = Adat_alt then
				Periode := Periode + 1;
			else
				if Periode<7 then --Bei Wechseln am Ende von Sync nicht zur�cksetzen
					Periode := 0; 
				end if;
				Adat_alt := OUT_ADAT_Kopie(0);
			end if;
			if Periode=10 then --FrameSync_Ende
				OUT_Framesync <= '0';
				Periode := 0;
			else
				if Periode > 4 then
					OUT_Framesync <= '1';
				end if;
			end if;
		end if;
	end process;

	
	--OUT_Takt <= in_ADAT_Takt;--ADAT_Takt_CHN(0); -- Alles wird an Kanal 0 angepasst

	debug_ADAT_CHN_FSDelay_Korrektur <= ADAT_CHN_FSDelay_Korrektur;
	debug_ADAT_CHN_FSDelay_Messung <= ADAT_CHN_FSDelay_Messung;
	debug_ADAT_Framesync_CHN <= ADAT_Framesync_CHN;
	debug_ADAT_Takt_CHN <= ADAT_Takt_CHN;
	debug_sLeitungsindex <= sLeitungsindex;
   debug_ADAT_Langsam <= ADAT_Langsam;
   debug_ADAT_in_phasenkorrigiert <= ADAT_in_phasenkorrigiert;
end Verhalten;

