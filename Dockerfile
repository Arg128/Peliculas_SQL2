# Usar una imagen base de Nginx
FROM nginx:latest

# Instalar FastCGI wrapper, spawn-fcgi, y editores de texto
RUN apt-get update && apt-get install -y \
    fcgiwrap \
    spawn-fcgi \
    vim \
    nano

# Copiar los archivos de la aplicación web al directorio de Nginx
COPY html/ /usr/share/nginx/html/
COPY cgi-bin/ /usr/lib/cgi-bin/

# Copiar el archivo de configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Crear script para iniciar `fcgiwrap`
RUN echo '#!/bin/bash\n\
spawn-fcgi -F 1 -s /var/run/fcgiwrap.socket -U www-data -G www-data -u www-data -g www-data /usr/sbin/fcgiwrap\n\
nginx -g "daemon off;"' > /start.sh \
&& chmod +x /start.sh

# Hacer el script ejecutable
RUN chmod +x /start.sh

# Exponer el puerto 8146
EXPOSE 8146

# Comando para iniciar Nginx y FastCGI wrapper
CMD ["/start.sh"]
