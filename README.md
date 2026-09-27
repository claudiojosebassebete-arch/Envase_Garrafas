# Envase_Garrafas

Projeto em Julia para análise e melhoria de um processo de envasamento de garrafas, com foco em controle estatístico de processo (SPC) e regressão linear.

## Visão geral

Este projeto simula volumes de líquidos envasados em garrafas, analisa a relação entre volume, pressão e temperatura, e demonstra como ajustes no processo podem reduzir variabilidade. O script gera gráficos de distribuição e de controle para auxiliar na interpretação de desempenho e estabilidade do processo.

## Objetivo

- Avaliar a variabilidade do volume preenchido;
- Identificar fatores que influenciam o volume final;
- Modelar o processo com regressão linear múltipla;
- Simular uma melhoria do processo ajustando a pressão;
- Gerar gráficos de controle do tipo X-bar para monitoramento.

## Tecnologias utilizadas

- Julia
- `Statistics`
- `Plots`
- `DataFrames`
- `GLM`

## Estrutura do projeto

- `projeto_seis_sigma.jl` — script principal com simulação, modelagem e geração de gráficos;
- `hist_before.png` — histograma do processo antes da melhoria;
- `hist_compare.png` — comparação antes e depois;
- `xbar_chart.png` — gráfico de controle X-bar.

## Como executar

1. Certifique-se de ter o Julia instalado.
2. Abra um terminal no diretório do projeto.
3. Instale as dependências necessárias:

```julia
using Pkg
Pkg.add(["Plots", "DataFrames", "GLM"])
```

4. Execute o script:

```bash
julia projeto_seis_sigma.jl
```

## O que o script faz

### 1. Simulação dos dados
O código gera uma amostra de volumes envasados e calcula:

- média;
- desvio padrão;
- distribuição em histograma.

### 2. Regressão linear
O script monta um DataFrame com as variáveis:

- `volume`
- `pressao`
- `temperatura`

Em seguida, ajusta um modelo linear:

```julia
model = lm(@formula(volume ~ pressao + temperatura), df)
```

Esse modelo permite quantificar a influência da pressão e da temperatura sobre o volume final.

### 3. Ajuste de processo
A partir do coeficiente estimado da pressão, o script simula uma melhoria do processo ajustando a pressão de referência para um valor alvo e recalculando os volumes esperados.

### 4. Gráficos gerados
O projeto produz:

- histograma antes da melhoria;
- comparação antes x depois;
- gráfico de controle X-bar com limites de controle.

## Interpretação dos resultados

A análise busca verificar se o ajuste do processo reduz a dispersão dos volumes e melhora a estabilidade operacional. Em contextos de qualidade e Six Sigma, isso representa uma forma prática de reduzir variação e aumentar a consistência do envasamento.

## Observações

Este é um exemplo didático e simulado, voltado para demonstração de conceitos de controle estatístico e melhoria de processo. Os dados podem ser substituídos por dados reais do ambiente de produção para análise operacional mais precisa.

## Licença

Este projeto está disponível como exemplo aberto para fins educacionais e de estudo.

## Autor

Projeto desenvolvido em Julia para aplicação de conceitos de qualidade, regressão e controle de processo.
