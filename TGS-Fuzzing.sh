#!/bin/bash

echo -e ""
echo -e "          _____ ____ ____    _____ _   _ _____________ _   _  ____ 
         |_   _/ ___/ ___|  |  ___| | | |__  /__  /_ _| \ | |/ ___|
           | || |  _\___ \  | |_  | | | | / /  / / | ||  \| | |  _ 
           | || |_| |___) | |  _| | |_| |/ /_ / /_ | || |\  | |_| |
           |_| \____|____/  |_|    \___//____/____|___|_| \_|\____|"
echo -e ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '_'
echo -e ""           


# Função para uso correto
usage() {
  echo "Modo de uso: $0 -w <wordlist> -u <url>"
  exit 1
}

# Verifica os parâmetros usando getopts
while getopts ":w:u:" opt; do
  case ${opt} in
    w )
      wordlist=$OPTARG
      ;;
    u )
      url=$OPTARG
      ;;
    \? )
      echo "Opção inválida: $OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Opção '-$OPTARG' requer um argumento." 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Verifica se os parâmetros foram fornecidos
if [ -z "$wordlist" ] || [ -z "$url" ]; then
  usage
fi

# Verifica se a wordlist existe
if [[ ! -f $wordlist ]]; then
  echo -e "\033[0;31m[ERRO]\033[0m Wordlist não encontrada: $wordlist"
  exit 1
fi

# Verifica se a URL é válida
if [[ ! $url =~ ^https?:// ]]; then
  echo -e "\033[0;31m[ERRO]\033[0m URL inválida: $url"
  exit 1
fi

echo -e "Buscando diretórios em \033[0;33m$url\033[0m ..."
echo -e ""

# Faz o fuzzing dos diretórios
while IFS= read -r palavra; do
  resposta=$(curl -s -A "Mozilla/5.0" -o /dev/null -w "%{http_code}" "$url/$palavra")


  if [ "$resposta" = "200" ]; then
    echo -e "\033[0;32m[*]\033[0m Diretório encontrado -> \033[0;36m$url/$palavra\033[0m"
  elif [ "$resposta" = "403" ]; then
    echo -e "\033[0;33m[!]\033[0m Acesso negado -> \033[0;36m$url/$palavra\033[0m (403)"
  elif [ "$resposta" = "301" ]; then
    echo -e "\033[0;34m[>]\033[0m Redirecionamento -> \033[0;36m$url/$palavra\033[0m (301)"
  fi
done < "$wordlist"

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '_'
echo -e ""
echo -e "\033[0;32m[COMPLETO]\033[0m Fuzzing finalizado!"
