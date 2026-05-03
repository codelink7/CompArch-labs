use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile_tb is 
end regfile_tb;

architecture mytest of regfile_tb is 

constant clock_period : time:= 100 ns;
signal clk, RegWrite : std_logic := '0';
signal WriteAddr, ReadAddr1, ReadAddr2 : std_logic_vector(4 downto 0) := (others => '0');
signal WriteData : std_logic_vector(31 downto 0) := (others => '0');
signal ReadData1, ReadData2 : std_logic_vector(31 downto 0);
signal Enable: std_logic := '1';

component reg_file is 
port(

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

end component;

begin

regfile: reg_file port map (

Ain_1 => ReadAddr1,
Ain_2 => ReadAddr2,
Xout_1 => ReadData1,
Xout_2 => ReadData2,
clk => clk,
write_reg => WriteAddr,
data_in => WriteData,
Enin => Enable,
write_en => RegWrite

);

process 
begin
	while true loop
		clk <= '1';
		wait for clock_period/2;
		clk <='0';
		wait for clock_period/2;
	end loop;
end process;

stim_proc: process
    begin
wait for 20 ns;

        -- Case 1: Attempt to write while RegWrite is LOW (Nothing should happen)
        RegWrite  <= '0';
        WriteAddr <= "00001"; -- Reg 1
        WriteData <= x"DEADBEEF";
        ReadAddr1 <= "00001";
        wait for clk_period;

        -- Case 2: Enable RegWrite (Data should appear on ReadData1 after the rising edge)
        RegWrite  <= '1';
        wait for clk_period;
        
        -- Case 3: Disable RegWrite and change WriteData (ReadData1 should stay DEADBEEF)
        RegWrite  <= '0';
        WriteData <= x"FFFFFFFF";
        wait for clk_period;

        -- Case 4: Read and Write SAME register in SAME clock cycle
        -- We write 12345678 to Reg 5 and read from Reg 5 at the same time
        WriteAddr <= "00101"; -- Reg 5
        WriteData <= x"12345678";
        ReadAddr2 <= "00101"; -- Reading from Reg 5 on Port 2
        RegWrite  <= '1';
        wait for clk_period;

        -- Case 5: Independent Port Reading
        -- Let's read Reg 1 on Port 1 and Reg 5 on Port 2 simultaneously
        RegWrite  <= '0';
        ReadAddr1 <= "00001"; -- Should see DEADBEEF
        ReadAddr2 <= "00101"; -- Should see 12345678
        wait for clk_period;

        -- Finish simulation
        wait;
end process;

end mytest;
