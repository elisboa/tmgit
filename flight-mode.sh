# Verificar ambiente
function fm_preflight() {

    ## Inicializar variáveis
    # variáveis relacionadas ao binário git
    TMGIT_DIR="${1}"
    TMGIT_TREE="${2}"
	TMGIT_GIT="$(which git)"
    TMGIT_ARGS="--git-dir ${TMGIT_DIR}/.dotfiles/.git --work-tree ${TMGIT_TREE}"
    TMGIT="${TMGIT_GIT} ${TMGIT_ARGS}"

    # variáveis utilizadas pelo git parametrizado (tmgit)
    # Check which branch we are
	CUR_BRANCH="IT SHOULD BE A PATTERN OF YYYY.MM.DD"
    TODAY_DATE="MUST BE YEAR.MONTH.DAY USING DATE COMMAND"
    COMMIT_DATE="SHOULD BE YEAR.MONTH.DAY.HOUR.MINUTE.SECOND USING DATE COMMAND"
    # Force current language to C, so all git messages are in default english
    LANG="C"

    # Variáveis utilizadas no encerramento do programa (função fm_land)
    LAND_MSG="DEVE CONTER UMA MENSAGEM DE ERRO PERSONALIZADA"
    LAND_ERRMSG="DEVE CONTER A MSG DE ERRO DO PROGRAMA EXECUTADO"
    LAND_CALLER="NOME DA FUNÇÃO QUE CHAMA A FUNÇÃO DE ENCERRAMENTO"


    # debug
#    shift
#    echo "Mostrando todos os argumentos passados"
#    echo "$@"
#    echo "Número de argumentos passados"
#    echo "$#"

    LAND_CALLER="fm_preflight"

    ## Iniciar verificações de ambiente
    # Verificar argumentos passados
    if [[ ${#} -lt 2 ]]
    then
        LAND_ERRMSG="${#}"
        LAND_MSG="Número de argumentos insuficiente, pois menor que 2"
        
        # Encerrar programa enviando mensagens de erro e função chamadora
        fm_land "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    fi


    # Verificar se a variável TMGIT_GIT contém algum conteúdo válido
    if [[ -z "${TMGIT_GIT}" ]]
    then
        LAND_MSG="Arquivo executável do git não encontrado"

        # Encerrar programa enviando mensagens de erro e função chamadora
        fm_land "${LAND_CALLER}" "${LAND_MSG}"
    else

        # Verificar se TMGIT_GIT aponta para um executável válido
        if [[ ! -x "${TMGIT_GIT}" ]]
        then
            LAND_MSG="Arquivo ${TMGIT_GIT} não é executável"

            # Encerrar programa enviando mensagens de erro e função chamadora
            fm_land "${LAND_CALLER}" "${LAND_MSG}"
        fi
fi
    
    
}

## Preparar ambiente
#function fm_climb() {
#
#}
#
## Executar o código
#function fm_fly() {
#
#}
#

# Encerrar operações
function fm_land() {
    # Esperados 3 argumentos, 2 obrigatórios: 
    # 1. Função chamadora
    # 2. Mensagem de encerramento
    # 3. Mensagem de erro (opcional)

    LAND_CALLER="${1}"
    LAND_MSG="${2}"
    LAND_ERRMSG="${3}"

    echo "Iniciando aterrissagem chamada por ${LAND_CALLER}"
    echo "Encerrando programa: ${LAND_MSG}"
    echo "Mensagem de erro: ${LAND_ERRMSG}"

    exit
}
