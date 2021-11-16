---
title: Validación de código con github y bitrise
date: 2021-11-16 20:00
description: Bitrise es una herramienta que nos facilita mucho la integración contínua orientada a entornos de movilidad. Con ella podemos automatizar nuestra validación, compilación y distribución, entre otras muchas cosas. En este artículo nos vamos a centrar en como usar un flujo creado en bitrise para una validación automática previa en una revisión de código.
tags: github, swift package manager, bitrise, ci, cd, integration continuous, pr, pull request
excerpt: Bitrise es una herramienta que nos facilita mucho la integración contínua orientada a entornos de movilidad. Con ella podemos automatizar nuestra validación, compilación y distribución, entre otras muchas cosas. En este artículo nos vamos a centrar en como usar un flujo creado en bitrise para una validación automática previa en una revisión de código.
---
[Bitrise](https://www.bitrise.io/) es una herramienta que nos facilita mucho la integración contínua orientada a entornos de movilidad. Con ella podemos automatizar nuestra validación, compilación y distribución, entre otras muchas cosas. En este artículo nos vamos a centrar en como usar un flujo creado en bitrise para una validación automática previa en una revisión de código.

# Creando un nuevo proyecto en bitrise

Bitrise tiene diferentes planes, pero tiene uno para comenzar que es gratuito, así que nos podemos crear una cuenta para ir probándolo. Una vez creada empezamos a crear una nueva app y nos encontramos esto:

<img src="/images/bitrise/new-project-bitrise.png" alt="New project bitrise" width="800"/>

En mi caso ya tenía añadida mi cuenta de github y puedo navegar por mis repositorios, si tú aún no lo tienes sigue las instrucciones que te indican en bitrise para hacerlo.

Para este artículo vamos a continuar con el proyecto que empezamos en el anterior, donde [distribuíamos un componente por Swift Package Manager](https://alfonsomiranda.com/posts/component-swift-package-manager/). Una vez seleccionado el repositorio, indicamos de qué rama queremos hacer la integración. En mi caso he elegido main y al darle a continuar empieza el proceso para configurarlo ... ¡y nos dará error!

¿Por qué?

Porque nuestro proyecto no es un proyecto "Xcode" normal, no tenemos un ejecutable definido, un xcodeproj o xcworkspace, así que tenemos que hacerlo.

Nos vamos a donde está nuestro proyecto y por línea de comandos ejecutamos lo siguiente:

```
swift package generate-xcodeproj
```
que nos genera un xcodeproj.

Al abrirlo vamos a mirar los esquemas y quedarnos con el nombre, que será importante para configurarlo en bitrise.

<img src="/images/bitrise/xcode-scheme.png" alt="Xcode scheme" width="800"/>

Subimos los cambios al repositorio, volvemos a bitrise y hacemos de nuevo la configuración, pero elegimos la forma manual porque sigue fallando de forma automática (algún nombre de esquema o de proyecto que no detecta automáticamente), y habrá que configurar algunas cosillas. En primer lugar elegimos iOS y añadimos el xcodeproj


<img src="/images/bitrise/bitrise-project-configuration.png" alt="Bitrise project configuration" width="800"/>

E indicamos nuestro esquema.

<img src="/images/bitrise/bitrise-scheme-configuration.png" alt="Bitrise scheme configuration" width="800"/>

A continuación elegimos el método de distribución, en mi caso usaré development pero podéis poner el que queráis o modificarlo posteriormente. Y seleccionáis que máquina queréis usar.

<img src="/images/bitrise/bitrise-configuration-xcode.png" alt="Bitrise xcode configuration" width="800"/>

Confirmamos. Nos saltamos (si queremos) el paso de añadir el icono, y le damos a registrar un webhook, que añadirá a nuestro github el webhook necesario para que nos podamos comunicar con bitrise para la comprobación que haremos después en cada pull request. 

Le damos a finalizar y empezará a intentar ejecutar nuestro workflow. En mi caso al menos falla porque, no sé la razón, por defecto me pone un paso para cocoapods, cosa que no tengo (ni quiero tener), así que lo elimino.

<img src="/images/bitrise/bitrise-error-workflow.png" alt="Bitrise error workflow" width="800"/>

Y volvemos a ejecutar el workflow y ¡se hace la magia!

Ahora vamos a integrar la comprobación de bitrise con la creación de una PR. La idea es que cuando alguien cree una nueva PR, a parte de otras validaciones necesarias (por ejemplo, un mínimo de aprobaciones por parte del equipo), sea obligatorio que nuestro workflow de bitrise pase sin errores. En bitrise ahora mismo solo tenemos añadido que el proyecto compile y que pase los tests, pero podemos añadir más cosas en el futuro.

En primer lugar, nos vamos a las settings de nuestro proyecto en bitrise

<img src="/images/bitrise/bitrise-workflow-configuration.png" alt="Bitrise workflow configuration" width="800"/>

y activamos la opción de "Enable Github checks".

<img src="/images/bitrise/bitrise-enable-checks.png" alt="Bitrise enable checks" width="800"/>

Si es la primera vez que lo hacemos en nuestro repositorio, primero será necesario instalar la app y dar permisos, como indica en el enlace bajo el checkbox.

Una vez hecho ya estará preparado para hacer esas comprobaciones.

<img src="/images/bitrise/bitrise-enable-checks-2.png" alt="Bitrise enabled check" width="800"/>

Si nos vamos a nuestro workflow, en la parte de triggers de pull request, veremos que se nos ha añadido un nuevo lanzador que saltará cuando se haga un pull request de cualquier rama hacia cualquier rama. Esto lo podemos especificar para que solo sea a una en concreto (por ejemplo a la rama main) o definir más de uno para que dependiendo de la rama destino se ejecute diferentes acciones. Por ahora lo dejaremos así.

<img src="/images/bitrise/bitrise-triggers.png" alt="Bitrise triggers" width="800"/>

# Configurando el repositorio

Ahora nos vamos a nuestro repositorio, a la configuración y vamos a la sección de branches

<img src="/images/bitrise/github-activate-bitrise-check.png" alt="Github bitrise check" width="800"/>

Añadimos una nueva protección para nuestra rama principal, marcando "Add rule".

Aquí marcamos los siguientes checkbox para nuestra rama main:

<img src="/images/bitrise/github-branch-protection-rule.png" alt="Github branch protection rule" width="800"/>

donde hemos seleccionado que sea necesario que pase nuestros status check, en nuestro caso bitrise.

# Creando una nueva pull request

En teoría está ya todo listo para que cualquier pull request lance la comprobación y nos bloquee el mergeo en caso de error. Vamos a probar creando una nueva rama con algún cambio, y lanzando una PR.

El cambio será de lo más tonto, en el único método que tenemos definido, en vez de tener un resultado de "Hello + name" tendremos "Hello, + name", de esta forma:

```
public struct Matrix {
    public static func hello(name: String) -> String {
        return "Hello, " + name
    }
}
```

Lo subimos en una nueva rama, nos vamos a github y creamos la PR:

<img src="/images/bitrise/new-pull-request.png" alt="New pull request" width="800"/>

<img src="/images/bitrise/new-pull-request-2.png" alt="New pull request" width="800"/>

Y al crear la PR vemos que se empieza a ejecutar el check de Bitrise.

<img src="/images/bitrise/pull-request-checks.png" alt="Pull requests check" width="800"/>

Entrando en los detalles incluso podemos acceder directamente a la ejecución de bitrise para ver el progreso, que tardará unos minutillos.

Cuando termina, ¡oh! ¡sorpresa! ... ha fallado.

<img src="/images/bitrise/pull-request-fail.png" alt="Pull request fail" width="800"/>

Vamos a ir a los detalles a ver qué ha pasado.

<img src="/images/bitrise/pull-request-fail-summary.png" alt="Pull request summary fails" width="800"/>

Vemos que, obviamente, han fallado los test, ya que hemos cambiado la implementación pero no hemos actualizado los tests. Bitrise nos ha salvado de mergear a master (o main en el caso de github) una versión con los tests fallando ya que hemos subido sin probar que los tests funcionaban (¡mal! ¡muy mal!)

Vamos a los test y los corregimos.

```
import XCTest
@testable import Matrix

final class MatrixTests: XCTestCase {
    func testHello() throws {
        XCTAssertEqual(Matrix.hello(name: "Alfonso"), "Hello, Alfonso")
    }
}
```

Y subimos a nuestra rama, que a su vez actualizará la PR y lanzará de nuevo bitrise.

¡Y ahora si pasa las validaciones!

<img src="/images/bitrise/pull-request-success.png" alt="Pull request success" width="800"/>

Podemos ver un resumen de nuestro workflow en los detalles.

<img src="/images/bitrise/pull-request-summary-success.png" alt="Pull request summary success" width="800"/>

Y de esta forma tan sencilla hemos añadido un validador automático a nuestras pull requests, muy útiles para que los diferentes revisores de nuestro código no se tengan que preocupar de si los tests se están cumpliendo o de diferentes temas que se pueden hacer de forma automática. En futuros artículos añadiremos a nuestro workflow más pasos muy necesarios e importantes, como un validador de código `swiftlint` o que pase una comprobación más por Sonar. Pero esto ya será para otro día.
