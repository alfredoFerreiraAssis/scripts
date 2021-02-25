#!/bin/bash
##############################################
#Alfredo Ferreira de Assis                   #
#Script para ver algumas informações do host #
#                                            #
##############################################

KERNEL=$(uname -r)
HOSTNAME=$(hostname)
CPUMODEL=$(cat /proc/cpuinfo |grep "model name"| head -n1| cut -c14-)
CPUNO=$(cat /proc/cpuinfo |grep "model name"| wc -l)
MEMTOTAL=$(expr $(cat /proc/meminfo |grep MemTotal |tr -d ' '|cut -d: -f2| tr -d kB) / 1024) # Em MB
UPTIME=$(uptime -s)
FILESYS=$(df -h| egrep -v '(tmpfs|udev)')
ARQ="relatorio_maquina_$HOSTNAME_$(date +%d%m%Y_%H%M).txt"


echo -e "\033[01;31m===================================================================\033[m" >$ARQ
echo "Relatório da Máquina: $HOSTNAME" >> $ARQ 
echo "Data/Hora: $(date)" >> $ARQ
echo "Relatório salvo em ./$ARQ" >> $ARQ
echo -e "\033[01;31m===================================================================\033[m" >> $ARQ
echo >> $ARQ
echo "Máquina Ativa desde: $UPTIME" >> $ARQ
echo >> $ARQ
echo "Versão do Kernerl: $KERNEL" >> $ARQ
echo >> $ARQ
echo "CPUs:" >> $ARQ
echo "Quantidade de CPUs/Core: $CPUNO" >> $ARQ
echo "Modelo da CPU: $CPUMODEL" >> $ARQ
echo >> $ARQ
echo "Memória Total: $MEMTOTAL MB" >> $ARQ
echo  >> $ARQ
echo "Partoções:" >> $ARQ
echo "$FILESYS" >> $ARQ
echo >> $ARQ
echo -e "\033[01;31m===================================================================\033[m" >> $ARQ

cat $ARQ
