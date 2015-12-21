--####################################
--# Autor: Simon Lohmann # 2013/2014 #
--####################################

--###################
--# ADAT_De_Enkoder #
--####################################################################
--# Vereint alle Module zum Gesamtprojekt						     #
--# Empfängt Daten über ADAT, sendet sie an den DSP, empfängt sie 	 #
--# wieder vom DSP und sendet sie per ADAT wieder raus.				 #
--####################################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ADAT.all;

Library UNISIM; --BUFGMUX
use UNISIM.vcomponents.all; --BUFGMUX

entity ADAT_De_Enkoder is
	generic( SCHNITTSTELLEN      : natural := 3;
				PUFFERLAENGE        : natural := 2--; -- Zweierpotenzen! (wegen Modulo)
				--ADAT_OSZILLATORTAKT : natural := 1288000 --in Hz, ganzzahlig
				); 
   port( -- Taktquellen
			in_Platinentakt : in std_logic;
			in_AdatTakt     : in std_logic;
			
			-- Taktkonfiguration
			in_ADAT_Taktwahl : in bit_vector(1 downto 0);

			-- ADAT-Schnittstellen
			in_ADAT      : in bit_vector(0 to SCHNITTSTELLEN-1);
			out_ADAT     : out bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0');
			
			-- LED-Anzeigen
			out_PufferUeberlauf : out bit := '0';
			out_PufferVoll 	  : out bit := '0';
			out_PufferNormal    : out bit := '0';
			out_PufferLeer      : out bit := '1';
			out_PufferUnterlauf : out bit := '0';
			out_FrameOK  : out bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0');
			out_EsLebt : out bit :='0';

			-- McBSP
			DSP_CLKX_FPGA_CLKR : IN   bit;
			DSP_FSX_FPGA_FSR : IN   bit;
			DSP_DX_FPGA_DR : IN   bit;
			DSP_CLKR_FPGA_CLKX : IN   bit;
			DSP_FSR_FPGA_FSX : out   bit;
			DSP_DR_FPGA_DX : OUT  bit := '0';
			--CLKS : IN   bit;

			 --Debug_SchnellerTakt : out std_logic
			 Debug_FrameSync : out std_logic;
			 Debug_AdatTakt :out std_logic
			);
			 
end ADAT_De_Enkoder;

