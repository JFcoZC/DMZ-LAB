# Reset the firewall
iptables -P INPUT   ACCEPT
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT
#Fulus de la tabla and remove all chains
iptables -F
iptables -X

# Drop everything invalid
iptables -A INPUT -m state --state INVALID -j DROP

#ACCEPT LOOPBACK INPUT AND OUTPUT
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
# Config NO SSH (USE VBOX TO ACCES TO IT)

# Config INPUT for HTTP server
iptables -A INPUT -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --sport 80 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --sport 443 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Config OUTPUT for HTTP access, no ssh out connections for this machine
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 80 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 
iptables -A OUTPUT -p tcp -m tcp --sport 443 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 
iptables -A OUTPUT -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

# Set policy (Que hacer al llegar al final de la cadena si los paquetes no tienen nigun match)
iptables -P INPUT   DROP
iptables -P OUTPUT  DROP
iptables -P FORWARD DROP