# Exp. 07 – Cronômetro Digital
**Disciplina:** FGA0071 - Prática de Eletrônica Digital 1  
**Professor:** Marcelino Monteiro de Andrade  
**Placa:** AX301 – Cyclone IV EP4CE6E22C8N  
**Ano/Semestre:** 02/2024

---

## 1. Objetivo

Projetar e implementar um **cronômetro digital** capaz de funcionar de 0min:00seg até 9min:59seg na FPGA AX301.  
O cronômetro deve ter:
- **Botões** para iniciar/parar (`Start/Stop`) e reiniciar (`Reset`);
- **Exibição dos números** nos três displays de 7 segmentos (minutos:segundos);
- As seguintes etapas implementadas no código:
  1. Divisor de clock (~1 segundo);
  2. Codificador para display de 7 segmentos;
  3. Multiplexação dos 3 displays;
  4. Controle dos três ânodos.

---

## 2. Materiais

- **Entradas:**  
  - 2 botões: `Reset` e `Start/Stop` (ambos conectados aos pinos da AX301)
- **Saídas:**  
  - 3 displays de 7 segmentos (para exibição de minutos e segundos)

---

## 3. Critérios de Avaliação

| Item                                                    | Pontos |
|---------------------------------------------------------|--------|
| Código VHDL                                             | 3      |
| Simulação e testbench                                   | 2      |
| Mapeamento dos sinais (pinagem)                         | 1      |
| Funcionamento do cronômetro na AX301                    | 4      |

---

## 4. Passo a Passo no Quartus/AX301

### 4.1. Abrir e Configurar o Projeto

1. **Extraia** os arquivos em uma pasta, ex:  
   `C:\Projetos_FPGA\cronometro`
2. Abra o **Quartus Prime**.
3. Abra ou crie um projeto, adicionando `cronometro.vhd` como Top Level Entity.
4. Defina o dispositivo:  
   - **Family:** Cyclone IV E  
   - **Device:** EP4CE6E22C8N

---

### 4.2. Pin Planner – Atribuição dos Pinos

| Sinal           | Direção | Descrição                        | Pino Sugerido*    |
|-----------------|---------|----------------------------------|-------------------|
| clk             | in      | Clock 50MHz da placa             | PIN_23            |
| rst             | in      | Reset (ativo baixo)              | PIN_57            |
| btn_debounced   | in      | Botão Start/Stop                 | PIN_41            |
| display[6..0]   | out     | Segmentos A-G dos displays       | PIN_91–PIN_97     |
| anode[2..0]     | out     | Seleção dos displays             | PIN_61–PIN_63     |

> **Atenção:** Os pinos são exemplos! Consulte o manual da AX301 para os pinos corretos do seu kit.

**Como atribuir:**
1. No Quartus, vá em **Assignments > Pin Planner**.
2. Atribua cada sinal ao pino físico correspondente (veja tabela e o manual).
3. Salve e feche.

---

### 4.3. Compilar o Projeto

1. Clique em **Compile**.
2. Aguarde o término e verifique se não há erros.

---

### 4.4. Gravar na AX301

1. Conecte a AX301 via USB-Blaster.
2. Abra **Tools > Programmer**.
3. Selecione `USB-Blaster`.
4. Adicione o arquivo `.sof`.
5. Marque **Program/Configure** e clique em **Start**.

---

## 5. Testes e Funcionamento

- O cronômetro começa parado.
- Botão **Start/Stop** alterna entre contar e pausar.
- Botão **Reset** zera o cronômetro (ativo em nível baixo).
- O tempo é exibido nos displays (minuto e segundos).

---

## 6. Dicas

- Confira o tipo do display (ânodo/cátodo comum) e ajuste o código se necessário.
- Use debounce por hardware ou software no botão para evitar múltiplos acionamentos.
- Se algo não aparecer, revise o Pin Planner e conexões.

---

## 7. Recursos

- [Manual da AX301](https://www.eimodule.com/download/AX301_UserManual.pdf)
- [Pinagem Cyclone IV EP4CE6E22C8N](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/dp/cyclone-iv/ep4ce6.pdf)

---

### Exemplo de Pin Assignment no `.qsf`:

```tcl
set_location_assignment PIN_23  -to clk
set_location_assignment PIN_57  -to rst
set_location_assignment PIN_41  -to btn_debounced
set_location_assignment PIN_91  -to display[0]
set_location_assignment PIN_92  -to display[1]
set_location_assignment PIN_93  -to display[2]
set_location_assignment PIN_94  -to display[3]
set_location_assignment PIN_95  -to display[4]
set_location_assignment PIN_96  -to display[5]
set_location_assignment PIN_97  -to display[6]
set_location_assignment PIN_61  -to anode[0]
set_location_assignment PIN_62  -to anode[1]
set_location_assignment PIN_63  -to anode[2]

