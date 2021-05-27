---
title: Crear una API con Vapor en swift
date: 2021-05-20 12:15
description:  Vamos a ver como crear en swift una api usando Vapor, como instalarlo, desarrollarlo y subirlo a Heroku.
tags: swift, vapor, heroku, api, rest
excerpt: Vamos a ver como crear en swift una api usando Vapor, como instalarlo, desarrollarlo y subirlo a Heroku.
---

A los que desarrollamos en swift nos suele gustar mucho este lenguaje de programación, y nos gustaría hacerlo todo con él. Por suerte, es posible hacer todo (o casi todo), y hoy vamos a ver como montar nuestro backend en swift y no necesitar a nada ni nadie más.
Existen varios frameworks que nos ayudan en este trabajo pero, en mi opinión, el más completo es Vapor.
Vapor no es más que un framework web escrito en swift para montar web o servicios web, emulando a otros como nodejs y siguiendo una filosofía similar.
Vamos a ver una pequeña introducción de como usarlo e incluso como desplegarlo en un servidor en la nube.

# Instalando Vapor

Para instalar Vapor tenemos que ejecutar estos comandos usando [brew](https://brew.sh/index_es), el cual deberíamos tener previamente instalado.

```
brew tap vapor/tap
brew install vapor/tap/vapor
```

A partir de aquí, con el siguiente comando creariamos un nuevo proyecto Vapor.

```
vapor new VaporTest
```

siendo VaporTest el nombre que le queramos dar al proyecto, donde nos irá preguntando una serie de cosas, como si queremos usar diferentes frameworks (Fluent, Leaf) o que base de datos usar, si queremos. En nuestro caso vamos a usar Fluent, un framework que nos ayuda con SQL y bases de datos postgresSQL. Todo es opcional y podemos no querer usar nada y ejecutar esta alternativa para que directamente ni nos pregunte.

```
vapor new VaporTest -n
```

Abrimos el proyecto ejecutando dentro de la carpeta generada lo siguiente y ejecutamos 

```
vapor xcode
```

o

```
open Package.swift
```

y se abrirá nuestro proyecto en XCode. Una vez descargadas todas las dependencias (puede tardar un poquito), hacemos run y se nos montará un servidor en la dirección http://127.0.0.1:8080

<img src="/images/vapor/itsworks.png" alt="It's works in Vapor" width="800"/>

Aquí podemos tener un problema a la hora de volverlo a ejecutar, ya que se habrá quedado el proceso en background y no nos dejará volverlo a lanzar hasta que matemos ese proceso. Para matarlo primero buscamos cual es su id de esta forma:

```
netstat -vanp tcp | grep 8080
```
y después, con el id del proceso, lo matamos.

```
kill -9 idProceso
```

Para no tener que hacer esto todo el tiempo podemos hacer dos cosas:

* Configurar el proyecto para que sepa donde tenemos la ejecución del proyecto como vemos en la imagen.

<img src="/images/vapor/itsworks.png" alt="It's works in Vapor" width="800"/>

O ejecutarlo desde consola con el comando.

```
vapor run
```

y cuando queramos pararlo y matarlo simplemente pulsar `ctrl + C`

# Proyecto de ejemplo


# Configuramos la base de datos

En nuestro caso vamos a usar postgreSQL, así que en primer lugar vamos a instalarlo. Lo haremos con brew

```bash
brew install postgresql
```

y la arrancamos

```bash
brew services start postgresql
```

Añadimos la configuración en nuestro proyecto. Hay varias formas, en el código de ejemplo vemos una donde tan solo tendríamos que añadir las credenciales de nuestro postgres, pero vamos a hacerlo de una forma más elegante y que nos servirá en el futuro para tener varios entornos.
Creamos un fichero `.env.development` con lo siguiente:

```bash
DB_URL=postgres://myuser:mypass@localhost:5432/mydb
```
y en `configure.swift` cambiamos la configuración por esto

```
extension Application {
    static let databaseUrl = URL(string: Environment.get("DB_URL")!)!
}

public func configure(_ app: Application) throws {
    
    try app.databases.use(.postgres(url: Application.databaseUrl), as: .psql)
    
    //...
}
```

Con esto ya deberíamos tener conexión y tendremos que hacer la migración de nuestras clases a tablas, ejecutando lo siguiente:

```bash
vapor run migrate
```

# Empezamos a montar nuestra API

En primer lugar vamos a crearnos el modelo el cual usaremos para nuestra API. En nuestro ejemplo, será un objeto "Mensaje" que contendrá un titulo, un contenido y una fecha.



# Desplegar en Heroku

```
brew tap heroku/brew && brew install heroku
```

```
heroku create vapor-tutorial --region eu
```

```
heroku git:remote -a vapor-tutorial
```
Creamos un archivo Procfile con el siguiente contenido

```
web: Run serve --env production --hostname 0.0.0.0 --port $PORT
```

Y lo añadimos al repositorio.

```
git add Procfile
git commit -m "Added Procfile"
```
Añadimos un buildpack para que heroku entienda a Vapor

```
heroku buildpacks:set vapor/vapor
```
Y por último creamos un fichero para indicar qué versión de swift estamos usando.

```
echo "5.3.3" > .swift-version
```
Cambiando por la versión que estamos usando.

Y hacemos commit y push a heroku para subir y desplegar.

```
git commit -m "Upload to heroku"
git push heroku master 
```

