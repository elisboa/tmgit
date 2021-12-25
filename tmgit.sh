#!/bin/bash

### Arquivo main.sh
### Este é o arquivo a ser executado e que importará todos os outros
### Autor: Eduardo Lisboa <eduardo.lisboa@gmail.com>
### Site: https://github.com/elisboa

# Organizar a ordem em que as outras funções são chamadas
function main() {

    # Realizar verificações de ambiente
    fm_preflight "$@"
    
    # Preparar ambiente para a execução do programa
    fm_climb "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    
    # Realizar as operações que compreendem a lógica central do projeto
    fm_fly "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
 
    # Realizar tratamentos de erro e geração de logs
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
}

# Carregar o arquivo que abstrai as funções o modo-avião
# shellcheck source=/dev/null

for file in fm_{preflight,climb,fly,land}.sh
do
    echo -ne "Importando arquivo ${file}: "
    if source "$(dirname "${0}")/${file}" > /dev/null 2>&1
    then
        echo -e "OK"
    else
        echo -e "FALHOU\n"
        exit 1
    fi
done

main "$@"
