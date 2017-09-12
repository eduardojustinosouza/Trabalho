#! /bin/bash

echo "Fazendo o backup do arquivo /var/named/inside/fiesc.com.br.data para o diretorio atual"
sleep 1

cp /var/named/inside/fiesc.com.br.data ./fiesc.com.br.data.bkp.`date +"%m-%d-%y"`

echo "Gerando o arquivo dos Hosts para inciciar os testes"

cat fiesc.com.br.data.bkp.`date +"%m-%d-%y"` |grep IN |awk {'print $1'} | grep -v @ |grep -v fiesc.com.br. | sed 's/.fiesc.com.br//g' | sed 's/$/.fiesc.com.br/g' > hosts


#echo "executando o script de teste dos hosts"

#sh rotina-dns.sh


