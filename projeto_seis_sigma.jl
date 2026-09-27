using Statistics, Plots, DataFrames, GLM

# ── 1. Dados simulados do processo ──
volumes = [
    501.2, 498.7, 502.1, 499.5, 500.3, 503.0, 497.8, 500.5, 501.0, 499.0,
    502.5, 498.0, 500.8, 501.5, 499.2, 500.0, 501.1, 498.9, 500.6, 502.2
]

println("Média original: $(round(mean(volumes), digits=2)) ml")
println("Desvio padrão original: $(round(std(volumes), digits=3)) ml")

# Histograma original
histogram(
    volumes,
    bins=10,
    title="Distribuição do Volume Envasado (Antes)",
    xlabel="Volume (ml)",
    ylabel="Frequência",
    legend=false,
    fillalpha=0.7
)
savefig("hist_before.png")

# ── 2. Dados de processo e regressão linear ──
df = DataFrame(
    volume = volumes,
    pressao = [
        3.1, 2.9, 3.2, 3.0, 3.1, 3.3, 2.8, 3.1, 3.2, 3.0,
        3.3, 2.9, 3.1, 3.2, 3.0, 3.1, 3.2, 2.9, 3.1, 3.3
    ],
    temperatura = [
        22.1, 21.9, 22.3, 22.0, 22.2, 22.5, 21.8, 22.1, 22.3, 22.0,
        22.4, 21.9, 22.2, 22.3, 22.0, 22.1, 22.3, 21.9, 22.2, 22.4
    ]
)

model = lm(@formula(volume ~ pressao + temperatura), df)
println("\nModelo de regressão (volume ~ pressao + temperatura):")
println(model)

# Extrair coeficiente da pressão
beta_pressao = coef(model)[2]  # [intercepto, pressao, temperatura]

# ── 3. Simulação de melhoria (ajuste da pressão) ──
pressao_alvo = 3.1
pressao_ajustada = fill(pressao_alvo, length(volumes))

# Ajuste do volume com base no coeficiente da pressão
volumes_ajustados = volumes .+ (pressao_alvo .- df.pressao) .* beta_pressao

println("\nMédia após ajuste: $(round(mean(volumes_ajustados), digits=2)) ml")
println("Desvio padrão após ajuste: $(round(std(volumes_ajustados), digits=3)) ml")

# Histograma comparativo (antes x depois)
histogram(
    volumes,
    bins=10,
    title="Distribuição do Volume Envasado (Antes x Depois)",
    xlabel="Volume (ml)",
    ylabel="Frequência",
    label="Antes",
    fillalpha=0.6,
    legend=:topleft
)
histogram!(
    volumes_ajustados,
    bins=10,
    fillalpha=0.5,
    label="Depois",
    color=:orange
)
savefig("hist_compare.png")

# ── 4. Gráfico de controle X-bar (função personalizada) ──
function xbar_plot(data; subgroup_size=5, filename="xbar_chart.png")
    n = length(data)
    # Garantir que há subgrupos completos
    n_sub = n ÷ subgroup_size
    subgroups = [data[(i-1)*subgroup_size .+ (1:subgroup_size)] for i in 1:n_sub]
    if n % subgroup_size != 0
        # Adiciona o último subgrupo incompleto (opcional)
        push!(subgroups, data[n_sub*subgroup_size+1:end])
    end
    means = [mean(sub) for sub in subgroups]
    overall_mean = mean(means)
    r = [maximum(sub) - minimum(sub) for sub in subgroups]
    avg_r = mean(r)

    # Constantes d2 para subgroup_size (aproximadas)
    d2_dict = Dict(2=>1.128, 3=>1.693, 4=>2.059, 5=>2.326, 6=>2.534, 7=>2.704, 8=>2.847, 9=>2.970, 10=>3.078)
    d2 = get(d2_dict, subgroup_size, 2.326) # default para 5

    sigma = avg_r / d2
    LCL = overall_mean - 3 * sigma / sqrt(subgroup_size)
    UCL = overall_mean + 3 * sigma / sqrt(subgroup_size)

    p = plot(
        means,
        seriestype=:scatter,
        markershape=:circle,
        markerstrokewidth=0,
        color=:blue,
        label="Médias dos subgrupos",
        title="Gráfico de Controle X-bar",
        xlabel="Subgrupo",
        ylabel="Média do subgrupo",
        legend=:topright,
        grid=true
    )
    hline!(
        [overall_mean],
        linestyle=:dash,
        color=:black,
        linewidth=2,
        label="Média geral"
    )
    hline!(
        [LCL],
        linestyle=:dot,
        color=:red,
        linewidth=1.5,
        label="LCL ($(round(LCL, digits=2)))"
    )
    hline!(
        [UCL],
        linestyle=:dot,
        color=:red,
        linewidth=1.5,
        label="UCL ($(round(UCL, digits=2)))"
    )
    annotate!(
        1.0, overall_mean + (UCL - LCL)*0.05,
        text("LCL=$(round(LCL,digits=2))  —  Média=$(round(overall_mean,digits=2))  —  UCL=$(round(UCL,digits=2))", :left, 8)
    )
    savefig(filename)
    return p
end

# Gerar gráfico de controle para volumes ajustados
xbar_plot(volumes_ajustados, subgroup_size=5, filename="xbar_chart.png")

println("\n✅ Gráficos salvos como:")
println("   hist_before.png")
println("   hist_compare.png")
println("   xbar_chart.png")

