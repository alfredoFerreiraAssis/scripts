#!/bin/bash

#####################################################################
# Alfredo Ferreira de Assis                                         #
# 15/01/2020                                                        #
# script para fazer backup                                          #
#                                                                   #
#####################################################################

DIRDESTINO=/home/user/backup  #mudar diretório de destino

if [ ! -d $DIRDESTINO ]
then
    echo "Criando Diretório $DIRDESTINO..."
    mkdir -p $DIRDESTINO
fi

DAYS7=$(find $DIRDESTINO -ctime -7 -name backup\*tgz) # -ctime 7 busca 
#arquivos criados nos ultimos 7 dias

if [ "$DAYS7" ] # testa se avariavel é nula
then
    echo "Já foi gerado um backup nos últimos 7 dias."
    echo -n "Deseja continuas? (N/s): "
    read -n1 CONT
    echo
    if [ "$CONT" = N -o "$CONT" = n -o "$CONT" = "" ]
    then
        echo "Backup Abortado!"
        exit 1
    elif [ $CONT = S -o $CONT = s ]
    then 
        echo "Será criado mais um backup para a mesma semana"
    else 
        echo "Opção Inválida!"
        exit 2
    fi
fi

echo "Criando Backup..."
ARQ="backup_$(date +%d%m%Y%H%M).tgz"
tar -czvpf $DIRDESTINO/$ARQ --absolute-names  /home/EXEMPLO/* > /dev/null #mudar diretório de backup

echo
echo "O backup de nome \""$ARQ"\" foi criado em $DIRDESTINO no dia `date`"
echo 
echo "Backup Concluído"


