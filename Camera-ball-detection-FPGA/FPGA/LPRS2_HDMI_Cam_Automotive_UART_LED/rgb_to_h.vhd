library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity rgb_to_h is
    port(
        i_clk     : in std_logic; -- 100 MHz
        in_rst    : in std_logic;

        i_r       : in std_logic_vector(7 downto 0);
        i_g       : in std_logic_vector(7 downto 0);
        i_b       : in std_logic_vector(7 downto 0);

        o_h       : out std_logic_vector(7 downto 0)
    );
end entity;


architecture arch of rgb_to_h is

	subtype t_8b is std_logic_vector(7 downto 0);
	type t_a_8b is array (0 to 17) of t_8b;

    signal RGB_Max : std_logic_vector(7 downto 0);
    signal RGB_Min : std_logic_vector(7 downto 0);
    signal H       : std_logic_vector(7 downto 0);
    signal S       : std_logic_vector(7 downto 0);
    signal V       : std_logic_vector(7 downto 0);
    signal DF      : std_logic_vector(7 downto 0);
    signal D       : std_logic_vector(7 downto 0);
    signal OD      : std_logic_vector(23 downto 0);
    signal DIV     : std_logic_vector(15 downto 0);
    signal M       : std_logic_vector(7 downto 0);
    signal O       : std_logic_vector(15 downto 0);
	
	signal a_v  : t_a_8b;
	signal a_s  : t_a_8b;
	

	 
begin 
    process(i_clk, in_rst)
    begin
        if in_rst = '0' then
            RGB_Max <= (others => '0');
        elsif rising_edge(i_clk) then
            if i_r > i_g then
                if i_r > i_b then
                    RGB_Max <= i_r;
                    D       <= i_g - i_b;
						  H		 <= M;
                else
                    RGB_Max <= i_b;
                    D       <= i_r - i_g;
						  H		 <= "10101011" + M;
                end if;
            elsif i_g > i_b then
                RGB_Max <= i_g;
                D       <= i_b - i_r;
					 H		 <= "01010101" + M;
            end if;
        end if;
    end process;

    process (i_clk, in_rst)
        begin
            if in_rst = '0' then
                RGB_Min <= (others => '0');
            elsif rising_edge(i_clk) then
                if i_r < i_g then
                    if i_r < i_b then
                        RGB_Min <= i_r;
                    else
                        RGB_min <= i_b;

                    end if;
                elsif i_g < i_b then
                    RGB_Min <= i_g;
                end if;
            end if;
        end process;
		  
		  

	
	
        V   <= RGB_Max;
        DF  <= RGB_Max - RGB_Min;
		  O   <= "0010101100000000";
        OD  <= O * D;
       -- DIV <= OD/DF;
        M   <= DIV(15 downto 8);
		  
		

		  	
	uut: entity work.int_div
	port map(
		i_clk     => i_clk,
		in_rst    => in_rst,

		i_num     => OD,
		i_den     => DF,
		o_res     => DIV
	);
	
	a_v(0) <= V;
	a_s(0) <= S;
   int_div_fg: for i in 0 to 16 generate
    process (i_clk, in_rst)
    begin
        if in_rst = '0' then
				a_v(i+1) <= x"00";
				a_s(i+1) <= x"00";
			
        elsif rising_edge(i_clk) then
			  a_s(i+1) <= a_s(i);
			  a_v(i+1) <= a_v(i);
        end if;
    end process;
	end generate;

	    process (i_clk, in_rst)
    begin
        if in_rst = '0' then
            o_h <= x"00";
			
        elsif rising_edge(i_clk) then  
            if a_v(17) = 0 then
				 o_h <= x"00";
          
            elsif a_s(17) = 0 then
                o_h <= x"00";
                
            else
                o_h <= H;
         
            end if;
        end if;
    end process;

end architecture;
