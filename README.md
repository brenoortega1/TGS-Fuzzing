# TGS-Fuzzing

Este é um software simples de fuzzing de diretórios desenvolvido em Bash. Ele faz requisições HTTP a um servidor web, utilizando uma wordlist de possíveis nomes de diretórios e arquivos, identificando aqueles que estão acessíveis (200), redirecionados (301) ou bloqueados (403).

## Modo de Uso
./TGS-Fuzzing.sh -w <wordlist> -u <url>

Parâmetros:
-w: Caminho para a wordlist com os nomes dos diretórios a serem testados.
-u: URL do site alvo 

## Exemplo de uso:
![image](https://github.com/user-attachments/assets/a85821a9-c02e-4486-9fe0-015b320320fe)
