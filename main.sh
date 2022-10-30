#!/usr/bin/env bash

link='https://stc.eleicoes2022.uol.com/2022/2turno/br/br-c1.json'

get_json() {
  local -i http_code

  http_code=$(curl --write-out '%{http_code}' -s "$link" -o logs/data.json)

  (( $http_code == 200 )) && return 0 || return 1
}

get_data() {
  if get_json; then
    local file_path
    file_path='logs/data.json'

    for i in {0..1}; do
      local name
      local -i total_votes
      local percent

      name=$(jq ".ca[${i}].no" "$file_path");
      name=${name//\"/}

      total_votes=$(jq ".ca[${i}].v" "$file_path");
      total_votes=${total_votes//\"/}

      percent=$(jq ".ca[${i}].vp" "$file_path");
      percent=${percent//\"/}

      echo "$(( ++i )) - ${name}"
      echo "Total de Votos: ${total_votes}"
      echo -e "Porcentagem: ${percent}%\n"

    done

    local votes_counted

    votes_counted=$(jq '.sap' "$file_path")
    votes_counted=${votes_counted//\"/}

    echo "Votos Apurados: ${votes_counted}"

    return 0
  fi

  return 1
}

main() {
  test ! -d logs && mkdir logs

  clear

  while get_data; do
    sleep 60s
    clear
  done
}

main "$@"
