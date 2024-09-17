library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity int_div is
	port(
		i_clk     : in  std_logic; -- 100 MHz
		in_rst    : in  std_logic;

		i_num     : in  std_logic_vector(23 downto 0); -- signed
		i_den     : in  std_logic_vector(7 downto 0); -- unsiged
		o_res     : out std_logic_vector(15 downto 0) -- signed
	);
end entity;

architecture arch of int_div is

	subtype t_24b is std_logic_vector(23 downto 0);
	type t_a_24b is array (0 to 17) of t_24b;
	subtype t_16b is std_logic_vector(15 downto 0);
	type t_a_16b is array (0 to 17) of t_16b;

	signal num     : std_logic_vector(23 downto 0);
	signal den     : std_logic_vector( 7 downto 0);
	signal neg     : std_logic;
	signal num2    : std_logic_vector(23 downto 0);
	signal den2    : std_logic_vector(23 downto 0);
	signal res     : std_logic_vector(15 downto 0);
	signal a_neg   : std_logic_vector(17 downto 0);
	signal a_num2  : t_a_24b;
	signal a_den2  : t_a_24b;
	signal a_res   : t_a_16b;
	

begin
	num <= i_num;
	den <= i_den;
	
	neg <= num(23);
	num2 <= x"000000"-num when neg = '1' else num;

	den2 <= den & x"0000";

	a_neg(0) <= neg;
	a_num2(0) <= num2;
	a_den2(0) <= den2;
	a_res(0) <= x"0000";
	int_div_fg: for i in 0 to 16 generate
		process(i_clk, in_rst)
		begin
			if in_rst = '0' then
				a_neg(i+1) <= '0';
				a_num2(i+1) <= x"000000";
				a_den2(i+1) <= x"000000";
				a_res(i+1) <= x"0000";
			elsif rising_edge(i_clk) then
				a_neg(i+1) <= a_neg(i);
				if a_num2(i) >= a_den2(i) then
					a_num2(i+1) <= a_num2(i) - a_den2(i);
					a_res(i+1) <= (a_res(i)(14 downto 0) & "0") + 1;
				else
					a_num2(i+1) <= a_num2(i);
					a_res(i+1) <= (a_res(i)(14 downto 0) & "0");
				end if;
				a_den2(i+1) <= '0' & a_den2(i)(23 downto 1);
			end if;
		end process;
	end generate;

	process(i_clk, in_rst)
	begin
		if in_rst = '0' then
			o_res <= x"0000";
		elsif rising_edge(i_clk) then
			if a_neg(17) = '1' then
				o_res <= x"0000"-a_res(17);
			else
				o_res <= a_res(17);
			end if;
		end if;
	end process;

end architecture;
