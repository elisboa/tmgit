# Verificar ambiente
function fm_preflight() {

    ## Inicializar variáveis
    # variáveis relacionadas ao binário git
    # O primerio argumento passado deve ser o diretório de trabalho onde os arquivos serão versionados (/home/user, por exemplo)
    TMGIT_TREE="${1}"
    # O segundo argumento passado deve ser o diretório ".git" do repositório 
    TMGIT_DIR="${2}"
    # Pegando o caminho do binário do git
	TMGIT_GIT="$(which git)"
    # Montando os parâmetros passados para o GIT
    TMGIT_ARGS="--git-dir ${TMGIT_DIR} --work-tree ${TMGIT_TREE}"
    # concatenando o caminho do binário do git com os argumentos passados
    TMGIT="${TMGIT_GIT} ${TMGIT_ARGS}"

    # variáveis utilizadas pelo git parametrizado (tmgit)
    # Check which branch we are
	CUR_BRANCH="IT SHOULD BE A PATTERN LIKE YYYY.MM.DD"
    TODAY_DATE="MUST BE YEAR.MONTH.DAY USING DATE COMMAND, LIKE YYYY.MM.DD"
    COMMIT_DATE="SHOULD BE YEAR.MONTH.DAY.HOUR.MINUTE.SECOND USING DATE COMMAND"
    # Force current language to C, so all git messages are in default english
    LANG="C"

    # Variáveis utilizadas no encerramento do programa (função fm_land)
    LAND_ERRLVL="0"
    LAND_MSG="DEVE CONTER UMA MENSAGEM PERSONALIZADA"
    LAND_ERRMSG="DEVE CONTER UMA MENSAGEM DE ERRO DO PROGRAMA EXECUTADO"
    LAND_CALLER="NOME DA FUNÇÃO QUE CHAMA A FUNÇÃO DE ENCERRAMENTO"

 
#    debug
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
        if [[ ${#} -eq 1 ]]
        then
            TMGIT_DIR="${TMGIT_TREE}/.tmgit"
        else
            LAND_ERRLVL=1
            LAND_ERRMSG="Numero de argumentos inferior a 1"
            LAND_MSG="Verificando parametros"
            # Encerrar programa enviando mensagens de erro e função chamadora
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
        fi
    fi


    # Verificar se a variável TMGIT_GIT contém algum conteúdo válido
    LAND_MSG="Verificacao do executavel do git"
    if [[ -z "${TMGIT_GIT}" ]]
    then
        LAND_ERRLVL=2
        LAND_ERRMSG="Arquivo executável do git não encontrado"

        # Encerrar programa enviando mensagens de erro e função chamadora
        fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}"
    else

        # Verificar se TMGIT_GIT aponta para um executável válido
        if [[ ! -x "${TMGIT_GIT}" ]]
        then
            LAND_ERRLVL=3
            LAND_ERRMSG="Arquivo ${TMGIT_GIT} não é executável"
            # Encerrar programa enviando mensagens de erro e função chamadora
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}"
        fi
fi
  
}

## Preparar ambiente
function fm_climb() {

    LAND_CALLER="fm_preflight"
    LAND_ERRLVL="0"
    
    # Tentando criar o diretorio onde a maquina do tempo seria versionada (o git dir)
    LAND_MSG="Verificacao do diretorio de controle do TMGIT em ${TMGIT_DIR}"
    if mkdir -p "${TMGIT_DIR}"
    then

        if [[ -e "${TMGIT_TREE}/.git" ]]
        then
            LAND_ERRLVL=5
            LAND_ERRMSG="Arquivo .git em ${TMGIT_TREE} existente"
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
        fi

        cd "${TMGIT_TREE}" &&\
        if git init --separate-git-dir "${TMGIT_DIR}"
        then
            LAND_ERRMSG="Diretorio ${TMGIT_DIR} inicializado com sucesso"
        else
            LAND_ERRLVL=6
            LAND_ERRMSG="Falha ao inicializar o diretorio ${TMGIT_DIR}"
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
        fi
        
        if echo "*" > "${TMGIT_DIR}/.gitignore"
        then
            LAND_ERRMSG="Adicionado arquivo .gitignore com sucesso"
        else
            LAND_ERRLVL=7
            LAND_ERRMSG="Falha ao adcionar arquivo .gitignore"
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
        fi
        
        if echo "*" > "${TMGIT_DIR}/.gitignore"
        then
            LAND_ERRMSG="Adicionado arquivo .gitignore com sucesso"
        else
            LAND_ERRLVL=8
            LAND_ERRMSG="Falha ao adcionar arquivo .gitignore"
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
        fi

        git --git-dir "${TMGIT_DIR}" --work-tree "${TMGIT_TREE}" status

    else
        LAND_ERRLVL=4
        LAND_ERRMSG="Erro ao criar ${TMGIT_DIR}"
        fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    fi

}

#
## Executar o código
#function fm_fly() {
#
#}
#

# Encerrar operações
function fm_land() {
    # Esperados 4 argumentos:
    # 1. Número do código de erro (se vazio ou 0, sair com sucesso)
    LAND_ERRLVL="${1}"
    # 2. Função chamadora
    LAND_CALLER="${2}"
    # 3. Mensagem de encerramento
    LAND_MSG="${3}"
    # 4. Mensagem de erro (opcional)
    LAND_ERRMSG="${4}"


    # Exibir as mensagens abaixo APENAS se a variável contiver alguma coisa
    if [[ -n ${LAND_CALLER} ]]
    then
        echo "Iniciando aterrissagem chamada por ${LAND_CALLER}"
    fi

    if [[ -n ${LAND_MSG} ]]
    then
        echo "Encerrando programa: ${LAND_MSG}"
    fi

    if [[ -n ${LAND_ERRMSG} ]]
    then
        echo "Mensagem de erro: ${LAND_ERRMSG}"
    fi

    exit ${LAND_ERRLVL}
}
