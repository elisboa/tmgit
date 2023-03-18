function set-vars() {

  ## Inicializar variáveis
  # variáveis relacionadas ao binário git
  # O primerio argumento passado deve ser o diretório de trabalho onde os arquivos serão versionados (/home/user, por exemplo)
  export TMGIT_TREE="${1}"
  # O segundo argumento passado deve ser o diretório ".git" do repositório 
  export TMGIT_DIR="${TMGIT_TREE}/.tmgit/.git"
  TMGIT_GIT="$(command -v git 2> /dev/null)"
  export TMGIT_GIT
  # Montando os parâmetros passados para o GIT
  export TMGIT_ARGS="--git-dir ${TMGIT_DIR} --work-tree ${TMGIT_TREE}"
  # concatenando o caminho do binário do git com os argumentos passados
  TMGIT="${TMGIT_GIT} ${TMGIT_ARGS}"
  export TMGIT
  # Tratando o segundo argumento passado
  TMGIT_PARAMS="${*}"
  export TMGIT_PARAMS


  # variáveis utilizadas pelo git parametrizado (tmgit)
  # Check which branch we are
  CUR_BRANCH="DEVE ESTAR NO PADRAO DE DATA AAAA.MM.DD"
  export CUR_BRANCH

  TODAY_DATE="DEVE SER ANO.MES.DIA USANDO O COMANDO DATE, COMO EM AAAA.MM.DD"
  export TODAY_DATE

  COMMIT_DATE="$(date +'%Y.%m.%d-%H.%M')"
  export COMMIT_DATE
  # Force current language to C, so all git messages are in default english
  LANG="C"
  export LANG

  # Variáveis utilizadas no encerramento do programa (função fm_land)
  export LAND_ERRLVL="0"
  export LAND_MSG="DEVE CONTER UMA MENSAGEM PERSONALIZADA"
  export LAND_ERRMSG="DEVE CONTER UMA MENSAGEM DE ERRO DO PROGRAMA EXECUTADO"
  export LAND_CALLER="" # "NOME DA FUNÇÃO QUE CHAMA A FUNÇÃO DE ENCERRAMENTO"
}

function check-args () {

  LAND_CALLER="${LAND_CALLER} -> check-args"

  LAND_MSG="Numero de parametros passados: ${#}"
  ## Iniciar verificações de ambiente
  # Verificar argumentos passados
  if [[ ${#} -lt 1 ]]
  then
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Uso: ${0} [diretorio a ser versionado] <diretorio de versionamento do tmgit> (opcional)"
    # Encerrar programa enviando mensagens de erro e função chamadora
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi

  # Verificar se a variável TMGIT_GIT contém algum conteúdo válido
  LAND_MSG="Verificacao do executavel do git"
  if [[ -z "${TMGIT_GIT}" ]]
  then
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Arquivo executável do git não encontrado"

    # Encerrar programa enviando mensagens de erro e função chamadora
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}"
  else

    # Verificar se TMGIT_GIT aponta para um executável válido
    if [[ ! -x "${TMGIT_GIT}" ]]
    then
      ((LAND_ERRLVL++))
      LAND_ERRMSG="Arquivo ${TMGIT_GIT} não é executável"
      # Encerrar programa enviando mensagens de erro e função chamadora
      fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
    fi
  fi

  LAND_ERRLVL=0
  LAND_MSG="Git sendo executado como: ${TMGIT}"

}

function fm_preflight() {

  set-vars "$@"

  #    debug
  #    shift
  #    echo "Mostrando todos os argumentos passados"
  #    echo "$@"
  #    echo "Número de argumentos passados"
  #    echo "$#"

  LAND_CALLER="fm_preflight"

  check-args "$@"
}
