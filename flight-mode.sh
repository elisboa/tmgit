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

    if [[ -n ${LAND_ERRLVL} ]]
    then
        echo "Codigo de erro: ${LAND_ERRLVL}"
    fi

    

    exit ${LAND_ERRLVL}
}

# Verificar ambiente
function fm_preflight() {

    ## Inicializar variáveis
    # variáveis relacionadas ao binário git
    # O primerio argumento passado deve ser o diretório de trabalho onde os arquivos serão versionados (/home/user, por exemplo)
    export TMGIT_TREE="${1}"
    # O segundo argumento passado deve ser o diretório ".git" do repositório 
    export TMGIT_DIR="${2}"
    # Pegando o caminho do binário do git
	TMGIT_GIT="$(command -v git 2> /dev/null)"
    export TMGIT_GIT
    # Montando os parâmetros passados para o GIT
    export TMGIT_ARGS="--git-dir ${TMGIT_DIR} --work-tree ${TMGIT_TREE}"
    # concatenando o caminho do binário do git com os argumentos passados
    TMGIT="${TMGIT_GIT} ${TMGIT_ARGS}"
    export TMGIT

    # variáveis utilizadas pelo git parametrizado (tmgit)
    # Check which branch we are
	CUR_BRANCH="DEVE ESTAR NO PADRAO DE DATA AAAA.MM.DD"
    export CUR_BRANCH

    TODAY_DATE="DEVE SER ANO.MES.DIA USANDO O COMANDO DATE, COMO EM AAAA.MM.DD"
    export TODAY_DATE

    COMMIT_DATE="DEVE SER ANO.MES.DIA.HORA.MINUTO.SEGUNDO USANDO O COMANDO DATE"
    export COMMIT_DATE
    # Force current language to C, so all git messages are in default english
    LANG="C"
    export LANG

    # Variáveis utilizadas no encerramento do programa (função fm_land)
    export LAND_ERRLVL="0"
    export LAND_MSG="DEVE CONTER UMA MENSAGEM PERSONALIZADA"
    export LAND_ERRMSG="DEVE CONTER UMA MENSAGEM DE ERRO DO PROGRAMA EXECUTADO"
    export LAND_CALLER="NOME DA FUNÇÃO QUE CHAMA A FUNÇÃO DE ENCERRAMENTO"

 
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
            let LAND_ERRLVL+=1
            LAND_ERRMSG="Uso: ${0} [diretorio a ser versionado] <diretorio de versionamento do tmgit> (opcional)"
            LAND_MSG="Numero de parametros passados: ${#}"
            # Encerrar programa enviando mensagens de erro e função chamadora
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
        fi
    fi

    # Verificar se a variável TMGIT_GIT contém algum conteúdo válido
    LAND_MSG="Verificacao do executavel do git"
    if [[ -z "${TMGIT_GIT}" ]]
    then
        let LAND_ERRLVL+=1
        LAND_ERRMSG="Arquivo executável do git não encontrado"

        # Encerrar programa enviando mensagens de erro e função chamadora
        fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}"
    else

        # Verificar se TMGIT_GIT aponta para um executável válido
        if [[ ! -x "${TMGIT_GIT}" ]]
        then
            let LAND_ERRLVL+=1
            LAND_ERRMSG="Arquivo ${TMGIT_GIT} não é executável"
            # Encerrar programa enviando mensagens de erro e função chamadora
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
        fi
    fi

    LAND_ERRLVL=0
    LAND_MSG="Git sendo executado como: ${TMGIT}"

    fm_climb "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}"
    
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}"

}

## Preparar ambiente
function fm_climb() {

    LAND_ERRLVL="$1"
    LAND_CALLER="$2"
    LAND_MSG="$3"

    # Tentando criar o diretorio onde a maquina do tempo seria versionada (o git dir)
    LAND_MSG="Verificacao do diretorio de controle do TMGIT em ${TMGIT_DIR}"
    if [[ -d "${TMGIT_TREE}" ]]
    then

        #if [[ -e "${TMGIT_TREE}/.git" ]]
        #then
        #    LAND_ERRLVL=5
        #    LAND_ERRMSG="Arquivo .git em ${TMGIT_TREE} existente"
        #    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
        #fi
        
        LAND_MSG="Inicialização do diretório ${TMGIT_TREE} tendo como diretório de controle o ${TMGIT_DIR}"
        if git init "${TMGIT_TREE}" --separate-git-dir "${TMGIT_DIR} 2>&1 > /dev/null"
        then
            LAND_ERRMSG="Diretorio ${TMGIT_DIR} inicializado com sucesso"
        else
            if [[ -e "${TMGIT_TREE}/.git" ]]  && grep ^gitdir "${TMGIT_TREE}/.git"
            then
                let LAND_ERRLVL+=1
                LAND_ERRMSG="Diretorio referenciado no arquivo ${TMGIT_TREE}/.git porem inexistente no disco"
                fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
            else
                if [[ -e "${TMGIT_TREE}"/.git ]]
                then
                    let LAND_ERRLVL+=1
                    LAND_ERRMSG="Entrada para o diretorio ${TMGIT_DIR} inexistente no arquivo ${TMGIT_TREE}/.git"
                    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
                fi
            fi
            let LAND_ERRLVL+=1
            LAND_ERRMSG="Falha ao inicializar o diretorio ${TMGIT_DIR}"
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
        fi

        LAND_MSG="Adicionando arquivo .gitignore"
        if [[ -e "${TMGIT_TREE}/.gitignore" ]]
        then
            LAND_ERRMSG="Arquivo .gitignore já encontrando"
            cat "${TMGIT_TREE}/.gitignore"
        else
            if echo "*" > "${TMGIT_TREE}/.gitignore"
            then
                LAND_ERRMSG="Adicionado arquivo .gitignore com sucesso"
            else
                let LAND_ERRLVL+=1
                LAND_ERRMSG="Falha ao adicionar arquivo .gitignore"
                fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
            fi

        fi

        # Tudo bem falhar nos comandos acima. Mas o git status não pode falhar!
        # Se ele falhar, aí sim a gente chama a função fm_land
        if git --git-dir "${TMGIT_DIR}" --work-tree "${TMGIT_TREE}" status
        then
            echo Tudo bem in the rain
        else
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
        fi
    else
        let LAND_ERRLVL+=1
        LAND_ERRMSG="Falha ao acessar diretório ${TMGIT_DIR}"
        fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}" "${LAND_ERRLVL}"
    fi

}

#
## Executar o código
function fm_fly() {

    LAND_CALLER="fm_fly"

    # Executar a verificação de mudanças
    if verifica-mudancas
    # Se der certo...
    then
        # Apaga do repositorio os arquivos já removidos do disco
        apaga-arquivos
        # Realiza o commit dos arquivos alterados
        versiona-mudancas
        # Envia as alterações para os repositórios remotos configurados
        envia-remotos
    fi
}
#

#function verifica-mudancas() {
#
#    LAND_CALLER="verifica_mudancas"
#    LAND_MSG="Verificacao de mudancas em ${TMGIT_DIR}"
#    
#
#    if ${TMGIT} status | grep 'working tree clean'
#
#}
#
#function apaga-arquivos() {
#
#
#}
#
#function versiona-mudancas () {
#
#}
#
#function envia-remotos () {
#
#
#}
