#!/bin/bash

### Arquivo main.sh
### Este é o arquivo a ser executado e que importará todos os outros
### Autor: Eduardo Lisboa <eduardo.lisboa@gmail.com>
### Site: https://github.com/elisboa

# Organizar a ordem em que as outras funções são chamadas
function main() {

    # Realizar verificações de ambiente
    fm_preflight $@

    # Preparar ambiente para a execução do programa
    # fm_climb $@

    # Realizar as operações que compreendem a lógica central do projeto
    # fm_fly $@

    # Realizar tratamentos de erro e geração de logs
    # fm_land $@

}

# Carregar o arquivo que abstrai as funções o modo-avião
source $(dirname ${0})/flight-mode.sh

main $@