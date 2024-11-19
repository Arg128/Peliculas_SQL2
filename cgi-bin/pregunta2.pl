#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI qw(:standard);

# Configuración de conexión
my $database = "Cine";
my $hostname = "db";         # Nombre del contenedor MySQL
my $port     = 3306;               # Puerto predeterminado de MySQL
my $user     = "root";             # Usuario de MySQL
my $password = "tu_contraseña_segura"; # Contraseña para el usuario root

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

if ($dbh) {
    print "Conexión exitosa a la base de datos '$database'.\n";
} else {
    die "Error al conectar a la base de datos: $DBI::errstr\n";
}

my $query = CGI->new();
# Crear un nuevo objeto CGI

print $query->header(-type => 'text/html', -charset => 'utf-8');
print $query->start_html( -title => 'Pregunta N°2', -style => [ { -src => '/css/principal.css' } ] );
print $query->h1('Resultados de la Búsqueda');

# Consulta de actor con id = 5;
my $query2 = "SELECT actor_id FROM actor WHERE actor_id = 5";
my $sth = $dbh->prepare($query2);
$sth->execute();

# Imprimir resultados de la consulta
while (my @row = $sth->fetchrow_array) {
    print "<h2> El actor de ID = 5 es: $row[0]</h2>\n"
}
print $query->end_html;
# Cerrar la conexión
$sth->finish();
$dbh->disconnect();