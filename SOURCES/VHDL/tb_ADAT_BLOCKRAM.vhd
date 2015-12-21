  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use work.ADAT.all;

  ENTITY tb_ADAT_BLOCKRAM IS
  END tb_ADAT_BLOCKRAM;

  ARCHITECTURE behavior OF tb_ADAT_BLOCKRAM IS 
          COMPONENT ADAT_BLOCKRAM
				generic( ADAT_SCHNITTSTELLEN : natural := 3;
							PUFFER_LAENGE : natural := 6
				);
          	port(clk  : in std_logic;
					  we   : in std_logic;
					  en 	 : in  std_logic;
					  addr : in natural;
					  di	 : in bit_vector(ADAT_DATENMENGE*ADAT_SCHNITTSTELLEN-1 downto 0);
					  do	 : out bit_vector(ADAT_DATENMENGE*ADAT_SCHNITTSTELLEN-1 downto 0)
					  );
          END COMPONENT;
			 --## CONFIG ##--
			 constant ADAT_SCHNITTSTELLEN : natural := 3;
			 constant PUFFER_LAENGE       : natural := 6;
			 ----------------
          SIGNAL tb_clk  : std_logic;
          SIGNAL tb_we   : std_logic;
			 signal tb_en   : std_logic;
			 signal tb_addr : natural;
			 signal tb_di   : bit_vector(ADAT_DATENMENGE*ADAT_SCHNITTSTELLEN-1 downto 0);
			 signal tb_do   : bit_vector(ADAT_DATENMENGE*ADAT_SCHNITTSTELLEN-1 downto 0);
			 signal tb_adat : ADAT_Daten_Array(0 to ADAT_SCHNITTSTELLEN-1);
          
  BEGIN
          uut: ADAT_BLOCKRAM
				generic map(ADAT_SCHNITTSTELLEN => ADAT_SCHNITTSTELLEN,
								PUFFER_LAENGE => PUFFER_LAENGE)
				PORT MAP(
                  clk => tb_clk,
                  we => tb_we,
						en => tb_en,
						addr => tb_addr,
						di => tb_di,
						do => tb_do
				);

     tb : PROCESS
     BEGIN
		  tb_addr <= 0;
		  tb_en <= '1';
		  tb_adat(0).userbits <= "1100";
		  tb_adat(1).userbits <= "1101";
		  tb_adat(2).userbits <= "1110";
        wait for 100 ns;

		  tb_we <= '1'; --schreiben 
		  tb_di <= AdatDatenArray_TO_Bitvector(tb_adat);
		  tb_clk <= '0', '1' after 50 ns;
		  
		  wait for 100 ns;
		  tb_we <= '0'; --lesen
		  tb_clk <= '0', '1' after 50 ns;
        wait;
     END PROCESS tb;
END;
