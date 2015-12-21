--####################################
--# Autor: Simon Lohmann # 2013/2014 #
--####################################

--######################
--# Test_ADAT_Loopback #
--####################################################################
--# Empfängt die an den Eingängen anliegenden ADAT-Signale,          #
--# speichert sie in einem Puffer und gibt sie anschließend          #
--# wieder aus.                                                      #
--#                                                                  #
--# Taktquelle ist hier der 12,288 MHz-Oszillator auf der Platine    #
--# (Taktgewinnung auskommentiert, aber auch möglich)                #
--#                                                                  #
--# Framesync wird aus dem Eingangssignal von ADAT-Schnittstelle 0   #
--# hergeleitet, je nach Interface ist Wordclock zwichen den         #
--# ADAT-Interfaces also nötig!                                      #
--####################################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ADAT.all;

entity Test_ADAT_Loopback is
	generic( SCHNITTSTELLEN : natural := 3;  --Anzahl der ADAT-Schnittstellen
			 PUFFERLAENGE   : natural := 2); --Pufferlänge, nur Zweierpotenzen erlaubt! (wegen Modulo)
    port(    In_Platinentakt : in std_logic;
			 In_AdatTakt : in std_logic;		
	 
			 In_ADAT      : in bit_vector(0 to SCHNITTSTELLEN-1); --ADAT-Eingangssignale
			 
			 -- LED-Anzeigen:
			 out_PufferVoll : out bit := '0';
			 out_PufferLeer : out bit := '1';
			 out_PufferUeberlauf : out bit := '0';
			 out_PufferUnterlauf : out bit := '0';
			 out_FrameOK  : out bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0');
			 out_EsLebt : out bit :='0';
			 
			 out_ADAT     : out bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0'); --ADAT-Ausgangssignale
			 
			 --Debug-Signale
			 Debug_FrameSync : out bit;
			 Debug_AdatTakt :out std_logic;
			 Debug_Bitstuffing: out bit_vector(0 to 7)
			 --Debug_SchnellerTakt : out std_logic
			 );
end Test_ADAT_Loopback;

architecture Behavioral of Test_ADAT_Loopback is
--komponenten
--	component SchnellerTakt
--	port(
--		CLKin_in : in std_logic;          
--		CLKFX_out : out std_logic;
--		CLK0_out : out std_logic
--		);
--	end component;
--	
	--component ADAT_Taktgewinnung
	--generic (AdatSchnittstellen : integer := 3);
	--port  ( clk 			  : in std_logic;
	--		  -- Daten-Eingang
	--		  in_ADAT 		  : in bit;
	--		  -- Takt-Ausgang
	--		  out_ADAT_Clock : out std_logic;
	--		  Frame_Sync     : out std_logic
	--		  );
	--end component;
	
	component ADAT_Dekoder
	generic (AdatSchnittstellen : integer := 3);
	port(ADAT_Takt 	  : in std_logic;
		  ADAT_Sync		  : in bit;
		  -- Daten-Eingang
		  in_ADAT 		  : in bit_vector(0 to SCHNITTSTELLEN-1);
		  
		  -- Daten-Ausgang
		  out_Daten 	  : out ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
		  out_FrameOK    : out bit_vector(0 to SCHNITTSTELLEN-1);
		  
		  -- Takt-Ausgang
		  out_NeueDaten  : out bit;
		  Debug_Bitstuffing : out bit_vector(0 to 7)
		  );
	end component;
	
	component ADAT_Enkoder
	generic( AdatSchnittstellen : integer := 3);
	port ( ADAT_Frame_Sync: in bit;
			 ADAT_Bit_Clock: in std_logic;
          Daten : in ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
			 DatenUebernommen : out bit;
			 out_ADAT : out bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0')
			 );
	end component;
	
	component DynamischerADATPuffer_BRAM
	generic(PUFFERLAENGE : integer := 2; --Wie viele Elemente soll der Puffer maximal aufnehmen können?
			  PUFFERBREITE : integer := SCHNITTSTELLEN --Wie viele ADAT-Schnittstellen?
			); 
   port(
			Reset : in bit;
			clk : in std_logic;
         Eingang_NeueDatenAngekommen : in  bit;
         Eingang : in ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
         PufferVoll : out  bit;
         PufferLeer : out  bit;
         PufferUeberlauf : out  bit;
         PufferUnterlauf : out  bit;
         Ausgang_NaechsterDatensatz : in  bit;
         Ausgang : out ADAT_Daten_Array(0 to SCHNITTSTELLEN-1)
        );
    end component;
	

	--signale
	signal Schneller_Takt : std_logic;
	signal ADAT_Bit_Takt : std_logic;
	signal ADAT_Frame_Sync : bit;	
	
	signal Puffer_Enkoder_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal Enkoder_Puffer_DatenUebernommen: bit;
	
	signal Puffer_Dekoder_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal Puffer_Dekoder_NeueDaten: bit;
	
	signal Adat_Frame_Sync_Enkoder: bit;
