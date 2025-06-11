# Cronômetro Digital VHDL - AX301 (Quartus Prime)

## 1. Sobre o Projeto

Implementação de um **cronômetro digital** em VHDL para FPGA Cyclone IV (EP4CE6E22C8N), utilizando três displays de 7 segmentos multiplexados, botão start/stop com debounce e entrada de reset.

---

## 2. Estrutura dos Arquivos

- `cronometro.vhd`
- (Outros arquivos: `.qpf`, `.qsf`, etc.)

---

## 3. Requisitos

- **Quartus Prime** (recomenda-se versão Lite)
- **Placa AX301** (Cyclone IV EP4CE6E22C8N)
- **Cabo USB-Blaster** instalado

---

## 4. Abrindo o Projeto

1. **Extraia** os arquivos do projeto para uma pasta de fácil acesso, exemplo:  
   `C:\Projetos_FPGA\cronometro`
2. Abra o **Quartus Prime**.
3. Se existir, abra o projeto pelo arquivo `.qpf` via **File > Open Project...**.
4. Caso não exista, crie um novo projeto e adicione `cronometro.vhd` como Top Level Entity.
5. Defina o dispositivo:  
   - **Family:** Cyclone IV E  
   - **Device:** EP4CE6E22C8N

---

## 5. Pin Planner (Atribuição dos Pinos)

| Sinal           | Direção | Descrição                  | Pino Sugerido*    |
|-----------------|---------|----------------------------|-------------------|
| clk             | in      | Clock 50MHz da placa       | PIN_23            |
| rst             | in      | Reset (ativo baixo)        | PIN_57            |
| btn_debounced   | in      | Botão Start/Stop           | PIN_41            |
| display[6..0]   | out     | Segmentos A-G dos displays | PIN_91–PIN_97     |
| anode[2..0]     | out     | Seleção dos displays       | PIN_61–PIN_63     |

> **Atenção:** Os pinos acima são **exemplos**. Sempre confira o manual da AX301 para os pinos físicos corretos de cada recurso.

#### Como atribuir no Pin Planner:

1. No Quartus, vá em **Assignments > Pin Planner**.
2. Localize os sinais do seu projeto.
3. Preencha a coluna `Location` conforme a tabela acima ou de acordo com o manual da placa.
4. Salve e feche o Pin Planner.

---

## 6. Compilando o Projeto

1. Clique em **Compile** (raio amarelo ou menu Processing > Start Compilation).
2. Aguarde o término da compilação.
3. Verifique se não houve erros.
4. O arquivo `.sof` será gerado na pasta `output_files/`.

---

## 7. Gravação na Placa

1. Conecte a **AX301** via USB-Blaster ao PC.
2. Abra **Tools > Programmer** no Quartus.
3. Clique em **Hardware Setup...** e selecione `USB-Blaster`.
4. Clique em **Add File...** e selecione o `.sof` do seu projeto.
5. Marque **Program/Configure**.
6. Clique em **Start** e aguarde finalizar.

---

## 8. Testando

- O cronômetro deve iniciar parado.
- Use o botão conectado a `btn_debounced` para **start/stop**.
- Use o botão de reset (`rst`, ativo baixo) para zerar.
- Os displays mostram minutos (1 dígito) e segundos (2 dígitos).

---

## 9. Dicas & Problemas Comuns

- Se o display não acender, revise os pinos.
- Confirme se o clock é de 50MHz.
- O botão deve ter debouncing correto (hardware/software).
- Verifique se o display é ânodo/cátodo comum (ajuste a lógica do código se necessário).

---

## 10. Recursos Úteis

- [Manual da AX301](https://www.eimodule.com/download/AX301_UserManual.pdf)
- [Pinagem Cyclone IV EP4CE6E22C8N](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/dp/cyclone-iv/ep4ce6.pdf)

---

### Exemplo de Pin Assignment (`.qsf`):

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
