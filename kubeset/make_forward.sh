#!/bin/bash -ex
interface=$1
nodeip=$2
setiptables() {
    proto=$1
    port=$2
    nodeport=$3
    iptables -I PREROUTING  -t nat -d ${interface} -p ${proto} -m ${proto} --dport ${port} -j DNAT --to-destination ${nodeip}:${nodeport}
    iptables -I POSTROUTING  -t nat  -s ${nodeip} -p ${proto} -m ${proto} --sport ${nodeport} -j SNAT --to-source :${port}
}

iptables-save > iptables_old.txt
setiptables udp 53 30001
setiptables tcp 465 30002
setiptables tcp 25 30003
setiptables tcp 993 30004
iptables-save > iptables_new.txt
