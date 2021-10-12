---
title: Distribuir componentes con Swift Package Manager
date: 2021-10-13 19:00
description: Swift Package Manager es una herramienta para controlar la distribución de código Swift en forma de librería o framework. Está integrada con el sistema de compliación de Swift para automatizar el proceso de descarga, compilación y dependencias.
tags: swift, swift package manager, spm, framework, library
excerpt: Swift Package Manager es una herramienta para controlar la distribución de código Swift en forma de librería o framework. Está integrada con el sistema de compliación de Swift para automatizar el proceso de descarga, compilación y dependencias.
---
Swift Package Manager es una herramienta para controlar la distribución de código Swift en forma de librería o framework. Está integrada con el sistema de compliación de Swift para automatizar el proceso de descarga, compilación y dependencias.
En este artículo me gustaría comentar el proceso, muy simple, de poder crearte un componente en Swift para ser distribuido con Swift Package Manager. 

# Creando un nuevo paquete

La forma de crear un nuevo paquete es muy fácil. En primer lugar creamos un nuevo package de la siguiente forma:

<img src="/images/spm/new-package.png" alt="New package" width="800"/>

Le ponemos un nombre y se crea un proyecto de tipo SPM. 

Una de las diferencias que tiene este tipo de proyecto es que no te crea un xcodeproj, si no que se abre con Package.swift. De todas formas, se puede crear ese xcodeproj por si nos es necesario, aunque no lo veremos en este artículo si lo haremos en uno próximo para ayudarnos con otras herramientas.

La estructura del proyecto queda de la siguiente forma.

<img src="/images/spm/new-project-created.png" alt="New project" width="800"/>

Tenemos el fichero Package.swift, donde tenemos la configuración del proyecto, si necesitamos alguna otra dependencia, targets de test. Por ahora no vamos a tocar este fichero.

Y después en Sources tendremos los ficheros de nuestro framework, con uno creado por defecto.

Como vemos en ese archivo, todo lo que hay declarado es público, y es muy importante que todo lo queramos "exponer" y que sea consumido los proyectos donde integremos nuestra librería tiene que ser public.

Vamos a hacer un cambio en este archivo para poner un método estático que simplemente imprima un Hello + name de la siguiente forma:

```
public struct Matrix {
    public static func hello(name: String) -> String {
        return "Hello " + name
    }
}
```

Modificamos también los tests para que los pase:

```
import XCTest
@testable import Matrix

final class MatrixTests: XCTestCase {
    func testHello() throws {
        XCTAssertEqual(Matrix.hello(name: "Alfonso"), "Hello Alfonso")
    }
}
```

# Subiendo el proyecto a un repositorio

Y con esto vamos a subir a nuestro repositorio para ver como se puede distribuir por SPM. Hay que tener cuidado de subir el proyecto a la raiz de nuestro repositorio para que lo podamos consumir.

Una vez subido creamos un tag de la siguiente forma, por consola.

```
git tag -a 1.0.0 -m "First version"

git push origin 1.0.0
```

Y veremos en el repositorio que se ha creado.

<img src="/images/spm/github-tag.png" alt="Github tag" width="800"/>

Con esto ya lo tendríamos todo preparado para distribuirlo y consumirlo, no necesitamos nada más, vamos a ver como lo hacemos desde otro proyecto cualquiera.

# Usando el componente

En el proyecto que queramos, vamos a File → Add Packages...

<img src="/images/spm/add-packages.png" alt="Add package" width="800"/>

Con esto ya lo tendríamos todo preparado para distribuirlo y consumirlo, no necesitamos nada más, vamos a ver como lo hacemos desde otro proyecto cualquiera.

En el proyecto que queramos, vamos a File → Add Packages...

<img src="/images/spm/configure-package.png" alt="Configure package" width="800"/>

Por defecto la regla de dependencia la tenemos como que se actualice solo cuando haya una versión major, pero podemos cambiarlo a minor, una versión en concreto, un rango de versiones e incluso una rama o un commit. Yo lo voy a dejar a que se actualice cada nueva minor version.

Le damos a añadir el paquete y nos muestra los paquetes disponibles y lo seleccionamos.

<img src="/images/spm/select-package.png" alt="Select package" width="800"/>

Y ya lo tendremos en nuestro proyecto.

<img src="/images/spm/package-inserted.png" alt="Package inserted" width="260" height="238"/>

Ahora, donde lo queramos usar, importamos el paquete.

```
import Matrix
```
Y usamos el método que creamos, por ejemplo en un label en SwiftUI de la siguiente forma:

<img src="/images/spm/use-package.png" alt="How use package" width="800"/>

Y de esta forma ya lo estamos usando en nuestro proyecto. 
A partir de aquí, si tenemos que hacer cualquier actualización de este componente en concreto, lo podremos hacer de forma totalmente separada y distribuirla cuando esté terminada, teniendo la opción los proyectos que la usen de actualizarse cuando esté lista la nueva versión.

Próximamente, partiendo de este comienzo, hablaremos de como hacer una distribución más automatizada, ¡estad atentos!





