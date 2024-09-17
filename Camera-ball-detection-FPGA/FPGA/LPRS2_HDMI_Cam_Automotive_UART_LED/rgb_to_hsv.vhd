
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity rgb_to_hsv is
	port (
		i_gpu_clk       : in    std_logic; -- 100 MHz
		in_rst          : in    std_logic;
		
		i_r       : in    std_logic_vector(7 downto 0);
		i_g       : in    std_logic_vector(7 downto 0);
		i_b       : in    std_logic_vector(7 downto 0);
		
		o_h       : out    std_logic_vector(7 downto 0);
		o_s       : out   std_logic_vector(7 downto 0);
		o_v       : out   std_logic_vector(7 downto 0)
	);
end entity rgb_to_hsv;

architecture arch of rgb_to_hsv is
	
	signal RGB_Max : std_logic_vector(7 downto 0);
	signal V : std_logic_vector(7 downto 0);

begin
	process(i_clk, in_rst)
	begin
		if in_rst = '0' then
			RGB_Max <= (others => '0');
		elsif rising_edge(i_clk) then
			if i_r > i_g then
				if i_r > i_b then
					RGB_Max <= i_r;
				else
					RGB_Max <= i_b;

				end if;
			elsif i_g > i_b then
				RGB_Max <= i_g;
			end if;
		end if;
	end process;


	V <= RGB_Max;

	process(i_clk, in_rst)
	begin
		if in_rst = '0' then
			o_h <= x"00";
		elsif rising_edge(i_clk) then
			if V = 0 then
				o_h <= x"00";
				o_s <= x"00";
				o_v <= x"00";
			elsif S = 0 then
				o_h <= x"00";
				o_s <= x"00";
				o_v <= V;
			else
				o_h <= H;
				o_s <= S;
				o_v <= V;
			end if;
		end if;
	end process;

	
	process(i_clk, in_rst)
	begin
		if in_rst = '0' then
			RGB_Max <= (others => '0');
		elsif rising_edge(i_clk) then
			o_h <= 
		end if;
	end process;


end architecture arch;
