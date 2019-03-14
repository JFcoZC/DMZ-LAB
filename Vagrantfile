# -*- mode: ruby -*-
# vi: set ft=ruby :

#Definir variable config
Vagrant.configure("2") do |config|
    #--- INICIO MAQUINA DE LA BDS ---
      #Configurar para iniciar ssh de servidor usando: vagrant ssh web 
      config.vm.define "db" do |db|
        db.vm.box = "ubuntu/bionic64"
        #Permitir que todo trafico mandado al puerto del host (computadora) sea mandado al puerto
        #del guest(maquina virtual). El Daemon se pone en el puerto de la computadora para redireccionar
        #el trafico
        db.vm.network "forwarded_port", guest: 5432, host: 5432
        db.vm.network "private_network", ip: "192.168.0.30"
        db.vm.provision "shell", inline: <<-SHELL
          echo "dbserver" > /etc/hostname
          #Confiugrar hostname del servidor
          hostname -b dbserver
          #Haciendo que dbserver pueda enconctrar al clockserver por nombre
          echo "192.168.0.20        clockserver" >> /etc/hosts
          #Haciendo que dbserver pueda enconctrar al webserver por nombre
          echo "192.168.0.10        webserver" >> /etc/hosts
          #Instalar postgres (server packageExtensionOfCommunity)
          sudo apt-get install postgresql postgresql-contrib -y
          #Crete USER postgres with PASSWORD postgres
          sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';" 
          #Mover archivos con la configuracion correcta para que puedan hacerse conexiones
          #desde clientes externos
          sudo cp /vagrant/pg_hba.conf /etc/postgresql/10/main/
          sudo cp /vagrant/postgresql.conf /etc/postgresql/10/main/
          #Reinicar servicio de postgres
          sudo /etc/init.d/postgresql restart
          #Verificar que postgres este corriendo en el puerto adecuado
          pg_lsclusters
          #------- Ejecutar Comandos IP TABLES SSH ----
          bash /vagrant/db_iptables.sh
        SHELL
      end
    #--- INICIO MAQUINA DE LA BDS ---
      #Configurar para iniciar ssh de servidor usando: vagrant ssh web 
      config.vm.define "pc" do |pc|
        pc.vm.box = "ubuntu/bionic64"
        pc.vm.network "public_network", ip: "191.168.0.30"
        pc.vm.provision "shell", inline: <<-SHELL
          echo "pc1" > /etc/hostname
          #Confiugrar hostname del servidor
          hostname -b pc1
          #Haciendo que dbserver pueda enconctrar al clockserver/router por nombre
          echo "191.168.0.20        clockserver" >> /etc/hosts
          #------- Ejecutar Comandos IP TABLES SSH ----
          bash /vagrant/pc_iptables.sh
        SHELL
      end
    #--- INICIO MAQUINA DEL WEB SERVER ---
      #Configurar para iniciar ssh de servidor usando: vagrant ssh web 
      config.vm.define "web" do |web|
        web.vm.box = "ubuntu/bionic64"
        #Permitir que todo trafico mandado al puerto del host (computadora) sea mandado al puerto
        #del guest(maquina virtual). El Daemon se pone en el puerto de la computadora para redireccionar
        #el trafico
        web.vm.network "forwarded_port", guest: 80, host: 80
        web.vm.network "private_network", ip: "192.168.0.10"
        web.vm.network "public_network", ip: "191.168.0.10"
        web.vm.provision "shell", inline: <<-SHELL
          echo "webserver" > /etc/hostname
          #Confiugrar hostname del servidor
          hostname -b webserver
          #Haciendo que webserver pueda enconctrar al clockserver por nombre
          echo "192.168.0.20        clockserver" >> /etc/hosts
          #Haciendo que webserver pueda enconctrar al dbserver por nombre
          echo "192.168.0.30        dbserver" >> /etc/hosts
          #Configuracion basica
          apt update && apt upgrade -y
          #-------- Instalar apache ------------
          apt-get install -y apache2
          #Crear carpetas requeridas
          sudo mkdir -p /var/www/example.com/html
          #Asignar el usuario propietario del directorio
          sudo chown -R $USER:$USER /var/www/example.com/html
          #Asegurarse de que el directorio raiz para la web tiene los permisos necesarios(puede omitirse)
          sudo chmod -R 755 /var/www/example.com
          #Moverse a directorio
          cd /var/www/html
          #Bajar documentos github (Clone)
          sudo apt-get install git
          git clone https://github.com/JFcoZC/Cloud-basedClock.git
          wget https://github.com/JFcoZC/Cloud-basedClock/blob/master/jquery-3.3.1.js
          #Eliminar archivos de mas
          cd Cloud-basedClock/Relojv3
          rm -rf servidor
          #------- Ejecutar Comandos IP TABLES SSH ----
          bash /vagrant/client_iptables.sh
        SHELL
      end
    #--- INICIO MAQUINA DEL CLOCK SERVER/ROUTER ---  
      #Definir variable web
      config.vm.define "clock" do |clock|
        clock.vm.box = "ubuntu/bionic64"
        # Create a forwarded port mapping which allows access to a specific port
        # within the machine from a port on the host machine.
        #Permitir que todo trafico mandado al puerto del host (computadora) sea mandado al puerto
        #del guest(maquina virtual). El Daemon se pone en el puerto de la computadora para redireccionar
        #el trafico hacia la maquina virtual
        clock.vm.network "forwarded_port", guest: 3000, host: 3000
        clock.vm.network "private_network", ip: "192.168.0.20"
        clock.vm.network "public_network", ip: "191.168.0.20"
        clock.vm.provision "shell", inline: <<-SHELL
          echo "clockserver" > /etc/hostname
          #Confiugrar hostname del servidor
          hostname -b clockserver
          #Haciendo que clockserver pueda enconctrar al webserver por nombre
          echo "192.168.0.10        webserver" >> /etc/hosts
          #Haciendo que clockserver pueda enconctrar al dbserver por nombre
          echo "192.168.0.30        dbserver" >> /etc/hosts
          #Configuracion basica
          apt update && apt upgrade -y
          #------- Ejecutar Comandos IP TABLES SSH ----
          bash /vagrant/router_iptables.sh
        SHELL
      end
    end
