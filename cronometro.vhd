library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro is
    Port (
        clk           : in STD_LOGIC;
        rst           : in STD_LOGIC;
        --start_stop    : in STD_LOGIC;
        display       : out STD_LOGIC_VECTOR(6 downto 0);
        anode         : out STD_LOGIC_VECTOR(2 downto 0);
        btn_debounced : in STD_LOGIC -- Adicionado filtro para bouncing
    );
end cronometro;

architecture Behavioral of cronometro is
    signal clk_div          : unsigned(25 downto 0) := (others => '0');
    signal mux_clk_div      : unsigned(15 downto 0) := (others => '0');
    signal one_sec_pulse    : STD_LOGIC := '0';
    signal mux_pulse        : STD_LOGIC := '0';
    signal seconds          : integer range 0 to 59 := 0;
    signal minutes          : integer range 0 to 9 := 0;
    signal running          : STD_LOGIC := '0';
    signal anode_sel        : integer range 0 to 2 := 0;
    signal digit_value      : integer range 0 to 9 := 0;

    -- Novo sinal para detectar borda de descida do botão
    signal btn_last_state   : STD_LOGIC := '1';
    signal btn_edge_detected : STD_LOGIC := '0';

begin

    -- Processo para detecção de borda de descida do botão
    process (clk)
    begin
        if rising_edge(clk) then
            btn_edge_detected <= '0'; -- Reseta o sinal a cada ciclo
            if btn_last_state = '1' and btn_debounced = '0' then
                btn_edge_detected <= '1'; -- Detecta borda de descida
            end if;
            btn_last_state <= btn_debounced; -- Atualiza o estado anterior
        end if;
    end process;

    -- Divisor de clock para 1 segundo
    process (clk)
    begin
        if rising_edge(clk) then
            if clk_div = 49999999 then
                clk_div <= (others => '0');
                one_sec_pulse <= '1';
            else
                clk_div <= clk_div + 1;
                one_sec_pulse <= '0';
            end if;
        end if;
    end process;

    -- Divisor de clock para multiplexação dos displays (~1kHz)
    process (clk)
    begin
        if rising_edge(clk) then
            if mux_clk_div = 50000 then
                mux_clk_div 	<= (others => '0');
                mux_pulse 		<= '1';
            else
                mux_clk_div 	<= mux_clk_div + 1;
                mux_pulse 		<= '0';
            end if;
        end if;
    end process;

    -- Contador de minutos e segundos
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then  -- Reset ativo baixo
                seconds <= 0;
                minutes <= 0;
                running <= '0';
            elsif btn_edge_detected = '1' then -- Usa o novo sinal para alternar `running`
                running <= not running;
            end if;
            
            if one_sec_pulse = '1' and running = '1' then
                if seconds = 59 then
                    seconds <= 0;
                    if minutes < 9 then
                        minutes <= minutes + 1;
                    end if;
                else
                    seconds <= seconds + 1;
                end if;
            end if;
        end if;
    end process;

    -- Multiplexação dos displays
    process (clk)
    begin
        if rising_edge(clk) then
            if mux_pulse = '1' then
                anode_sel <= (anode_sel + 1) mod 3;
            end if;
        end if;
    end process;
    
    anode <= "110" when anode_sel = 0 else
             "101" when anode_sel = 1 else
             "011";

    -- Seleção do valor a ser exibido
    process (anode_sel, seconds, minutes)
    begin
        case anode_sel is
            when 0 => digit_value <= minutes;
            when 1 => digit_value <= seconds / 10;
            when 2 => digit_value <= seconds mod 10;
            when others => digit_value <= 0;
        end case;
    end process;

    -- Decodificador para display de 7 segmentos
    process (digit_value)
    begin
        case digit_value is
            when 0 => display <= not "1111110";
            when 1 => display <= not "0110000";
            when 2 => display <= not "1101101";
            when 3 => display <= not "1111001";
            when 4 => display <= not "0110011";
            when 5 => display <= not "1011011";
            when 6 => display <= not "1011111";
            when 7 => display <= not "1110000";
            when 8 => display <= not "1111111";
            when 9 => display <= not "1111011";
            when others => display <= "0000000";
        end case;
    end process;

end Behavioral;
