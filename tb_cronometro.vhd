library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cronometro is
end tb_cronometro;

architecture behavior of tb_cronometro is

    -- Declarando o componente a ser testado
    component cronometro
        Port (
            CLK        : in  STD_LOGIC;
            RESET      : in  STD_LOGIC;
            START_STOP : in  STD_LOGIC;
            DISP_SEG   : out STD_LOGIC_VECTOR(7 downto 0);
            DISP_SEL   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Sinais de estímulo
    signal clk_tb        : STD_LOGIC := '0';
    signal reset_tb      : STD_LOGIC := '1';
    signal start_stop_tb : STD_LOGIC := '1';
    signal disp_seg_tb   : STD_LOGIC_VECTOR(7 downto 0);
    signal disp_sel_tb   : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instância do DUT (Device Under Test)
    uut: cronometro
        port map (
            CLK        => clk_tb,
            RESET      => reset_tb,
            START_STOP => start_stop_tb,
            DISP_SEG   => disp_seg_tb,
            DISP_SEL   => disp_sel_tb
        );

    -- Geração do Clock de 50 MHz (20 ns de período)
    clk_process: process
    begin
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end process;

    -- Processo de estímulo: Reset e Start/Stop
    stim_proc: process
    begin
        -- Reset inicial
        wait for 50 ns;
        reset_tb <= '0';
        wait for 30 ns;
        reset_tb <= '1';

        -- Start
        wait for 50 ns;
        start_stop_tb <= '0';
        wait for 20 ns;
        start_stop_tb <= '1';

        -- Deixa o cronômetro rodar por um tempo
        wait for 500000 ns;

        -- Stop
        start_stop_tb <= '0';
        wait for 20 ns;
        start_stop_tb <= '1';

        -- Final da simulação
        wait;
    end process;

end behavior;
