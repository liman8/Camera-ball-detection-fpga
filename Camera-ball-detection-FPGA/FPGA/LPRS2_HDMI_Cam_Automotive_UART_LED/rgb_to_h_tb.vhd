library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library std;
use std.textio.all;

library work;

entity rgb_to_h_tb is
end rgb_to_h_tb;

architecture Behavior of rgb_to_h_tb is
	constant r_beg : integer := 1; -- TODO 255
	constant r_end : integer := 255;
	
	constant g_beg : integer := 1;
	constant g_end : integer := 255;
	
	constant b_beg : integer := 1;
	constant b_end : integer := 255;
	
	constant i_clk_period : time := 10 ns; -- 100MHz
	
	signal i_clk       : std_logic := '0';
	signal in_rst      : std_logic := '0';
	signal i_r     : std_logic_vector(7 downto 0);
	signal i_g      : std_logic_vector(7 downto 0);
	signal i_b      : std_logic_vector(7 downto 0);
	signal o_h      : std_logic_vector(7 downto 0);
	
	signal rr         : integer;
	signal gg         : integer;
	signal bb         : integer;
	signal exp_h     : integer;
	signal obs_h     : integer;
	
	
	file fo : text open WRITE_MODE is "STD_OUTPUT";
	
	function RGB_2_H(r : integer; g : integer; b : integer) return integer is
	
		variable RGB_Max : integer;
		variable RGB_Min : integer;
		variable V : integer;
		variable DF : integer;
		variable D : integer;
		variable O : integer;
		variable OD : integer;
		variable DIV : integer;
		variable M : integer;
		variable H : integer;
		
	begin
		
		
       if r > g then
           if r > b then
                    RGB_Max := r;
                    D       := g - b;
            else
                    RGB_Max := b;
                    D       := r - g;
            end if;
        elsif g > b then
                RGB_Max := g;
                D       := b - r;
        end if;
		  
		  if r < g then
            if r < b then
                 RGB_Min := r;
            else
                  RGB_min := b;

            end if;
         elsif g < b then
             RGB_Min := g;
         end if;
     
			
		  
		V := RGB_Max;
		
		
		if V = 0 then
			return 0;
		end if;
		
		DF := RGB_Max - RGB_Min;
		
		if DF*255 < V then
			return 0;
		end if;
		
		O := 43*256;
		OD := O*D;
		DIV := OD/DF;
		M := DIV/256;
		
		
		 if RGB_Max = r then
           H := M;
		 elsif RGB_Max = g then
			  H := 85 + M;
		 else 
			  H := 171 + M;
		 end if;
		
		return H;
		
	end function;

begin


	-- Instantiate the Unit Under Test (UUT)
	uut: entity work.rgb_to_h
	port map(
		i_clk     => i_clk,
		in_rst    => in_rst,

		i_r     => i_r,
		i_g    => i_g,
		i_b    => i_b,
		o_h     => o_h
	);


	-- Clock process definitions
	i_clk_proc: process
	begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
	end process;

	
	
	


	
	full_test: if 0 = 0 generate
		-- Stimulus process
		gen_proc: process
		begin
			in_rst <= '0';
			wait for i_clk_period;
			in_rst <= '1';
			
			for r in r_beg to r_end loop
				for g in g_beg to g_end loop
					for b in b_beg to b_end loop
					
					--rr <= conv_integer(unsigned(i_r));
					--gg <= conv_integer(unsigned(i_g));
					--bb <= conv_integer(unsigned(i_b));
					
					
						rr <= r;
						gg <= g;
						bb <= b;
					
					
						wait for 0 ns;
						i_r <= conv_std_logic_vector(rr, 24);
						i_g <= conv_std_logic_vector(gg, 24);
						i_b <= conv_std_logic_vector(bb, 24);
					
						wait for i_clk_period;
					
					end loop;
				end loop;
			end loop;

		
			wait;
		end process;

		mon_proc: process
			variable num : integer;
			variable den : integer;
			variable l : line;
		begin
			wait for 19*i_clk_period;
		
			for r in r_beg to r_end loop
				for g in g_beg to g_end loop
					for b in b_beg to b_end loop
				
					exp_h <= RGB_2_H(r, g, b);
					obs_h <= conv_integer(unsigned(o_h));
					wait for 0 ns;
					
					if abs(exp_h - obs_h) > 1 then
						write(l, string'("Fail:"));
						write(l, string'("    t = "));
							write(l, integer'image(time'pos(now)/1000000));
							write(l, string'(" ns"));
						write(l, string'("    r = "));
							write(l, integer'image(r));
						write(l, string'("    g = "));
							write(l, integer'image(g));
						write(l, string'("    b = "));
							write(l, integer'image(b));
						write(l, string'("    exp_h = "));
							write(l, integer'image(exp_h));
						write(l, string'("    obs_h = "));
							write(l, integer'image(obs_h));
						writeline(fo, l);
					end if;
					
					wait for i_clk_period;
					end loop;
				end loop;
			end loop;
		
			write(l, string'("End"));
			writeline(fo, l); 
			wait;
		end process;
	end generate;


end architecture;