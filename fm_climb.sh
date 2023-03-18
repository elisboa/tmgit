function init-repo() {

  LAND_CALLER="${LAND_CALLER} -> init-repo"

  LAND_MSG="Criação do diretório ${TMGIT_DIR}"
  if mkdir -p "${TMGIT_DIR}" > /dev/null 2>&1
  then
    LAND_ERRMSG="Diretório ${TMGIT_DIR} criado com sucesso"
  else
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Falha ao criar o diretório ${TMGIT_DIR}"
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi

  LAND_MSG="Inicialização do diretório ${TMGIT_TREE} tendo como diretório de controle o ${TMGIT_DIR}"
  if ${TMGIT} init > /dev/null 2>&1
  then
    LAND_ERRMSG="Diretorio ${TMGIT_DIR} inicializado com sucesso"
  else
    ((LAND_ERRLVL++))
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
      if echo "*" >> "${TMGIT_TREE}/.gitignore" 2> /dev/null
      then
        LAND_ERRMSG="Criado arquivo .gitignore com sucesso"
      else
        ((LAND_ERRLVL++))
         LAND_ERRMSG="Falha ao criar arquivo .gitignore"
         fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"    
      fi
    LAND_MSG="Versionando arquivo .gitignore"
    if ${TMGIT} add -f .gitignore > /dev/null 2>&1
    then
      LAND_ERRMSG="Arquivo .gitignore versionado com sucesso"
    else
      ((LAND_ERRLVL++))
      LAND_ERRMSG="Falha ao versionar arquivo .gitignore"
      fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"    
    fi
    else
      ((LAND_ERRLVL++))
      LAND_ERRMSG="Existe um diretorio no caminho ${TMGIT_TREE}/.gitignore e deveria ser um arquivo"
      fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    fi
  fi
}

function check-status() {

  LAND_CALLER="${LAND_CALLER} -> check-status"

  LAND_MSG="Verificando estado do repositorio"
  # Tudo bem falhar nos comandos acima. Mas o git status não pode falhar!
  # Se ele falhar, aí sim a gente chama a função fm_land
  if ${TMGIT} status > /dev/null 2>&1
  then
    LAND_ERRMSG="Repositorio OK"
  else
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Falha ao verificar estado do repositorio"
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi
}

function create-repo() {

  LAND_CALLER="${LAND_CALLER} -> create-repo"

  # Tentando criar o diretorio onde a maquina do tempo seria versionada (o git dir)
  LAND_MSG="Verificacao do diretorio a ser versionado: ${TMGIT_TREE}"
  if [[ -d "${TMGIT_TREE}" ]]
  then
        
    init-repo "$@"
    check-gitignore "$@"
    check-status "$@"
  else
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Falha ao acessar diretório ${TMGIT_DIR}"
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi
}

function create-branch() {
    
  LAND_CALLER="${LAND_CALLER} -> create-branch"

  LAND_MSG="Criacao da branch ${BRANCH_NAME}"
  if ${TMGIT} checkout -b "${BRANCH_NAME}" > /dev/null 2>&1 
  then
    LAND_ERRMSG="Branch ${BRANCH_NAME} criada com sucesso"
    ${TMGIT} commit --allow-empty -m":tada: Criada nova branch ${BRANCH_NAME}" > /dev/null 2>&1
  else
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Não foi possível criar a branch ${BRANCH_NAME}"
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi
}

function check-branch() {

  LAND_CALLER="${LAND_CALLER} -> check-branch"

  BRANCH_NAME="$(date +'%Y.%m.%d')"

  LAND_MSG="Verificacao de existencia de branch com o nome ${BRANCH_NAME}"
  if ${TMGIT} checkout "${BRANCH_NAME}" > /dev/null 2>&1 
  then
    LAND_ERRMSG="Branch alterada para ${BRANCH_NAME} com sucesso"
  else
    create-branch "$@"
  fi
}

function add-file() {

  LAND_CALLER="${LAND_CALLER} -> add-file"

  LAND_MSG="Adicionando arquivo(s) ao repositório: ${1}"
  #echo "${LAND_MSG}"
  #echo "${TMGIT}"
 
  if ${TMGIT} add -f ${1} > /dev/null 2>&1
  then
    LAND_ERRMSG="Arquivo(s) adicionado(s) com sucesso: ${1}"
  else
    LAND_ERRMSG="Falha ao adicionar arquivo(s): ${1}"
    ((LAND_ERRLVL++))
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"    
  fi

}

# Este nome precisa ser melhorado
# Esta função irá tratar todos os argumentos passados para o script inicial
function check-params () {

  LAND_CALLER="${LAND_CALLER} -> check-params"

  LAND_MSG="${#} parâmetros passados: ${*}"
  # Para cada argumento passado, vamos validar se ele se encaixa em algum dos parâmetros suportados
  for param in "${@}"
  do
    LAND_MSG="Validando parâmetro ${param}"

    # Aqui a gente valida e chama cada parâmetro válido passado
    case "${param}" in
      add-file) 
        add-file "${2}" ;;
      push-remote)
        push-remote ;;
    esac
  
    shift
  done

}

## Preparar ambiente
function fm_climb() {

  LAND_ERRLVL="$1"
  LAND_CALLER="$2"
  LAND_MSG="$3"

  LAND_CALLER="${LAND_CALLER} -> fm_climb"

  create-repo "$@"
  check-branch "$@"
  check-params ${TMGIT_PARAMS}
}
