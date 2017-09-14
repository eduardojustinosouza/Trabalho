#! /bin/bash

clear

echo
echo "------------------------------------------------ATENCAO-------------------------------------------------------"
echo "----- Este script foi desenvolvido para alterar a senha Root de todos os servidores dos servidores Linux -----"
echo "--------------------------------------------------------------------------------------------------------------"

echo -e "Aperte Enter para começar ou q para sair: \c"
read key

echo
echo "...Fazendo o backup do arquivo resultado.log"
cp -a resultado.log resultado.log.bkp
sleep 2
echo

if [ "$key" = '' ]
then
echo	
echo -e "...Limpando logs do arquivo resultado.log"
sleep 1
echo

echo "" > /tmp/resultado.log

echo -e "Insira a senha atual do Root dos servidores Linux: \c"
read PASS_OLD

echo -e "Insira a nova senha Root dos servidores Linux: \c"
read PASS_NEW

TOTAL=`cat lista |wc -l`
echo ""
echo -e "O Total de servidor(es) da lista: $TOTAL"

echo ""
echo "...Iniciando o processo"
sleep 1.5
echo ""

for SERVER in `cat lista`
do
	sshpass -p "$PASS_OLD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 root@$SERVER -C "(echo -e root:"$PASS_NEW"|chpasswd)" 2>/dev/null	
	
	if [ $? -eq 0  ]
	then
		echo "[OK]: A senha alterada com sucesso do servidor: $SERVER" >> /tmp/resultado.log
		TOTAL=$(($TOTAL-1))
		echo -e "Falta(m) $TOTAL servidor(es) para concluir o processo"
		sleep 0.5

	else 
		echo "[FALHA]: A senha não foi alterada do servidor: $SERVER" >>/tmp/resultado.log
		TOTAL=$(($TOTAL-1))
		echo "Falta(m) $TOTAL servidor(es) para concluir o processo"
		sleep 0.5

	fi
	

done

sort /tmp/resultado.log > ./resultado.log

echo "" >> resultado.log
echo -ne "-------------------------------------------------------------\n" >> resultado.log
echo -ne "A senha antiga que voce digitou foi: $PASS_OLD\n" >> resultado.log
echo -ne "A senha nova que voce digitou foi: $PASS_NEW\n" >> resultado.log
echo -ne "-------------------------------------------------------------\n" >> resultado.log
echo -ne "\n" >> resultado.log


echo
echo "O script foi concluido. Veja o arquivo resultado.log"

else
	echo "...Sando do script"
	sleep 2

fi

echo
echo "--------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------"
