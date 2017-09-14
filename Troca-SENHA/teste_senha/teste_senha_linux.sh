#! /bin/bash

clear

echo -e "Aperte Enter para começar ou q para sair: \c"
read key

if [ "$key" = '' ]
then
echo
echo -e "...Limpando logs do arquivo resultado.log"
sleep 1
echo

echo "" > /tmp/resultado.log

echo -e "Insira a senha atual do Root dos servidores Linux: \c"
read PASS_OLD

TOTAL=`cat lista |wc -l`
echo
echo -e "O Total de servidor(es) da lista: $TOTAL"

echo
echo "...Iniciando o processo"
sleep 1.5
echo

for SERVER in `cat lista`
do
	sshpass -p "$PASS_OLD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 root@$SERVER -C "exit" 2>/dev/null	
	
	if [ $? -eq 0  ]
	then
		echo "[OK]: Autenticacao passou no servidor: $SERVER" >> /tmp/resultado.log
		TOTAL=$(($TOTAL-1))
		echo -e "Falta(m) $TOTAL servidor(es) para concluir o processo"
		sleep 0.5

	else 
		echo "[FALHA]: Autenticao falhou no servidor: $SERVER" >> /tmp/resultado.log
		TOTAL=$(($TOTAL-1))
		echo "Falta(m) $TOTAL servidor(es) para concluir o processo"
		sleep 0.5

	fi
	

done

sort /tmp/resultado.log > ./resultado.log
rm -f /tmp/resultado.log

echo
echo "O script foi concluido. Veja o arquivo resultado.log"

else
	echo "...Sando do script"
	sleep 2

fi

echo ""
echo "--------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------"