begin
	--inst_SchnellerTakt: SchnellerTakt
--		port map(
--			CLKin_in => Platinentakt ,
--			CLKFX_out => Schneller_Takt,
--			CLK0_out => open
--		);
		
	--inst_ADAT_Taktgewinnung: ADAT_Taktgewinnung 
	--	generic map(AdatSchnittstellen => SCHNITTSTELLEN)
	--	port map(
	--		clk => Schneller_Takt,
	--		In_ADAT => In_ADAT(0), --TODO: Multiplexer zur Taktquellenauswahl
	--		Out_ADAT_Clock => ADAT_Bit_Takt,
	--		to_bit(Frame_Sync) => ADAT_Frame_Sync
	--	);
		
	inst_ADAT_Dekoder: ADAT_Dekoder 
		generic map(AdatSchnittstellen => SCHNITTSTELLEN)
		port Map ( 
			ADAT_Takt => in_AdatTakt,--ADAT_Bit_Takt,
			ADAT_Sync => ADAT_Frame_Sync,
			-- Daten-Eingang
			In_ADAT => in_ADAT,
			-- Daten-Ausgang
			out_Daten  => Puffer_Dekoder_Daten,
			out_FrameOK => out_FrameOK,
			-- Takt-Ausgang
			out_NeueDaten  => Puffer_Dekoder_NeueDaten,
			Debug_Bitstuffing => Debug_Bitstuffing
			);
	
	inst_ADAT_Enkoder: ADAT_Enkoder
		generic map(AdatSchnittstellen => SCHNITTSTELLEN)
		port MAP(
			ADAT_Frame_Sync => ADAT_Frame_Sync_Enkoder,
			ADAT_Bit_Clock => in_AdatTakt,--ADAT_Bit_Takt,
			Daten => Puffer_Enkoder_Daten,
			DatenUebernommen => Enkoder_Puffer_DatenUebernommen,
			out_ADAT => out_ADAT
		);
	
	inst_DynamischerADATPufferBRAM: DynamischerADATPuffer_BRAM
		generic map(PUFFERLAENGE => PUFFERLAENGE,
				   PUFFERBREITE => SCHNITTSTELLEN
				   )
		port MAP(
			clk => in_AdatTakt,---Schneller_Takt,
			Reset => '0',
			Eingang_NeueDatenAngekommen  => Puffer_Dekoder_NeueDaten,
			Eingang  => Puffer_Dekoder_Daten,
			PufferVoll  => out_PufferVoll ,
			PufferLeer  => out_PufferLeer ,
			PufferUeberlauf  => out_PufferUeberlauf ,
			PufferUnterlauf  => out_PufferUnterlauf ,
			Ausgang_NaechsterDatensatz  => Enkoder_Puffer_DatenUebernommen,
			Ausgang  => Puffer_Enkoder_Daten
			);
			
	FrameSync: process (in_AdatTakt)
		variable Bitnummer : natural range 0 to 255:= 0;
	begin
		if rising_edge(in_AdatTakt) then
			if Bitnummer = 255 then
				Bitnummer := 0;
				ADAT_Frame_Sync_Enkoder <= '1';
			else
				Bitnummer := Bitnummer + 1;
				ADAT_Frame_Sync_Enkoder <= '0';
			end if;
		end if;
	end process;

	EinfacheFrameSyncErkennung: process (in_AdatTakt)
		variable Periode : natural range 0 to 12 := 0;
		variable in_Adat_alt : bit := '0';
	begin
		if falling_edge(in_AdatTakt) then
			if in_Adat(0) = in_Adat_alt then
				Periode := Periode + 1;
			else
				if Periode<7 then --Bei Wechseln am Ende von Sync nicht zurücksetzen
					Periode := 0; 
				end if;
				in_Adat_alt := in_Adat(0);
			end if;
			if Periode=10 then --FrameSync_Ende
				ADAT_Frame_Sync <= '0';
				Periode := 0;
			else
				if Periode > 4 then
					ADAT_Frame_Sync <= '1';
				end if;
			end if;
--			ADAT_Frame_Sync_Enkoder <= '0';
--			if Periode = 12 then
--				ADAT_Frame_Sync_Enkoder <= '1'; --MAP muss veräppelt werden, sollte hoffentlich nie Auftreten
--			end if;
		end if;
	end process;
	Debug_FrameSync <= ADAT_Frame_Sync;
	Debug_AdatTakt <= in_AdatTakt;
	
	--Debug_SchnellerTakt <= Schneller_Takt; --Debug
	Lebenszeichen: process (in_Platinentakt)
		variable i : integer := 0;
		variable wert : bit := '0';
	begin
		if rising_edge(in_Platinentakt) then
			if i<25000000 then
				i:=i+1;
			else
				i:=0;
				wert := not wert;
				out_EsLebt<= not wert;
			end if;
		end if;
	end process;
		
end Behavioral;

