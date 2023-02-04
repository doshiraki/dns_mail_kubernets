#!/bin/bash -ex
nodeip=$1
chains=
createchain() {
    HOOK_CHAIN=$1
    CHAIN=$2
    export TABLE=$3

    if [ -n "${TABLE}" ]
    then
        TABLE="-t ${TABLE}"
    fi

    if iptables ${TABLE} -L ${CHAIN}
    then
	i=0
	iptables ${TABLE} -S ${HOOK_CHAIN} | while read line
	do
		if echo ${line} | grep ${CHAIN}
		then
		    iptables ${TABLE} -D ${HOOK_CHAIN} ${i}
		fi
		(( i=i+1 ))
	done
        iptables ${TABLE} -X ${CHAIN}
    fi
    iptables ${TABLE} -N ${CHAIN}
    iptables ${TABLE} -A ${HOOK_CHAIN} -j ${CHAIN}
    chains="${chains}iptables ${TABLE} -A ${CHAIN} -j RETURN\n"
}
setiptables() {
    proto=$1
    port=$2
    nodeport=$3
    iptables -A MY_DOCKER ! -s ${nodeip} -d ${nodeip} -p ${proto} -m ${proto} --dport ${nodeport} -j ACCEPT
    iptables -t nat -A MY_DOCKER ! -s ${nodeip}/16 -p ${proto} -m ${proto} --dport ${port} -j DNAT --to-destination ${nodeip}:${nodeport}
    iptables -t nat -A MY_POSTROUTING -s ${nodeip} -d ${nodeip} -p ${proto} -m ${proto} --dport ${port} -j MASQUERADE
}


iptables-save > iptables_old.txt

createchain DOCKER MY_DOCKER
createchain POSTROUTING MY_POSTROUTING nat
createchain DOCKER MY_DOCKER nat

setiptables udp 53 30001
setiptables tcp 465 30002
setiptables tcp 25 30003
setiptables tcp 993 30004

echo -e ${chains} | bash

iptables-save > iptables_new.txt

