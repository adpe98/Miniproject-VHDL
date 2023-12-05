library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
entity test is
  Port ( sw: in std_logic_vector(3 downto 0);
        reset,clk,knapp: in std_logic;
        an: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        enable,lock: out std_logic
  );
end test;

architecture arch of test is

type state_type is (s1,s2,s3,s4,l1,l2,l3,l4);
signal nxt_st, nu_st: state_type;

signal sseg_in: std_logic_vector(6 downto 0);
signal vait, vait_nxt : unsigned(100 downto 0);
signal db_level, db_tick: std_logic;
begin
ssseg: entity work.sseg port map(sseg => sseg_in,
                                 sw => sw);
                                 
DB: entity work.lab15 port map(clk => clk,
                               res => reset,
                               sw => knapp,
                               db_tick => db_tick,
                               db_level => db_level);
                               
anod: entity work.anod port map(an => an,
                                sw => sw);

process(reset, clk)
begin
    if (reset = '1') then
        nu_st <= s1;
        --vait <= (others => '0');
        elsif (rising_edge(clk)) then
            nu_st <= nxt_st;
            vait <= vait_nxt;
    end if;
end process;

process (sw, nu_st, db_tick, nxt_st)
begin
    nxt_st <= nu_st;
   
    case nu_st is
        when s1 => 
            if (db_tick ='1' and sw = "0001") then
            nxt_st <= s2;
            else nxt_st <= l1;
            end if;
        when s2 =>
            if (db_tick ='1' and sw = "0011") then
            nxt_st <= s3;
            else nxt_st <= l2;
            end if;
        when s3 =>
            if (db_tick ='1' and sw = "0011") then
            nxt_st <= s4;
            else nxt_st <= l3;
            end if;
        when s4 =>
            if (db_tick = '1' and sw = "0111") then
            nxt_st <= s1;
            
            else nxt_st <= l4;
            end if;
        when l1 =>
            if (db_tick ='1') then
            nxt_st <= l2;
            end if;
        when l2 =>
            if (db_tick ='1') then
            nxt_st <= l3;
            end if;
        when l3 =>
            if (db_tick ='1') then
            nxt_st <= l4;
            end if; 
        when l4 =>
            if (db_tick ='1') then
            nxt_st <= s1;
            end if;   
        end case;
end process; 
      
--process (nu_st, vait, vait_nxt, reset)
--begin 
    --vait <= (others => '0');
   -- vait_nxt <= vait;
    --enable <= '0';
    --lock <= '1';
    --if (nu_st = s4 and reset = '0') then
      --  vait <= (others =>'1');
--      if (vait_nxt = 0) then
  --        enable <= '0';
  --    else
  --    vait_nxt <= vait -1;
  --    enable <= '1';
 --   end if;
 --   end if;
 --   if (nu_st = l4) then
 --       lock <= '1';
 --       else lock <= '0';
 --   end if;
-- end process;

sseg <= sseg_in;

 
end arch;