architecture Verhalten of ADAT_De_Enkoder is
--komponenten
	component SchnellerTakt
	port(
		CLKin_in : in std_logic;          
		CLKFX_out : out std_logic;
		CLK0_out : out std_logic
		);
	end component;
	
	component ADAT_Taktgewinnung
	generic (AdatSchnittstellen : integer := 3);
	port  ( clk 			  : in std_logic;
			  -- Daten-Eingang
			  in_ADAT 		  : in bit;
			  -- Takt-Ausgang
			  out_ADAT_Clock : out std_logic;
			  Frame_Sync     : out std_logic
			  );
	end component;
	
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
		  out_NeueDaten  : out bit
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
	
	component McBSP_Interface
	generic ( SCHNITTSTELLEN : natural := SCHNITTSTELLEN;
				  -- [Pegeleinstellungen] --
				  -- Empfangen
				  FSR_Aktiv : bit := '1';
				  FSR_Inaktiv :bit := '0';
				  CLKR_Aktiv : bit := '0'; --Zustand nach der Flanke, an der die Daten gelesen werden sollen
				  CLKR_Inaktiv :bit := '1';
				  FSR_Verzögerung : natural range 1 to 2 := 1;
				  -- Senden
				  FSX_Aktiv : bit := '1';
				  FSX_Inaktiv :bit := '0';
				  CLKX_Aktiv : bit := '1'; --Zustand nach der Flanke, an der die Daten gesendet werden sollen (typischerweise ungleich CLKR-Aktiv)
				  CLKX_Inaktiv :bit := '0';
				  FSX_Verzögerung : natural range 1 to 2 := 1
				  );
    PORT(
			-- McBSP
         CLKR : IN   bit;
          FSR : IN   bit;
           DR : IN   bit;
         CLKX : IN   bit;
          FSX : out  bit;
           DX : OUT  bit;
       --CLKS : IN   std_logic;
			
			-- ADAT-Puffer
			Daten_komplett_empfangen : OUT bit;
			--Daten_komplett_gesendet  : OUT bit;
			Neue_Daten_Zum_Senden : in bit;
			
			-- Daten
			Daten_Eingang : in ADAT_Daten_Array(0 to SCHNITTSTELLEN-1); --McbSP<-Interface[Daten-Eingang]<-FPGA
			Daten_Ausgang : out ADAT_Daten_Array(0 to SCHNITTSTELLEN-1) --McBSP->Interface[Daten-Ausgang]->FPGA
			
			--Debug
--			dbg_R_Schnittstellennummer : out natural;
--			dbg_R_Kanalnummer : out natural;
--			dbg_R_Bitnummer : out natural;
--			dbg_X_Schnittstellennummer : out natural;
--			dbg_X_Kanalnummer : out natural;
--			dbg_X_Bitnummer : out natural
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

	--signale
	signal Schneller_Takt : std_logic;
	signal Schneller_Takt_schwach : std_logic;
	signal ADAT_Bit_Takt : std_logic;
	signal ADAT_Frame_Sync : std_Logic;	
	signal ADAT_Frame_Sync_bit : bit;
	signal ADAT_Frame_Sync_Erkennung : std_logic;
	signal ADAT_Frame_Sync_Enkoder : bit;
	
	signal Puffer_Enkoder_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal Puffer_Enkoder_DatenB: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal Enkoder_Puffer_DatenUebernommen: bit;
	
	signal ADATDekoder_McBSP_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal ADATDekoder_McBSP_NeueDaten: bit;
	
	--signal Puffer_McBSP_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	
	signal McBSP_Puffer_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal McBSP_Puffer_NeueDaten: bit;
	
	signal in_ADAT_fuer_Takt : bit;
	signal Taktgewinnung_BUFGMUX_ADAT_Bit_Takt : std_logic;
	signal Taktgewinnung_BUFGMUX_ADAT_Frame_Sync : std_Logic;
	signal Takt_InternOderExtern : std_logic;
	
	signal t_PufferUeberlauf : bit;
	signal t_PufferVoll 	    : bit;
	--signal t_PufferNormal    : bit;
	signal t_PufferLeer      : bit;
	signal t_PufferUnterlauf : bit;
begin
	inst_SchnellerTakt: SchnellerTakt
		port map(
			CLKin_in => in_Platinentakt ,
			CLKFX_out => Schneller_Takt_schwach,
			CLK0_out => open
		);
		
		
	BUFG_inst : BUFG
		port map (
			O => Schneller_Takt, -- Clock buffer output
			I => Schneller_Takt_schwach -- Clock buffer input
		);
		
	inst_ADAT_Taktgewinnung: ADAT_Taktgewinnung 
		generic map(AdatSchnittstellen => SCHNITTSTELLEN)
		port map(
			clk => Schneller_Takt,
			In_ADAT => in_ADAT_fuer_Takt,
			Out_ADAT_Clock => Taktgewinnung_BUFGMUX_ADAT_Bit_Takt,
			Frame_Sync => Taktgewinnung_BUFGMUX_ADAT_Frame_Sync
		);
		
	inst_ADAT_Dekoder: ADAT_Dekoder 
		generic map(AdatSchnittstellen => SCHNITTSTELLEN)
		port Map ( 
			ADAT_Takt => ADAT_Bit_Takt,
			ADAT_Sync => ADAT_Frame_Sync_bit,
			-- Daten-Eingang
			In_ADAT => in_ADAT,
			-- Daten-Ausgang
			out_Daten  => ADATDekoder_McBSP_Daten,
			out_FrameOK => out_FrameOK,
			out_NeueDaten  => ADATDekoder_McBSP_NeueDaten
			);
				
	inst_BRAM_Puffer_McBSP_Enkoder: DynamischerADATPuffer_BRAM
		generic map(PUFFERLAENGE => PUFFERLAENGE,
				   PUFFERBREITE => SCHNITTSTELLEN
				   )
		port MAP(
			clk => ADAT_Bit_Takt,--Schneller_Takt,
			Reset => '0',
			Eingang_NeueDatenAngekommen  => McBSP_Puffer_NeueDaten,
			Eingang  => McBSP_Puffer_Daten,
			PufferVoll  => t_PufferVoll ,
			PufferLeer  => t_PufferLeer ,
			PufferUeberlauf  => t_PufferUeberlauf ,
			PufferUnterlauf  => t_PufferUnterlauf ,
			Ausgang_NaechsterDatensatz  => Enkoder_Puffer_DatenUebernommen,
			Ausgang  => Puffer_Enkoder_Daten
			);
						
	inst_McBSP_Interface: McBSP_Interface
	generic map( SCHNITTSTELLEN => SCHNITTSTELLEN,
				  -- [Pegeleinstellungen] --
				  -- Empfangen
				  FSR_Aktiv 	=> '1',
				  FSR_Inaktiv 	=> '0',
				  CLKR_Aktiv   => '0', --Zustand nach der Flanke, an der die Daten gelesen werden sollen
				  CLKR_Inaktiv => '1',
				  FSR_Verzögerung => 1, -- 1 oder 2
				  -- Senden
				  FSX_Aktiv 	=> '1',
				  FSX_Inaktiv 	=> '0',
				  CLKX_Aktiv 	=> '1', --Zustand nach der Flanke, an der die Daten gesendet werden sollen (typischerweise ungleich CLKR-Aktiv)
				  CLKX_Inaktiv => '0',
				  FSX_Verzögerung => 1
				  )
    port map(
			-- McBSP
         CLKR => DSP_CLKX_FPGA_CLKR ,
          FSR => DSP_FSX_FPGA_FSR  ,
           DR => DSP_DX_FPGA_DR   ,
         CLKX => DSP_CLKR_FPGA_CLKX ,
          FSX => DSP_FSR_FPGA_FSX  ,
           DX => DSP_DR_FPGA_DX   ,
			-- FPGA -> DSP
			Neue_Daten_Zum_Senden => ADATDekoder_McBSP_NeueDaten,
			Daten_Eingang => ADATDekoder_McBSP_Daten, --McbSP<-Interface[Daten-Eingang]<-FPGA
			
			-- DSP -> FPGA
			Daten_Ausgang => McBSP_Puffer_Daten, --McBSP->Interface[Daten-Ausgang]->FPGA
			Daten_komplett_empfangen => McBSP_Puffer_NeueDaten
			--Debug
--			,
--			dbg_R_Schnittstellennummer : out natural;
--			dbg_R_Kanalnummer : out natural;
--			dbg_R_Bitnummer : out natural;
--			dbg_X_Schnittstellennummer : out natural;
--			dbg_X_Kanalnummer : out natural;
--			dbg_X_Bitnummer : out natural
        );

	
	inst_ADAT_Enkoder: ADAT_Enkoder
		generic map(AdatSchnittstellen => SCHNITTSTELLEN)
		port MAP(
			ADAT_Frame_Sync => ADAT_Frame_Sync_Enkoder,--ADAT_Frame_Sync_bit,
			ADAT_Bit_Clock => ADAT_Bit_Takt,
			Daten => Puffer_Enkoder_Daten,
			DatenUebernommen => Enkoder_Puffer_DatenUebernommen,
			out_ADAT => out_ADAT
		);
	
	Lebenszeichen: process (in_AdatTakt) --vom ADAT-Takt abgeleitet, da der LED-Pin in einem anderen Takt-Quadranten liegt als der 50MHz-Takteingang, was sonst zu Problemen bei Place&Route führt
	variable i : natural range 0 to 6144000;--ADAT_OSZILLATORTAKT/2:= 0;
	variable wert : bit := '0';
	begin
		if rising_edge(in_AdatTakt) then
			if i<6144000 then --ADAT_OSZILLATORTAKT/2 then --halbe Periodendauer des Taktes -> Ergibt 1Hz-Blinken
				i:=i+1; --kleiner durch gleichheits-test ersetzen
			else
				i:=0;
				wert := not wert;
				out_EsLebt<= not wert;
			end if;
		end if;
	end process;
	
	--ADAT-Takt-Multiplexer:
	
	--Dateneingang der Taktgewinnung multiplexen
	with in_ADAT_Taktwahl(1 downto 0) select
		in_ADAT_fuer_Takt <= in_ADAT(0) when "00",
									in_ADAT(1) when "01",
									in_ADAT(2) when "10",
									in_ADAT(2) when "11"; --egal, nur irgendwas
	
	Takt_InternOderExtern <= '1' when in_ADAT_Taktwahl(0)='1' and in_ADAT_Taktwahl(1)='1' --"11" Boardeigener Oszillator
							  else '0'; 
	-- BUFGMUX: Global Clock Buffer 2-to-1 MUX
	-- Spartan-3A
	-- Xilinx HDL Libraries Guide, version 14.5
	BUFGMUX_AdatTakt : BUFGMUX
	port map (
		O  => ADAT_Bit_Takt, -- Clock MUX output
		I0 => Taktgewinnung_BUFGMUX_ADAT_Bit_Takt, -- Clock0 input
		I1 => in_AdatTakt, -- Clock1 input
		S  => Takt_InternOderExtern -- Clock select input
	);
	-- End of BUFGMUX_inst instantiation
	
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
				ADAT_Frame_Sync_Erkennung <= '0';
				Periode := 0;
			else
				if Periode > 4 then
					ADAT_Frame_Sync_Erkennung <= '1';
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
	
	
	BUFGMUX_AdatFramesync : BUFGMUX
	port map (
		O  => ADAT_Frame_Sync, -- Clock MUX output
		I0 => Taktgewinnung_BUFGMUX_ADAT_Frame_Sync, -- Clock0 input
		I1 => ADAT_Frame_Sync_Erkennung, -- Clock1 input
		S  => Takt_InternOderExtern -- Clock select input
	);
	Adat_Frame_Sync_bit <= to_bit(Adat_Frame_Sync);
	
	out_PufferUeberlauf <= t_PufferUeberlauf;
	out_PufferVoll      <= t_PufferVoll;
	out_PufferNormal    <= not (t_PufferUeberlauf or t_PufferVoll or t_PufferLeer or t_PufferUnterlauf);
	out_PufferLeer      <= t_PufferLeer;
	out_PufferUnterlauf <= t_PufferUnterlauf;
end Verhalten;

