function commit-files {

  LAND_CALLER="${LAND_CALLER} -> commit-files"

  LAND_MSG="Iniciando commit das mudanças às ${COMMIT_DATE}"
  if $TMGIT commit -a -m "$($TMGIT diff HEAD --name-only | xargs ; echo -e "\n") Commit automático realizado às ${COMMIT_DATE}" >& /dev/null
  then
    LAND_ERRMSG="Mudanças commitadas com sucesso"
  else
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Não foi possível commitar as mudanças"
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi
}

function tag-commit() {

  LAND_CALLER="${LAND_CALLER} -> tag-commit"

  LAND_MSG="Iniciando tagging do commit às ${COMMIT_DATE}"
  if $TMGIT tag "${COMMIT_DATE}" >& /dev/null
  then
    LAND_ERRMSG="Tag ${COMMIT_DATE} aplicada com sucesso"
  else
    ((LAND_ERRLVL++))
    LAND_ERRMSG="Não foi possível aplicar a tag ${COMMIT_DATE}"
    fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi

}

function push-remote() {

  LAND_CALLER="${LAND_CALLER} -> push-remote"

  LAND_MSG="Iniciando git-push às ${COMMIT_DATE}"
  echo $LAND_MSG
  echo TMGIT vale $TMGIT
  $TMGIT remote -v
  for repo in $(${TMGIT} remote | xargs)
  do
    if timeout 30 $TMGIT push "${repo}" -u --all --follow-tags  # >& /dev/null
    then
      LAND_ERRMSG="Push efetuado com sucesso para o repositório remoto $repo"
      echo $LAND_MSG
    else
      ((LAND_ERRLVL++))
      LAND_ERRMSG="Não foi possível enviar as mudanças para o repositório remoto $repo"
      echo $LAND_ERRMSG
      #fm_land "${LAND_ERRLVL}" "${LAND_CALLER}" "${LAND_MSG}" "${LAND_ERRMSG}"
  fi
  done

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
