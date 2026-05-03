library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_file is 
port ( 

Ain_1: in std_logic_vector(4 downto 0); 
Xout_1 : out std_logic_vector(31 downto 0); 
ENin: in std_logic;
clk: in std_logic;
Ain_2: in std_logic_vector(4 downto 0); 
Xout_2 : out std_logic_vector(31 downto 0);
write_reg: in std_logic_vector ( 4 downto 0);
write_en: in std_logic;
data_in: in std_logic_vector(31 downto 0)

);

end reg_file;


architecture myarch of reg_file is
    type regfile is array (0 to 31) of std_logic_vector(31 downto 0);
    signal myregfile : regfile := (others => (others => '0'));
    signal sel_1 : std_logic_vector(31 downto 0);
    signal sel_2 : std_logic_vector(31 downto 0);

    component decode_5to32_top
        port ( 
            A  : in  std_logic_vector(4 downto 0); 
            X  : out std_logic_vector(31 downto 0); 
            EN : in  std_logic
        );
    end component;

begin
    dec1 : decode_5to32_top 
        port map ( 
            A  => Ain_1,
            X  => sel_1, 
            EN => ENin
        );
    dec2 : decode_5to32_top 
        port map ( 
            A  => Ain_2,
            X  => sel_2, 
            EN => ENin
        );
    process(sel_1, Ain_1)
        variable temp_out : std_logic_vector(31 downto 0);
    begin
        temp_out := (others => '0');
        for i in 0 to 31 loop
            if sel_1(i) = '1' then
                temp_out := myregfile(i);
            end if;
        end loop;
        Xout_1 <= temp_out;
    end process;


  process(sel_2, Ain_2)
        variable temp_out : std_logic_vector(31 downto 0);
    begin
        temp_out := (others => '0');
        for i in 0 to 31 loop
            if sel_2(i) = '1' then
                temp_out := myregfile(i);
            end if;
        end loop;
        Xout_2 <= temp_out;
    end process;

 process(clk)
begin

if(falling_edge(clk) AND write_en = '1') then

	myregfile(to_integer(unsigned(write_reg))) <= data_in;
end if;

end process;

end myarch;
