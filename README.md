# Projeto Cronômetro Digital FPGA AX301 - Quartus Web Edition

## 📌 Descrição do Projeto

Implementação de um cronômetro digital com contagem de **0:00 a 9:59 (minutos:segundos)** na placa **FPGA AX301 (Cyclone IV E - EP4CE6F17C8)**.

O cronômetro possui:

- Dois botões físicos: **Start/Stop** e **Reset**.
- Exibição da contagem em **3 displays de 7 segmentos** com **lógica invertida**.
- Multiplexação dos displays.
- Divisor de clock para gerar **1Hz** a partir dos **50MHz** da placa.
- Testbench para simulação.

---

## ✅ Estrutura de Arquivos

| Arquivo | Função |
|---|---|
| `cronometro.vhd` | Código fonte do cronômetro |
| `tb_cronometro.vhd` | Testbench para simulação |
| `cronometro.qsf` | Mapeamento de pinos (Pin Assignments) |
| `cronometro.sdc` | Restrições de tempo (Clock Constraint) |

---

## ✅ Passo a Passo de Implementação

### 1) Criando o Projeto no Quartus Web Edition

1. Abra o Quartus.
2. Vá em: **File → New Project Wizard → Next**.
3. Escolha uma pasta (ex: `C:\Projetos\CronometroAX301`).
4. Nome do projeto: **cronometro**.
5. Na seleção de dispositivo:
   - **Family:** Cyclone IV E
   - **Device:** EP4CE6F17C8
6. Finalize clicando em **Finish**.

---

### 2) Adicionando os Arquivos VHDL

1. Vá em: **File → New → VHDL File → OK**.
2. Copie o código de `cronometro.vhd` e salve.
3. Se for simular, crie também o arquivo `tb_cronometro.vhd` com o testbench.

Depois vá em:  
**Assignments → Settings → Files**  
E confirme se os arquivos aparecem listados.

---

### 3) Inserindo o Arquivo `.sdc`

1. Copie o arquivo `cronometro.sdc` para a pasta do projeto.
2. No Quartus:  
**Assignments → Settings → Timing Analysis Settings → Add**  
Adicione o `.sdc`.

---

### 4) Primeira Compilação Rápida (Para carregar as portas no Pin Planner)

1. Vá em: **Processing → Start Compilation**.
2. Mesmo que dê erro de pinos, deixe compilar até o fim.

---

### 5) Mapeamento de Pinos (Pin Planner)

1. Vá em: **Assignments → Pin Planner**.
2. Insira o seguinte mapeamento:

| Sinal | Pino |
|---|---|
| CLK | E1 |
| RESET | N13 |
| START_STOP | M15 |
| DISP_SEG[0] | R14 |
| DISP_SEG[1] | N16 |
| DISP_SEG[2] | P16 |
| DISP_SEG[3] | T15 |
| DISP_SEG[4] | P15 |
| DISP_SEG[5] | N12 |
| DISP_SEG[6] | N15 |
| DISP_SEG[7] | R16 |
| DISP_SEL[0] | N9 |
| DISP_SEL[1] | P9 |
| DISP_SEL[2] | M10 |

> ⚠️ **Importante:** Para todos os pinos, selecione o padrão de I/O:  
**3.3-V LVCMOS**

Depois **salve o Pin Planner**.

---

### 6) Compilar Novamente

- **Processing → Start Compilation**

Agora os erros de pinos vão sumir.

---

### 7) Simulação no ModelSim (Opcional)

Se quiser simular:

1. Compile o código e o Testbench no ModelSim.

Exemplo de comandos no terminal ModelSim:

```bash
vcom cronometro.vhd
vcom tb_cronometro.vhd
vsim work.tb_cronometro
add wave *
run 1000 us

