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

  LAND_CALLER="${LAND_CALLER} -> fm_land"

  # Exibir as mensagens abaixo APENAS se a variável contiver alguma coisa
  if [[ -n ${LAND_CALLER} ]]
  then
    echo "Iniciando aterrissagem chamada por ${LAND_CALLER}"
  fi

  if [[ -n ${LAND_MSG} ]]
  then
    echo "Encerramento: ${LAND_MSG}"
  fi

  if [[ -n ${LAND_ERRMSG} ]]
  then
    echo "Erro ou aviso: ${LAND_ERRMSG}"
  fi

  if [[ -n ${LAND_ERRLVL} ]]
  then
    echo "Codigo de erro: ${LAND_ERRLVL}"
  fi

  exit "${LAND_ERRLVL}"
}
