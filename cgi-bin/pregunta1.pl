#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Configuración de conexión
my $database = "Cine";
my $hostname = "db";         # Nombre del contenedor MySQL
my $port     = "3306";               # Puerto predeterminado de MySQL
my $user     = "root";             # Usuario de MySQL
my $password = "tu_contraseña_segura"; # Contraseña para el usuario root

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Crear un nuevo objeto CGI
my $query = CGI->new();

# Recoger los datos del formulario 
my $campo = $query->param('campo'); 
my $propiedad = $query->param('propiedad'); 
my $dato = $query->param('datoC'); 
my $modif = $query->param('dato'); 
# Conectar a la base de datos 
my $dbh = DBI->connect($dsn, $user, $password, {
     RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1, 
     }); 
print $query->header(-title => 'Pregunta N°1', -style => [ { -src => '/css/principal.css' } ], 
-charset => 'UTF-8');
print $query->start_html('Actualizar Datos'); 
if (!$dbh) {
    die "Error al conectar a la base de datos: $DBI::errstr\n";
}
    # Construir la consulta SQL 
    my $sql = "UPDATE $campo SET $propiedad = ? WHERE $propiedad = ?";
    my $sth = $dbh->prepare($sql);
    if ($sth->execute($modif, $dato)) {
        print "<h2>Registro actualizado correctamente</h2>"; 
    } else { 
        print "<h2>Error al actualizar el registro</h2>";
    } 
    # Finalizar HTML 
print $query->end_html;
  # Cerrar la conexión 
$sth->finish(); $dbh->disconnect(); 