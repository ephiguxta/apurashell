#!/usr/bin/env bash

link='https://stc.eleicoes2022.uol.com/2022/1turno/br/br-c1.json'

get_json() {
  local -i http_code

  http_code=$(curl --write-out '%{http_code}' -s "$link" -o logs/data.json)

  [[ "$http_code" -eq 200 ]] && return 0 || return 1
}

get_data() {
  if get_json; then
    for i in {0..2}; do
      local name
      local -i total_votes
      local percent

      local file_path
      file_path='logs/data.json'

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
  fi
}

main() {
  test ! -d logs && mkdir logs
  get_data
}

main "$@"