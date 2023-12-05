library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
entity test is
  Port ( sw: in std_logic_vector(3 downto 0);
        reset,clk,knapp: in std_logic;
        an: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        enable,lock,ljud,ljud1: out std_logic;
        lo1,lo2,lo3,los,st1,st2,st3,st4 : out std_logic 
  );
end test;

architecture arch of test is

type state_type is (s1,s2,s3,s4,l1,l2,l3,lost,oppet,oppet1,lost1);
signal nxt_st, nu_st: state_type;

signal sseg_in: std_logic_vector(6 downto 0);
signal vait, vait_nxt : unsigned(30 downto 0);
signal vait1, vait_nxt1 : unsigned(30 downto 0);
signal db_level, db_tick: std_logic;
begin
ssseg: entity work.sseg port map(sseg => sseg_in,
                                 sw => sw);
                                 
DB: entity work.lab15 port map(clk => clk,
                               res => reset,
                               knapp => knapp,
                               db_tick => db_tick,
                               db_level => db_level);
                               
anod: entity work.anod port map(an => an,
                                sw => sw);

process(reset, clk)
begin
    if (reset = '1') then
        nu_st <= s1;
        vait <= (others => '0');
        vait1 <= (others => '0');
        elsif (rising_edge(clk)) then
            nu_st <= nxt_st;
            vait <= vait_nxt;
            vait1 <= vait_nxt1;
    end if;
end process;

process (sw, nu_st, db_tick, nxt_st, reset,vait,vait_nxt,vait1,vait_nxt1)
begin
    vait_nxt <= vait;
    vait_nxt1 <= vait1;
    nxt_st <= nu_st;
    enable <= '0';
    lock <= '0';
    lo1 <= '0';
    lo2 <= '0';
    lo3 <= '0';
    los <= '0';
    st1 <= '0';
    st2 <= '0';
    st3 <= '0';
    st4 <= '0';
    
    case nu_st is
        when s1 => 
        st1 <= '1';
            if (db_tick ='1') then
                if (sw = "0001") then
                    nxt_st <= s2;
                else 
                    nxt_st <= l1;
                end if;
            
            end if;
        when s2 =>
        st2 <= '1';
            if (db_tick ='1') then
                if (sw = "0011") then
                    nxt_st <= s3;
                else 
                    nxt_st <= l2;
                end if;
            end if;
        when s3 =>
        st3 <= '1';
            if (db_tick ='1') then
                if (sw = "0011") then 
                    nxt_st <= s4;
                else 
                    nxt_st <= l3;
                end if;
            end if;
        when s4 =>
        
            if (db_tick = '1') then
                if (sw = "0111") then
                    nxt_st <= oppet;
                else 
                    nxt_st <= lost;
                end if;
            end if;
        when l1 =>
        lo1 <= '1';
            if (db_tick ='1') then
                nxt_st <= l2;
            end if;
        when l2 =>
        
            if (db_tick ='1') then
                nxt_st <= l3;
            end if;
        when l3 =>
        
            if (db_tick ='1') then
                nxt_st <= lost;
            end if; 
--        when l4 =>
--            if (db_tick ='1') then
--            nxt_st <= lost;
--            end if;
        when oppet =>
        enable <= '1';
        vait_nxt <= vait + 1;
        st4 <= '1';
            if (vait_nxt = "11111111111111111111111111111") then
                nxt_st <= oppet1;
            else 
                nxt_st <= oppet;   
            end if;
        when oppet1 =>
        enable <= '1';
        vait_nxt <= (others => '0');
        st2 <= '1';
            if (reset = '1') then
                nxt_st <= s1;
            else 
                nxt_st <= oppet1;
            end if;
            
        when lost =>
        lock <= '1';
        lo2 <= '1';
        vait_nxt1 <= vait1 +1;
            if (vait_nxt1 = "11111111111111111111") then
                nxt_st <= lost1;
            else
                nxt_st <= lost;
            end if;
        when lost1 =>
        lock <= '1';
        lo3 <= '1';
        vait_nxt1 <= (others => '0');
        
            if (reset ='1') then
                nxt_st <= s1;
                else
                nxt_st <= lost;
            end if;
        end case;
end process; 

ljud <= std_logic(vait(18));
ljud1 <= std_logic(vait1(16));
--process is
--begin 
    
 --   vait_nxt <= vait;
    --enable <= '0';
    --lock <= '1';
 --   if (nu_st = s4) then
  --      vait <= (others =>'1');
 --       enable <= '1';
       
 --     if (vait_nxt = 0) then
 --         enable <= '0';
       
   --   else
 --     vait_nxt <= vait -1;
      
 --   end if;
  --  end if;
 --   if (nu_st = l4) then
 --       lock <= '1';
 --       else lock <= '0';
  --  end if;
--end process;
--vait <= (others => '0');
sseg <= sseg_in;

 
end arch;