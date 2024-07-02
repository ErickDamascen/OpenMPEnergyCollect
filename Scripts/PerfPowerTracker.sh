#!/bin/bash

# Verifica se o modo de uso foi solicitado
if [ "$1" == "header" ]; then
    echo "duration(ms);energy_pkg(uJ);energy_dram(uJ);energy_core(uJ);exit_code"
    exit 0
fi

# Verifica se o número de argumentos está correto para a execução do executável
if [ "$#" -lt 2 ]; then
    echo "Modo de uso: $0 <executavel> <argumentos...>"
    echo "Ou utilize o comando "$0 header" para exibir o cabeçalho das Colunas."
    exit 1
fi

# Nome do executável (primeiro parâmetro)
EXECUTABLE="$1"

# Verifica se o executável foi fornecido com caminho completo ou com ./ no início
if [[ ! "$EXECUTABLE" =~ ^\./.* ]]; then
    echo "Aviso: É recomendável fornecer o caminho completo para o executável."
    echo "Certifique-se de incluir ./ antes do nome do executável se ele está na pasta atual."
    echo "Exemplo correto: ./myocyteClang"
    exit 1
fi

# Verifica se o executável existe e é executável
if ! [ -x "$EXECUTABLE" ]; then
    echo "Erro: Executável '$EXECUTABLE' não encontrado ou não é executável."
    exit 1
fi

# Função para coletar dados e imprimir no terminal
collect_data() {
    local application="$1"
    local input="$2"
    
    # Capturar o tempo inicial
    START_TIME=$(date +%s%3N)

    # Executar a aplicação e capturar o código de saída
    eval "$application"
    EXIT_CODE=$?

    # Capturar o tempo final
    END_TIME=$(date +%s%3N)
    DURATION=$((END_TIME - START_TIME))

    # Medir a energia durante a execução da aplicação
    ENERGY_OUTPUT=$(sudo perf stat -a -e power/energy-pkg/,power/energy-ram/,power/energy-cores/ sleep 1 2>&1)

    # Capturar os valores de energia do pacote, da RAM e do core
    ENERGY_PKG=$(echo "$ENERGY_OUTPUT" | grep 'power/energy-pkg/' | awk '{print $1}')
    ENERGY_DRAM=$(echo "$ENERGY_OUTPUT" | grep 'power/energy-ram/' | awk '{print $1}')
    ENERGY_CORE=$(echo "$ENERGY_OUTPUT" | grep 'power/energy-cores/' | awk '{print $1}')

    # Substituir vírgulas por pontos para garantir formatação correta
    ENERGY_PKG=$(echo "$ENERGY_PKG" | tr ',' '.')
    ENERGY_DRAM=$(echo "$ENERGY_DRAM" | tr ',' '.')
    ENERGY_CORE=$(echo "$ENERGY_CORE" | tr ',' '.')

    # Calcular o consumo de energia em microjoules
    if [[ $ENERGY_PKG =~ ^[0-9.]+$ ]]; then
        ENERGY_PKG=$(echo "$ENERGY_PKG * 1000000" | bc -l)
    else
        ENERGY_PKG="N/A"
    fi

    if [[ $ENERGY_DRAM =~ ^[0-9.]+$ ]]; then
        ENERGY_DRAM=$(echo "$ENERGY_DRAM * 1000000" | bc -l)
    else
        ENERGY_DRAM="N/A"
    fi

    if [[ $ENERGY_CORE =~ ^[0-9.]+$ ]]; then
        ENERGY_CORE=$(echo "$ENERGY_CORE * 1000000" | bc -l)
    else
        ENERGY_CORE="N/A"
    fi

    # Imprimir os dados coletados separados por ponto e vírgula
    echo "$DURATION;$ENERGY_PKG;$ENERGY_DRAM;$ENERGY_CORE;$EXIT_CODE"
}

# Argumentos para o executável (exceto o primeiro, que é o próprio executável)
args="${@:2}"

# Executar a coleta de dados com base nos argumentos fornecidos
application="./$EXECUTABLE $args"
collect_data "$application" "$EXECUTABLE"
