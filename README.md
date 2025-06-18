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

| Arquivo             | Função                                  |
|---------------------|-----------------------------------------|
| `cronometro.vhd`    | Código fonte do cronômetro             |
| `tb_cronometro.vhd` | Testbench para simulação               |
| `cronometro.qsf`    | Mapeamento de pinos (Pin Assignments)  |
| `cronometro.sdc`    | Restrições de tempo (Clock Constraint) |

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

1. **File → New → VHDL File → OK**.
2. C
