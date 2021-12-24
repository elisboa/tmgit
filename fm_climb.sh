function init-repo() {

    LAND_CALLER="${LAND_CALLER} -> init-repo"

    LAND_MSG="Inicialização do diretório ${TMGIT_TREE} tendo como diretório de controle o ${TMGIT_DIR}"
    if git init "${TMGIT_TREE}" --separate-git-dir "${TMGIT_DIR}" 2>&1 > /dev/null
    then
        LAND_ERRMSG="Diretorio ${TMGIT_DIR} inicializado com sucesso"
    else
        if [[ -e "${TMGIT_TREE}/.git" ]]  && grep ^gitdir "${TMGIT_TREE}/.git" 2>&1 > /dev/null
        then
            let LAND_ERRLVL+=1
            LAND_ERRMSG="Diretorio referenciado no arquivo ${TMGIT_TREE}/.git porem inexistente no disco"
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
        else
            if [[ -e "${TMGIT_TREE}"/.git ]]
            then
                let LAND_ERRLVL+=1
                LAND_ERRMSG="Entrada para o diretorio ${TMGIT_DIR} inexistente no arquivo ${TMGIT_TREE}/.git"
                fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
            fi
        fi
        let LAND_ERRLVL+=1
        LAND_ERRMSG="Falha ao inicializar o diretorio ${TMGIT_DIR}"
        fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    fi
}

function check-gitignore() {

    LAND_CALLER="${LAND_CALLER} -> check-gitignore"

    LAND_MSG="Verificando arquivo .gitignore"
    if [[ -e "${TMGIT_TREE}/.gitignore" ]] && [[ ! -d "${TMGIT_TREE}/.gitignore" ]]
    then
        LAND_ERRMSG="Arquivo .gitignore já encontrado."
    else
        if [[ ! -d "${TMGIT_TREE}/.gitignore" ]] 
        then
            if echo "*" > "${TMGIT_TREE}/.gitignore" 2> /dev/null
            then
                LAND_ERRMSG="Adicionado arquivo .gitignore com sucesso"
            else
               let LAND_ERRLVL+=1
               LAND_ERRMSG="Falha ao adicionar arquivo .gitignore"
               fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"    
            fi
        else
            let LAND_ERRLVL+=1
            LAND_ERRMSG="Existe um diretorio no caminho ${TMGIT_TREE}/gitignore e deveria ser um arquivo"
            fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
        fi
    fi
}

function check-status() {

    LAND_CALLER="${LAND_CALLER} -> check-status"

    LAND_MSG="Verificando estado do repositorio"
    # Tudo bem falhar nos comandos acima. Mas o git status não pode falhar!
    # Se ele falhar, aí sim a gente chama a função fm_land
    if git --git-dir "${TMGIT_DIR}" --work-tree "${TMGIT_TREE}" status 2>&1 > /dev/null
    then
        LAND_ERRMSG="Repositorio OK"
    else
        let LAND_ERRLVL+=1
        LAND_ERRMSG="Falha ao verificar estado do repositorio"
        fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    fi
}

function create-repo() {

    LAND_CALLER="${LAND_CALLER} -> create-repo"

    # Tentando criar o diretorio onde a maquina do tempo seria versionada (o git dir)
    LAND_MSG="Verificacao do diretorio de controle do TMGIT em ${TMGIT_DIR}"
    if [[ -d "${TMGIT_TREE}" ]]
    then
        
        init-repo "$@"
        check-gitignore "$@"
        check-status "$@"
    else
        let LAND_ERRLVL+=1
        LAND_ERRMSG="Falha ao acessar diretório ${TMGIT_DIR}"
        fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    fi
}

## Preparar ambiente
function fm_climb() {

    LAND_ERRLVL="$1"
    LAND_CALLER="$2"
    LAND_MSG="$3"

    LAND_CALLER="${LAND_CALLER} -> fm_climb"

    create-repo "$@"
}
