#/bin/bash!

#version 0.8
# v0.7 - Se agregan los servidores que dan error para que los chequee con el qmHandle en lugar de mailqueuemng
# v0.8 - Se introduce el flag para evitar envios continuos.

#Script Monitorizacion Servidores Correo

#Introducir en el fichero lista_servidores los servers a monitorizar, uno por linea.
#El script se conecta por ssh (agregar previamente la rsa-key para conexion sin solicitud contrasena)
#Si se supera el umbral de correo definido por qlimit_remote, envia un correo a la direccion configurada.


#------- INICIO --------

#Modifique este parametro para aumentar o disminuir el umbral de notificacion
qlimit_remote=200

#inicializacion variable a 0. No hace falta modificar esta variable
contar_remote=0

notifyemail=your@eaddress.com;

FILE=/root/monitor/servers.txt

exec 4<$FILE
#Empleo IFS con : como separador -> IP:flag mail enviado o no, si la IP ha sido detectada anteriormente
while IFS=':' read -u4 line flag ; do

echo "servidor $line"
echo "flag $flag"

if [ "$flag" = "0" ]; then

  
   # if [ "$line" = "YOUR_IP" ] ; then  #Uncomment this line if you use Plesk 8.0 or 8.2 servers. Add here IPs for Plesk 8.0 or 8.2
   contar_remote=$(ssh root@$line /root/qmHandle -s | grep "remote queue" | awk -F ":" '{print $2}' | sed 's/ //g');
   else
   contar_remote=$(ssh root@$line /usr/local/psa/admin/bin/mailqueuemng -s | grep "Messages total" | awk -F ":" '{print $2}' | sed 's/ //g');
   fi #$line

echo "servidor: $line"
echo "correos: $contar_remote"
echo "---------"

   #Comparo la variable con el umbral

   if [ $contar_remote -ge $qlimit_remote ] ; then
   asunto="MONITOR - Servidor $line - Tiene $contar_remote correos en cola."
   echo "$asunto" | mail -s "$asunto" $notifyemail < /dev/null
   lineacambio0="$line:0"
   lineacambio1="$line:1"

   #MODIFICAMOS EL FLAG A 1
   sed -i 's/'$lineacambio0'/'$lineacambio1'/g' /root/monitor/servers.txt
