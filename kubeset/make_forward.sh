#!/bin/bash -ex
nodeip=$1
setiptables() {
    proto=$1
    port=$2
    nodeport=$3
    iptables -A DOCKER ! -s ${nodeip} -d ${nodeip} -p ${proto} -m ${proto} --dport ${nodeport} -j ACCEPT
    iptables -t nat -A DOCKER ! -s ${nodeip}/16 -p ${proto} -m ${proto} --dport ${port} -j DNAT --to-destination ${nodeip}:${nodeport}
    iptables -t nat -A POSTROUTING -s ${nodeip} -d ${nodeip} -p ${proto} -m ${proto} --dport ${port} -j MASQUERADE
}

iptables-save > iptables_old.txt
setiptables ${proto} 53 30001
setiptables ${proto} 465 30002
setiptables ${proto} 25 30003
setiptables ${proto} 993 30004
iptables-save > iptables_new.txt
