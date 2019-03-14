# Reset the firewall
iptables -P INPUT   ACCEPT
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT
#Fulus de la tabla and remove all chains
iptables -F
iptables -X

# Set policy (Que hacer al llegar al final de la cadena si los paquetes no tienen nigun match)
iptables -P INPUT   DROP
iptables -P OUTPUT  DROP
iptables -P FORWARD DROP

# Drop everything invalid
iptables -A INPUT -m state --state INVALID -j DROP

# Config ssh for vagrant and loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT  -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISH,RELATED -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 22 -m conntrack --ctstate ESTABLISH,RELATED -j ACCEPT

# Config INPUT for POSTGRES server
iptables -A INPUT -p tcp --sport 5432 -j ACCEPT

# Config OUTPUT for POSTGRES access
iptables -A OUTPUT -p tcp --dport 5432 -j ACCEPT