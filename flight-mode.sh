# Verificar ambiente
function fm_preflight() {

    ## Inicializar variáveis
    # variáveis relacionadas ao binário git
    TMGIT_DIR="${1}"
    TMGIT_TREE="${2}"
	TMGIT_GIT="$(which git)"
    TMGIT_ARGS="--git-dir ${TMGIT_DIR}/.dotfiles/.git --work-tree ${TMGIT_TREE}"

    # variáveis utilizadas pelo git parametrizado (tmgit)
    # Check which branch we are
	CUR_BRANCH="IT SHOULD BE A PATTERN OF YYYY.MM.DD"
    TODAY_DATE="MUST BE YEAR.MONTH.DAY USING DATE COMMAND"
    COMMIT_DATE="SHOULD BE YEAR.MONTH.DAY.HOUR.MINUTE.SECOND USING DATE COMMAND"
    # Force current language to C, so all git messages are in default english
    LANG="C"


}

# Preparar ambiente
function fm_climb() {

}

# Executar o código
function fm_fly() {

}

# Encerrar operações
function fm_land() {

}
