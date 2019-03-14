PROBAR FUNCIONAMIENTO DE DMZ (RED PRIVADA 192.168.0.0/24) Y RED PUBLICA 191.168.0.0/24
1)ssh vagrant@192.168.0.20 desde PC
2)curl google.com desde ROUTER/CLOCKSERVER
3)curl 192.168.0.10:80/Cloud-basedClock/Relojv3/cliente/cliente.html O curl 192.168.0.10:80 desde ROUTER/CLOCKSERVER
4)curl 192.168.0.10:80/Cloud-basedClock/Relojv3/cliente/cliente.html O curl 192.168.0.10:80 desde PC

COMANDOS TROUBLESHOOTING:
*show iptables nat rules: sudo iptables -t nat -L -n -V
*show iptables nat rules with number of the rule: sudo iptables -t nat -L -n -V --line-number
*show route table: sudo route -n
*Delete specific rule tables nat: sudo iptables -t nat PREROUTING/POSTROUTING/INPUT/OUTPUT # 

PASSWORD:vagrant Y USERNAME:vagrant TODAS LAS MAQUINA VAGRANT POR DEFAULT 