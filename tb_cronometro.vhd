library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_cronometro is
end tb_cronometro;

architecture test of tb_cronometro is
    -- Sinais para teste
    signal clk           : STD_LOGIC := '0';
    signal rst           : STD_LOGIC := '0';
    signal btn_debounced : STD_LOGIC := '1';
    signal display       : STD_LOGIC_VECTOR(6 downto 0);
    signal anode         : STD_LOGIC_VECTOR(2 downto 0);
    
    -- Clock de 50MHz (período de 20ns)
    constant clk_period  : time := 20 ns;

begin
    -- Instancia o DUT (Device Under Test)
    uut: entity work.cronometro
        port map (
            clk           => clk,
            rst           => rst,
            btn_debounced => btn_debounced,
            display       => display,
            anode         => anode
        );

    -- Processo de geração do clock
    clk_process: process
    begin
        while now < 10 ms loop  -- Simula por 10ms
            clk <= not clk;
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processo de estímulos de teste
    stimulus_process: process
    begin
        -- Garante reset inicial
        rst <= '0';
        wait for 50 ns;  -- Aguarda 50ns no reset
        rst <= '1';  -- Libera reset
        wait for 50 ns;
        
        -- Simula um pressionamento do botão para iniciar o cronômetro
        btn_debounced <= '0';
        wait for 50 ns;
        btn_debounced <= '1';
        wait for 1 sec; -- Aguarda para verificar contagem
        
        -- Simula um novo pressionamento para pausar
        btn_debounced <= '0';
        wait for 50 ns;
        btn_debounced <= '1';
        wait for 500 ms;

        -- Simula reset do cronômetro
        rst <= '0';
        wait for 50 ns;
        rst <= '1';
        
        -- Aguarda um pouco e finaliza a simulação
        wait for 1 sec;
        wait;
    end process;

end test;
