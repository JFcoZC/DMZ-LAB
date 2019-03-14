# Reset the firewall
iptables -P INPUT   ACCEPT
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -X

# Set policy
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
iptables -A INPUT  -p tcp -m tcp --sport 22 -m conntrack --ctstate ESTABLISH,RELATED -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISH,RELATED -j ACCEPT

# Config INPUT for HTTP server
iptables -A INPUT -p tcp --sport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --sport 80 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --sport 443 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j LOG --log-prefix "DROPPED:"

# Config OUTPUT for HTTP access
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 80 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 
iptables -A OUTPUT -p tcp -m tcp --sport 443 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 
iptables -A OUTPUT -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

# Config NAT
sysctl net.ipv4.ip_forward=1 >> /dev/null
iptables -t nat -A POSTROUTING -o 192.168.0.20 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i 191.168.0.20 -o 192.168.0.20 -j ACCEPT
#Forward inbound connections coming in gateway/router port 80 to internal server on port 80 of 192.168.0.20
iptables -t nat -A PREROUTING -i 191.168.0.10 -p tcp --dport 80 -j DNAT --to-destination 192.168.0.10:80
#Forward inbound connections coming in gateway/router port 5432 (POSTGRES) to internal server on port 5432 of 192.168.0.20
iptables -t nat -A PREROUTING -i 191.168.0.10 -p tcp --dport 5432 -j DNAT --to-destination 192.168.0.10:5432