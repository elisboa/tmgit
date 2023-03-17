function commit-files {

  LAND_CALLER="${LAND_CALLER} -> commit-files"

  LAND_MSG="Iniciando commit das mudanças às ${COMMIT_DATE}"
  if $TMGIT commit -a -m "$($TMGIT diff HEAD --name-only | xargs ; echo -e "\n") Commit automático realizado às ${COMMIT_DATE}" >& /dev/null
  then
    LAND_ERRMSG="Mudanças commitadas com sucesso"
  else
    let LAND_ERRLVL+=1
    LAND_ERRMSG="Não foi possível commitar as mudanças"
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi
}

function fm_fly {

  LAND_ERRLVL="$1"
  LAND_CALLER="$2"
  LAND_MSG="$3"

  LAND_CALLER="${LAND_CALLER} -> fm_fly"

  # Esses nomes precisam ser melhorados depois - pend
  commit-files
  tag-commit

}
