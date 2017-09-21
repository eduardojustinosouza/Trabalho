#! /bin/bash

clear

echo
echo "############################################### ATENCAO ######################################################"
echo "##### Este script foi desenvolvido para alterar a senha Root de todos os servidores dos servidores Linux #####"
echo "##############################################################################################################"
echo
echo "---------------------------------------------------"
echo "----- Aperte Enter para começar o Q para sai -----"
echo "---------------------------------------------------"
echo

echo -e ": \c"
read key

if [ "$key" = '' ]
	then
	
		echo -e "Insira a senha atual do Root dos servidores Linux: \c"
		read PASS_OLD

		echo -e "Insira a nova senha Root dos servidores Linux: \c"
		read SENHA

		echo -e "Insira novamente a nova senha Root dos servidores Linux: \c"
		read SENHA2


	if [ $SENHA == $SENHA2 ]
	then
			echo
			echo "Senha correta. Continuando o script"
			sleep 1
			PASS_NEW=$SENHA

			echo
			echo "----------------------------------------------"
			echo "--- Foi enviado um e-mail com as senhas ------"
			echo "----------------------------------------------"
			echo "-    Esta mensagem tem como objetivo informar     -"
			echo "-    aos colegas as novas credenciais e tambem    -"
			echo "- manter as informacoes guardadas de forma segura -"
			echo "---------------------------------------------------"
			echo
			sleep 1.5

			sendEmail -f admnet@sc.senai.br -t eduardo.j.souza@fiesc.com.br -u "[TESTE] Rotina de troca de senha Root dos servidores Linux da SEDE" -m "A senha Root dos servidores Linux da SEDE foi alterada de $PASS_OLD para $PASS_NEW\!" -s mail.app.fiesc.com.br:587 > /dev/null 2>&1 

			echo "O e-mail foi entregue para os destinatarios? Voce deve continuar o script somente se o e-mail chegar na caixa de entrada"
			echo -e "Digite YES para continuar ou NO para sair: \c"
			read CONFIRMACAO_EMAIL
				if [ $CONFIRMACAO_EMAIL == YES ]
				then
					
			                # Limpa logs do arquivo resultado.log"
			               	echo "" > /tmp/resultado.log
					echo "" > resultado.log
					
					clear

					echo "###########################################################"
					echo "### Vamos comecar a troca de senha dos servidores Linux ###"
					echo "###########################################################"
					sleep 1.5
					echo
					
					TOTAL=`cat lista |wc -l`
					echo
					echo -e "O Total de servidor(es) da lista: $TOTAL"
					echo

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
				
				echo "" > senhas.log
				echo -ne "-------------------------------------------------------------\n" >> senhas.log
				echo -ne "A senha antiga que voce digitou foi: $PASS_OLD\n" >> senhas.log
				echo -ne "A senha nova que voce digitou foi: $PASS_NEW\n" >> senhas.log
				echo -ne "-------------------------------------------------------------\n" >> senhas.log
				echo -ne "\n" >> senhas.log
				
				PASS_ZIP=1
				while [[ $PASS_ZIP -ne 0 ]]; do
					
					echo	
					echo -e "Insira uma senha para salvar o arquivo de senha em um arquivo zip criptografado: \c"
					read PASS_FILE1
	                                echo -e "Confirme a senha do arquivo zip criptografado: \c"
					read PASS_FILE2
					
					echo
						if [ "$PASS_FILE1" == "$PASS_FILE2" ];then
						PASS_ZIP=$?
						break
						else
						echo "Senha errada, tente novamente"
						fi
					done
													
				zip -e -r --password "$PASS_FILE2" senhas.zip senhas.log > /dev/null 2>&1
				chown root:root senhas.zip
				chmod 700 senhas.zip

				if [ -d "diretorio_senhas" ]
				then
					mv senhas.zip diretorio_senhas/senhas`date +%m-%d-%y`.zip
					rm -f senhas.log
					
				
				else 
				
					mkdir diretorio_senhas
					mv senhas.zip diretorio_senhas/senhas`date +%m-%d-%y`.zip
					rm -f senhas.log

				fi 
				
				echo	
				echo -e "digite o e-mail que ira receber o resulta da troca de senha nos servidores Linux: \c"
				read RESULT


				sendEmail -f admnet@sc.senai.br -t $RESULT -u "[TESTE] Rotina de troca de senha Root dos servidores Linux da SEDE" -m "Anexo a lista do resultado a troca de senha dos servidores Linux. A senha do arquivo senhas.zip eh $PASS_FILE2" -a resultado.log -s mail.app.fiesc.com.br:587 > /dev/null 2>&1

                                echo
				echo "O script foi concluido. Veja o arquivo resultado.log"
				


		else
			echo "E-mail nao foi entregue, Saindo do script"
			sleep 2

		fi

	else
		echo
		echo "Senha nao confere com a primeira senha"
		echo "Saindo do script"
		sleep 1
	fi

else
	echo "...Saindo do script"
	sleep 2
fi
echo
echo "--------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------"
