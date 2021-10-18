---
title: Distribuir componentes con Swift Package Manager
date: 2021-10-17 13:30
description: Swift Package Manager es una herramienta para controlar la distribución de código Swift en forma de librería o framework. Está integrada con el sistema de compliación de Swift para automatizar el proceso de descarga, compilación y dependencias.
tags: swift, swift package manager, spm, framework, library
excerpt: Swift Package Manager es una herramienta para controlar la distribución de código Swift en forma de librería o framework. Está integrada con el sistema de compliación de Swift para automatizar el proceso de descarga, compilación y dependencias.
---
[Swift Package Manager](https://swift.org/package-manager/) es una herramienta para controlar la distribución de código Swift en forma de librería o framework. Está integrada con el sistema de compliación de Swift para automatizar el proceso de descarga, compilación y dependencias.
En este artículo me gustaría comentar el proceso, muy simple, de poder crear un componente en Swift para ser distribuido con Swift Package Manager. 

# Creando un nuevo paquete

La forma de crear un nuevo paquete es muy fácil. En primer lugar vamos a `File -> New -> Package...`

<img src="/images/spm/new-package.png" alt="New package" width="800"/>

Ponemos un nombre y se crea un proyecto de tipo Swift Package Manager. 

Una de las diferencias que tiene este tipo de proyecto es que no tenemos un fichero xcodeproj, si no que se abre con `open Package.swift`. De todas formas, se puede crear ese xcodeproj si lo necesitáramos, pero para lo que veremos aquí no hará falta hacerlo.

La estructura del proyecto queda de la siguiente forma.

<img src="/images/spm/new-project-created.png" alt="New project" width="800"/>

En el fichero `Package.swift` es donde tenemos toda la configuración del proyecto. Si necesitamos alguna otra dependencia, algún otro target o alguna cosa similar lo añadiríamos aquí. Por ahora no vamos a necesitar tocarlo.

Y en la carpeta `Sources` tendremos los ficheros de nuestro componente, con uno creado por defecto.

Como vemos en ese archivo, todo lo que hay declarado es público, y es muy importante que todo lo que queramos "exponer" y que sea consumido en los proyectos donde integremos nuestra librería tenga esta visibilidad.

Vamos a hacer un cambio en este archivo para poner un método estático que simplemente construya un `String` con `Hello + name`, de la siguiente forma:

```
public struct Matrix {
    public static func hello(name: String) -> String {
        return "Hello " + name
    }
}
```

Modificamos también los tests para que no nos de error y quede todo nuestro proyecto testeado:

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

Con este pequeño componente empezaremos a trabajar y lo subiremos a nuestro repositorio para ver como se puede distribuir por SPM. Hay que subir el proyecto a la raiz de nuestro repositorio para que lo podamos consumir o si no nos daría problemas.

Una vez subido creamos un tag por consola de la siguiente forma, que será la versión empaquetada de nuestro componente.

```
git tag -a 1.0.0 -m "First version"

git push origin 1.0.0
```

Y veremos en el repositorio que se ha creado y que ya tenemos una versión para poder utilizar.

<img src="/images/spm/github-tag.png" alt="Github tag" width="800"/>

Cada vez que queramos generar una nueva versión de nuestro componente usaremos esta forma para que después, a través de Swift Package Manager, podamos especificar y concretar con qué versión queremos trabajar, como veremos en el siguiente punto.

Ya lo tendríamos todo preparado para distribuirlo y consumirlo, no necesitamos nada más, vamos a ver como lo hacemos desde otro proyecto cualquiera.

# Usando el componente

En el proyecto que queramos, vamos a File → Add Packages...

<img src="/images/spm/add-packages.png" alt="Add package" width="800"/>

Y ponemos la url de nuestro repositorio, y veremos que aparece nuestro componente.

<img src="/images/spm/configure-package.png" alt="Configure package" width="800"/>

Por defecto la regla de dependencia la tenemos puesta para que que se actualice solo cuando haya una versión major, pero podemos cambiarlo a minor, a una versión específica, a un rango de versiones e incluso a una rama o un commit. Lo vamos a dejar para que se actualice con cada nueva `minor version`.

Le damos a añadir el paquete y nos muestra los disponibles y seleccionamos el único que hemos creado.

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

Podéis ver el código del componente y su configuración en este [repositorio](https://github.com/alfonsomiranda/Matrix).

Próximamente, partiendo de este comienzo, hablaremos de como hacer una distribución más automatizada, ¡estad atentos!




