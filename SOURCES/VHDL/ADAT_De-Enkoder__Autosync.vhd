
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ADAT.all;

Library UNISIM; --BUFGMUX
use UNISIM.vcomponents.all; --BUFGMUX

entity Autosync is
	generic( SCHNITTSTELLEN      : natural := 3;
				PUFFERLAENGE        : natural := 8; -- Zweierpotenzen! (wegen Modulo)
				FSR_OUTPUT	  		  : boolean := true;
				AUTOSYNC_FEHLER_BIS_UMSCHALTUNG : natural := 25
				); 
   port( -- Taktquellen
			in_Platinentakt : in std_logic;
			in_AdatTakt     : in std_logic;
			
			-- Taktkonfiguration
			--in_ADAT_Taktwahl : in bit_vector(1 downto 0);
			
			-- ADAT-Schnittstellen
			in_ADAT      		  : in bit_vector(0 to SCHNITTSTELLEN-1);
			in_ADAT_InputEnable : in bit_vector(0 to SCHNITTSTELLEN-1);
			out_ADAT     		  : out bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0');
			out_WordClock : out bit;
			--in_ADAT_Taktflanke : in std_logic_vector(0 to SCHNITTSTELLEN-1); -- 0: Fallend, 1:Steigend
			
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
			DSP_FSX_FPGA_FSR   : inout std_logic;
			DSP_DX_FPGA_DR     : IN   bit;
			DSP_CLKR_FPGA_CLKX : IN   bit;
			DSP_FSR_FPGA_FSX   : out  bit := '0';
			DSP_DR_FPGA_DX     : out  bit := '0';
			Test_MCBSP_CLKX_OUT: out  bit := '0';
			Test_MCBSP_CLKR_OUT: out  bit := '0';
			Test_MCBSP_DR_OUT  : out  bit := '0';
			--CLKS : IN   bit;

		   Debug_FrameSync : out bit;
		   Debug_AdatTakt :out std_logic;
			Debug_DekoderNeueDaten : out bit;
			--Debug_Bit0: out bit;
			Debug_GesyncteDaten: out bit_vector(0 to SCHNITTSTELLEN-1);
			Debug_ADAT_Framesync : out bit_vector(0 to SCHNITTSTELLEN-1)
			);
			 
end Autosync;

architecture Verhalten of Autosync is
	
	component AutoSynchronisierer
		generic (AdatSchnittstellen : integer := 3;
					FehlerBisZurFlankenumschaltung : natural := 127);
		port(   --Takt-Eingang
				  in_ADAT_Takt	  : in std_logic;
				  -- Daten-Eingänge
				  In_ADAT 		  : in bit_vector(0 to SCHNITTSTELLEN-1);
				  
				  -- Daten-Ausgang			  
				  Out_ADAT 	  	  : out bit_vector(0 to SCHNITTSTELLEN-1);
				  --out_WordClock  : out bit;
				  Out_Framesync  : out bit;
				  --Out_Takt		  : out std_logic;
				  debug_ADAT_Framesync_CHN : out bit_vector(0 to SCHNITTSTELLEN-1)
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
			  out_NeueDaten  : out bit;
			  Out_DB0 : out bit
			  );
	end component;
	
	component ADAT_Enkoder
		generic( AdatSchnittstellen : integer := 3);
		port ( ADAT_Frame_Sync: in bit;
				 ADAT_Bit_Clock: in std_logic;
				 Daten : in ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
				 DatenUebernommen : out bit;
				 out_ADAT : out bit_vector(0 to SCHNITTSTELLEN-1) := (others => '0')--;
				 --Out_WordClock : out bit
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
					  FSR_OUTPUT : boolean := FSR_OUTPUT;
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
				 FSR : INOUT std_logic;
				  DR : IN   bit;
				CLKX : IN   bit;
				 FSX : out  bit;
				  DX : OUT  bit;
				
				-- ADAT-Puffer
				Daten_komplett_empfangen : OUT bit;
				Neue_Daten_Zum_Senden : in bit;
				
				-- Daten
				Daten_Eingang : in ADAT_Daten_Array(0 to SCHNITTSTELLEN-1); --McbSP<-Interface[Daten-Eingang]<-FPGA
				Daten_Ausgang : out ADAT_Daten_Array(0 to SCHNITTSTELLEN-1) --McBSP->Interface[Daten-Ausgang]->FPGA
				
			  );
	end component;
	 
	

	--Signale
	signal Adat_Frame_Sync_Enkoder: bit;
	
	signal ADAT_Taktflanke_bit : bit_vector(0 to SCHNITTSTELLEN-1); -- 0: Fallend, 1:Steigend
	signal AdatTaktFlanke : bit;
	
	signal Puffer_Enkoder_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal Enkoder_Puffer_DatenUebernommen: bit;
	
	signal ADATDekoder_McBSP_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal ADATDekoder_McBSP_NeueDaten: bit;
	
	signal McBSP_Puffer_Daten: ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal McBSP_Puffer_NeueDaten: bit;
	
	signal t_PufferUeberlauf : bit;
	signal t_PufferVoll 	    : bit;
	--signal t_PufferNormal    : bit;  Wird später aus den anderen Signalen abgeleitet
	signal t_PufferLeer      : bit;
	signal t_PufferUnterlauf : bit;
	
	signal Debug_McBSPTakt :bit;
	
	-- Synchronisierte Eingangssignale
	--signal Synced_Takt      : std_logic;
	signal Synced_Framesync : bit;
	signal Synced_ADAT_in   : bit_vector(0 to SCHNITTSTELLEN-1);
	signal ADAT_in_Bypassed : bit_vector(0 to SCHNITTSTELLEN-1);
	signal ADAT_out_copy    : bit_vector(0 to SCHNITTSTELLEN-1);
	
	signal tmp_FrameOK : bit_vector(0 to SCHNITTSTELLEN-1);
	signal kanal_aktiv : bit_vector(0 to SCHNITTSTELLEN-1);
	signal esLebt : bit;
