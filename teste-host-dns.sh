#! /bin/bash

# Recomenado executar este script no servidor 10.180.202.228 (opmon), pois tem acesso a mais servidores
# Para executar este passo, deve ter gerado o arquivo hosts pelo primeiro script.

echo "" > logs

for i in `cat hosts`
do

ping -c 1 -W 1 $i > /dev/null 2>&1


if [ $? -eq 0 ] ; then
  echo "[OK]: $i" >> logs_ok
else
  echo "[FALHOU]: $i" >> logs_falhou
fi

done