begin
	
	inst_Autosync: AutoSynchronisierer
		generic map(AdatSchnittstellen => SCHNITTSTELLEN,
						FehlerBisZurFlankenumschaltung => AUTOSYNC_FEHLER_BIS_UMSCHALTUNG)
		port map (
			in_ADAT_Takt => in_AdatTakt,
			In_ADAT => ADAT_in_Bypassed,
			
			Out_ADAT => Synced_ADAT_in,
			Out_Framesync => Synced_Framesync,
			--Out_Takt => Synced_Takt,
			
			debug_ADAT_Framesync_CHN => Debug_ADAT_Framesync 
		);
	
	inst_ADAT_Dekoder: ADAT_Dekoder 
		generic map(AdatSchnittstellen => SCHNITTSTELLEN)
		port Map ( 
			ADAT_Takt => in_AdatTakt,--Synced_Takt,--Adat_Takt_ggfInvertiert,
			ADAT_Sync => Synced_Framesync,--ADAT_Frame_Sync_bit,
			-- Daten-Eingang
			In_ADAT => Synced_ADAT_in,--in_ADAT,
			-- Daten-Ausgang
			out_Daten  => ADATDekoder_McBSP_Daten,
			out_FrameOK => tmp_FrameOK,
			out_NeueDaten  => ADATDekoder_McBSP_NeueDaten,
			Out_DB0 => open--Debug_Bit0 --Debugging
			);
				
	inst_BRAM_Puffer_McBSP_Enkoder: DynamischerADATPuffer_BRAM
		generic map(PUFFERLAENGE => PUFFERLAENGE,
				   PUFFERBREITE => SCHNITTSTELLEN
				   )
		port MAP(
			clk => in_AdatTakt,--Synced_Takt,
			Reset => '0',
			Eingang_NeueDatenAngekommen  => McBSP_Puffer_NeueDaten,
			Eingang  => McBSP_Puffer_Daten,
			PufferVoll  => out_PufferVoll ,
			PufferLeer  => out_PufferLeer ,
			PufferUeberlauf  => out_PufferUeberlauf ,
			PufferUnterlauf  => out_PufferUnterlauf ,
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
        );
	
	inst_ADAT_Enkoder: ADAT_Enkoder
		generic map(AdatSchnittstellen => SCHNITTSTELLEN)
		port MAP(
			ADAT_Frame_Sync => ADAT_Frame_Sync_Enkoder,
			ADAT_Bit_Clock => in_AdatTakt,--Synced_Takt,
			Daten => Puffer_Enkoder_Daten,
			DatenUebernommen => Enkoder_Puffer_DatenUebernommen,
			out_ADAT => ADAT_out_copy--,--out_ADAT,
			--Out_WordClock => Out_WordClock
		);
	
	--Out-Signale ausgeben
	out_ADAT <= ADAT_out_copy;
	TEST: for i in 0 to SCHNITTSTELLEN-1 generate
		ADAT_in_Bypassed(i) <= in_ADAT(i) when in_ADAT_InputEnable(i)='1'--Bypass low => Kanal aktiviert
								                else ADAT_out_copy(i);  --Bypass high => Kanal wird ersetzt
	end generate;
	-- Zeigt, dass der FPGA läuft
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
				esLebt<= not wert;
				--FrameOK verknüpfen mit istEinSignalVorhanden?
				--
			end if;
		end if;
	end process;
	out_EsLebt <= esLebt;
	
	FrameOKandSignal: process(in_AdatTakt)
		type natural_array is array (0 to SCHNITTSTELLEN-1) of natural range 0 to 255;
		variable takte_ohne_transition: natural_array;
		variable ADAT_in_Bypassed_alt: bit_vector(0 to SCHNITTSTELLEN-1);
	begin
		if rising_edge(in_AdatTakt) then
			for kanal in 0 to SCHNITTSTELLEN-1 loop
				if takte_ohne_transition(kanal)=255 then
					takte_ohne_transition(kanal):= 0;
					kanal_aktiv(kanal)<='0';
				end if;
				if ADAT_in_Bypassed(kanal)/=ADAT_in_Bypassed_alt(kanal) then --Flanke
					ADAT_in_Bypassed_alt(kanal):=ADAT_in_Bypassed(kanal);
					takte_ohne_transition(kanal):= 0;
					kanal_aktiv(kanal)<= '1';
				else
					takte_ohne_transition(kanal):=takte_ohne_transition(kanal)+1; --keine Flanke
				end if;
				if kanal_aktiv(kanal)='1' then
					out_FrameOK(kanal) <= tmp_FrameOK(kanal);
				else
					out_FrameOK(kanal) <= not esLebt;
				end if;
			end loop;
			
		end if;
	end process;
	
	-- Takt & FrameSync werden beim Senden einfach vorgegeben (ADAT-Master)
	--   Hier wird einfach alle 256 Bits ein Framesync-Puls erzeugt
	FrameSyncSenden: process (in_AdatTakt)--(Synced_Takt)--
		variable Bitnummer : natural range 0 to 255:= 0;
	begin
		if rising_edge(in_AdatTakt) then
		--if rising_edge(Synced_Takt) then
			if Bitnummer = 255 then
				Bitnummer := 0;
				ADAT_Frame_Sync_Enkoder <= '1';
			else
				Bitnummer := Bitnummer + 1;
				ADAT_Frame_Sync_Enkoder <= '0';
			end if;
		end if;
	end process;
	
	--out_Wordclock <= to_bit(in_AdatTakt);
		
	Wordclock: process(in_AdatTakt)
		variable tmp:bit;
		variable counter: natural range 0 to 255;
	begin
		if rising_edge(in_AdatTakt) then
			counter := counter+1;
			if counter = 128 then
				counter :=0;
				tmp := not tmp;
				out_Wordclock<= tmp;
			end if;
		end if;
	end process;
	
	
	
	--ADAT_Frame_Sync_bit <= to_bit(ADAT_Frame_Sync);
	--Debug_FrameSync <= ADAT_Frame_Sync_bit;
	Debug_FrameSync <= Synced_Framesync;
	
	Debug_AdatTakt <= in_AdatTakt;--Synced_Takt;--Adat_Takt_ggfInvertiert;
	Test_MCBSP_CLKX_OUT <= DSP_CLKR_FPGA_CLKX;
	Test_MCBSP_CLKR_OUT <= DSP_CLKX_FPGA_CLKR;
	Test_MCBSP_DR_OUT <= DSP_DX_FPGA_DR;
	Debug_DekoderNeueDaten <= ADATDekoder_McBSP_NeueDaten;
	
	Debug_GesyncteDaten <= Synced_ADAT_in;--ADAT_in_Bypassed;--
	-- Wenn keine Probleme / Risiken vorliegen, ist alles Normal
	out_PufferNormal <= not (t_PufferUeberlauf or t_PufferVoll or t_PufferLeer or t_PufferUnterlauf);
end Verhalten;

