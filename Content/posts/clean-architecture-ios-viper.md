---
title: Clean architecture en iOS: VIPER
date: 2017-01-20 14:24
description:  En los últimos tiempos está muy de moda en el mundo del software la filosofía “clean”, hacer de la construcción de software un arte, y que estemos orgullosos del código que escribimos.
Seguramente el mayor defensor de esta filosofía, o al menos el que más ha escrito al respecto sea Robert C. Martin, más conocido como Uncle Bob, y en este texto me basaré en mucho de lo que él ha escrito y contado. También hay que hacer alguna referencia a otros autores, como el conocido Gangs of four, los cuales escribieron mucho sobre patrones de diseño o Martin Fawler, el cual colaboró con Robert C. Martin en la definición de SOLID (que veremos más adelante) y escribió un libro imprescindible llamado Refactoring.
tags: clean architecture, clean, viper, swift, solid
excerpt: En los últimos tiempos está muy de moda en el mundo del software la filosofía “clean”, hacer de la construcción de software un arte, y que estemos orgullosos del código que escribimos.
Seguramente el mayor defensor de esta filosofía, o al menos el que más ha escrito al respecto sea Robert C. Martin, más conocido como Uncle Bob, y en este texto me basaré en mucho de lo que él ha escrito y contado. También hay que hacer alguna referencia a otros autores, como el conocido Gangs of four, los cuales escribieron mucho sobre patrones de diseño o Martin Fawler, el cual colaboró con Robert C. Martin en la definición de SOLID (que veremos más adelante) y escribió un libro imprescindible llamado Refactoring.
---
En los últimos tiempos está muy de moda en el mundo del software la filosofía “clean”, hacer de la construcción de software un arte, y que estemos orgullosos del código que escribimos.

Seguramente el mayor defensor de esta filosofía, o al menos el que más ha escrito al respecto sea [Robert C. Martin](https://en.wikipedia.org/wiki/Robert_Cecil_Martin), más conocido como Uncle Bob, y en este texto me basaré en mucho de lo que él ha escrito y contado. También hay que hacer alguna referencia a otros autores, como el conocido Gangs of four, los cuales escribieron mucho sobre patrones de diseño o [Martin Fawler](https://es.wikipedia.org/wiki/Martin_Fowler), el cual colaboró con Robert C. Martin en la definición de SOLID (que veremos más adelante) y escribió un libro imprescindible llamado [Refactoring](https://www.amazon.es/Refactoring-Improving-Design-Existing-Technology/dp/0201485672/ref=sr_1_1?ie=UTF8&qid=1484827579&sr=8-1&keywords=refactoring).

# Clean architecture.

Robert C. Martin fue el que definió esta arquitectura allá por el año 2012 en su [web](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html). Existían entonces, y siguen existiendo, muchas arquitecturas definidas que intentan solucionar los mismos problemas:

* **Independiente de frameworks.** Debemos hacer la arquitectura independiente de cualquier librería que usemos en el desarrollo, y que no nos aten a sus requisitos, usándolas como lo que son, herramientas para conseguir un fin concreto.
* **Testeable.** La lógica de negocio se debería poder testear sin necesidad de la interfaz de usuario (UI), base de datos, servidor web u otras herramientas externas, y de esta forma eliminar elementos que son más complicados de probar.
* **Independiente de la UI.** Como la interfaz de usuario suele ser el elemento que más expuesto está al cambio debemos asegurarnos que no afecten al resto del desarrollo. De esta forma, además, se podrá usar un mismo código para diferentes interfaces solo cambiando la capa de UI.
* **Independiente de la base de datos.** De forma similar al punto anterior, al ser la arquitectura independiente de la base de datos, o más genéricamente, de la fuente de datos, podemos hacer cambios en esta parte sin que afecte a la lógica de negocio, teniendo la posibilidad de cambiar una api por un webservice, una base de datos por una api, o cualquier combinación que se nos ocurra.
* **Independiente de factores externos.** Como resumen al resto de puntos, la lógica de negocio debe ser ajena a todo lo que venga del mundo exterior, pudiendo cambiar el resto de piezas sin que le afecte, como si de un puzzle se tratara.

Como hemos comentado, las arquitecturas existententes solucionaban la mayoría de estos puntos y todas separaban la arquitectura en capas para diferenciar los diferentes conceptos, pero algunas estaban más enfocadas a la interfaz y otras a la lógica de negocio.

En el caso concreto de iOS, la más usada era (y es) MVC, aunque habitualmente esas siglas perdían su significado de “Model View Controller”, para pasar a ser “Massive View Controller”, al terminar siendo cualquier clase u objeto una vista, modelo y controlador a la vez, terminando por desvirtualizar e incluso elimininar la arquitectura.

<img src="/images/cleanArchitecture/cleanArchitectureDiagraman.png" alt="The Clean Architecture, by Uncle Bob" width="800"/>

En este diagrama se intentó unificar todas estas ideas en una sola, que fuera entendible y que cumpliera una serie de reglas.

## Reglas de dependencia.

Los diferentes círculos representan diferentes capas del software. En general, cuanto mas nos alejemos del núcleo mayor es el nivel del software y más unido al framework está. Los círculos exteriores son mecanismos mientras que los interiores son políticas. La regla primordial que hace que esta arquitectura funcione es la regla de dependencia. Esta regla dice que las dependencias a nivel de código fuente sólo pueden apuntar hacia dentro. Nada que se encuentre en un circulo interior puede saber algo sobre lo que hay en un círculo exterior, es decir, algo declarado en un círculo externo no puede ser mencionado desde el código situado en un círculo interno. Eso incluye funciones, clases, variables o cualquier otra entidad software. Por la misma razón, los formatos de datos usados en un círculo exterior no deberían usarse por un círculo interior, especialmente si esos formatos son generados por algún framework en un círculo situado al exterior. No queremos que nada de un círculo exterior impacte en los círculos o niveles interiores.

## Entities
Las entidades son usadas por la lógica de negocio de la aplicación, por los llamados interactors. Deben ser objetos que solo dependan de esta capa y que no deben ser usados por las capas superiores, teniendo éstas que funcionar con objetos más simples (diccionarios, arrays, struts, …) o con parámetros de una función.

## User Cases

En esta capa, también llamada Interactor, se tienen los casos de uso, lo cual tienen que ser independiente de la fuente de datos o de la visualización de los mismos. Si cambia los datos no debe influir en estos casos de uso, al igual que si la apariencia de nuestro desarrollo cambia. Es donde tendremos la lógica de negocio en nuestra aplicación

## Interface adapters

O también llamados Presenters, es la capa que comunica los resultados de los casos de uso con la capa más externa. Esta capa recogerá los datos del interactor que a su vez los habrá procesado de la fuente de datos, y los formateará para ser presentado en la capa más externa, ya sea en una UI, en una base de datos o en algún dispositivo.

## Frameworks y adapters

Es la capa más externa y la más pegada a la tecnología que estamos usando. En una web sería el html/javascript, en una app iOS todo lo referente a UIKit. Esta capa es una de las que está más sujeta a cambios, y la que podemos hacer más intercambiable. Si nos enfocamos en iOS, solo (o casi) cambiando esta capa podremos adaptar nuestra aplicación a iPhone, iPad o Apple TV.

## Cruzando los límites, ¿cómo y qué puede cruzarlos?

La forma en la que debemos comunicarnos entre capa sería a través de interfaces, protocolos o delegados. Debe ser lo más polimórfico posible y que no cause mucho daño el cambio de una de las capas, siempre respetando la interfaz. Si jugamos con protocolos haremos estas comunicaciones totalmente independiente las unas de las otras, y serán piezas fácilmente intercambiables. Desde la llegada de swift ha proliferado la llamada OPP (Programación orientada a protocolos), la cual, entre otras muchas cosas, ayuda mucho a este cometido.

# SOLID

Antes de hablar de VIPER me gustaría comentar algo sobre [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)). Para el que aún no lo conozca, [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) es una serie de principios básicos definidos por varios autores para el desarrollo orientado a objetos, unificados en este acrónimo inventado por nuestro Uncle Bob. Vamos a echarle un vistazo rápido a cada uno de ellos.

* **S: Single responsibility principle:** Una clase debería solo tener una responsabilidad, es decir, solo debería de tener una razón para cambiar. Dicho de otra forma, cuando una clase o función es usada para más de una cosa suele ser causa de estar haciendo algo mal. Esto parece algo muy lógico y básico, pero muchas veces no se cumplen y terminamos haciendo pequeñas tareas en funcionalidades ya existentes porque “nos pilla más a mano”, terminando por ser un problema a la larga cuando ese método lo queramos usar en otro sitio, teniendo que recordar que también sirve para más cosas. Por ejemplo, si tenemos un método que imprime un documento, y en algún momento también añadimos ahí que se guarde en disco, si en otro lugar queremos imprimir tendríamos el problema de que también hará otras funciones no deseadas y que quizás ni recordemos que estaban ahí.
* **O: Open/closed principle (Bertrand Meyer):** Una clase debería ser abierta por extensión, pero nunca por modificación. Es decir, se puede heredar de esa clase, extenderla, pero nunca modificar su código fuente para adaptarla a todos los casos. La forma más fácil de extender una clase es con herencia o interfaces (protocolos en nuestro caso). Este principio puede parecer fácil pero no lo es tanto, ya que tenemos que tener bastante claro la definición de nuestro proyecto, y preveer que clases vamos a tener que extender, no siendo siempre posible y teniendo en algún momento que necesitar refactorizar.
* **L: Liskov substitution principle (Barbara Liskov):** Los objetos de un programa deberían de ser sustituidos por una subclase o instancia sin modificar el comportamiento del programa. Es decir, una clase que herede de otra no tiene que modificar el comportamiento de la clase base de tal forma que al sustituirlo por ella el comportamiento sea diferente. La forma más fácil de ver si estamos cumpliendo esta regla es sustituir en nuestro código la clase base por cualquiera de las subclases y ver si todo sigue funcionando igual.
* **I: Interface segregation principle (Robert C. Martin):** Muchos pequeños y específicos interfaces son mejores que uno genérico. Esto evita el acoplamiento y fomenta la segregación. Es parecido al primer principio pero orientado a interfaces, las cuales deben ser para un caso de uso concreto y no demasiado genérica. El objetivo de este principio es principalmente poder reaprovechar los interfaces en otras clases. Si tenemos un interface que compara y clona en el mismo interface, de manera más complicada se podrá utilizar en una clase que solo debe comparar o en otra que solo debe clonar.
* **D: Dependency inversion principle (Robert C. Martin):** Se debe depender de abstracciones, no de concreciones. Esto fomenta el uso de interfaces y es algo que ya hemos hablado antes en clean arquitecture, que debería ser la forma en la que se comunican las diferentes capas. De esta forma unas clases pueden interacturar con otras sin conocer toda su implementación, usando, por ejemplo, inyección de dependencias.

# VIPER

VIPER no es más que una implementación de esta arquitectura, orientada a un desarrollo iOS. VIPER es un conjunto de siglas que describen las diferentes capas, View, Interactor, Presenter, Entity y Routing.
<img src="/images/cleanArchitecture/viperDiagraman.png" alt="VIPER" width="800"/>
* **View:** Capa que “pinta” lo que le mande el presenter y que, mediante los inputs del usuario le pregunta al presenter qué hacer. Esta capa tiene que ser totalmente pasiva, lo más “tonta” posible y tendrá dos formas de reaccionar: a los inputs externos (touch de un usuario, por ejemplo) o a órdenes del presenter.
* **Interactor:** Contiene la lógica de negocio de un caso de uso. Aquí se manipula las Entities (modelos) para una tarea específica. Como ya hemos dicho debe ser independiente de la interfaz gráfica y debe modelar lo recibido de una fuente de datos. Al hacerlo independiente de la interfaz este código debería ser compatible para desarrollar, por ejemplo, para iOS y OSX sin ningún problema.
* **Presenter:** Contiene la lógica que la vista tiene que presentar y reacciona a los inputs que desde la vista son mandadas. Esto quiere decir que le dirá a la UI que tiene que pintar al recibir la información del Interactor y reaccionará a las acciones de la View (UI) para hacer una navegación o pedir datos.
* **Entity:** Contiene el modelo de los objetos usados por el Interactor. Será, normalmente, un simple PONSO, o si estamos usando CoreData serán los NSManagedObjects generados.
* **Routing:** Contiene toda la navegación de la app. Es quizás la más complicada de entender al estar acostumbrados hasta ahora a hacer toda la navegación en los ViewController. Este Routing (también llamados Wireframe) son aprovechados para hacer la inyección de dependencias a la hora de crear una nueva navegación y presentar una nueva sección. Existen muchas formas de implementar esta parte y suele ser motivo de discusión de darle o no más responsabilidad. Lo importante es que en esta capa esté concentrado toda la navegación de la app.

Esta separación cumple la [Single Responsibility Principle](http://www.objectmentor.com/resources/articles/srp.pdf). El Interactor es responsable de la lógica de negocio, el Presenter representa la interacción con el diseño y la View es responsable del diseño visual.

También es importante que cumpla la norma “Dependency segregation principle”, ya que a la hora de conectar las diferentes capas deberíamos hacerlo con interfaces, protocolos, y de esta forma depender de estas abstracciones y no de implementaciones concretas, pudiendo de esta forma cambiar la implementación de una capa sin que afecte a otras.

Los otros tres principios también deben ser cumplidos, en realidad cualquier arquitectura orientada a objetos debería cumplir SOLID, y aunque no sea fácil debemos obligarnos a ello.

Si en algún momento no estamos cumpliendo las diferentes buenas prácticas y normas no debemos tener miedo a refactorizar y siempre intentar mejorar el código. Si no sabéis qué es [la teoría de las ventanas rotas](https://es.wikipedia.org/wiki/Teor%C3%ADa_de_las_ventanas_rotas) os invito a conocerla.

Para terminar, os dejo un poco de documentación y bibliografía en la que me he apoyado y basado para escribir esto:

* Clean arquitecture: [https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html)
* VIPER: [https://www.objc.io/issues/13-architecture/viper/](https://www.objc.io/issues/13-architecture/viper/)
* SOLID: [https://www.genbetadev.com/paradigmas-de-programacion/solid-cinco-principios-basicos-de-diseno-de-clases](https://www.genbetadev.com/paradigmas-de-programacion/solid-cinco-principios-basicos-de-diseno-de-clases)
* Clean Arquitecture by Robert C. Martin: [https://www.amazon.es/Clean-Architecture-Robert-C-Martin/dp/0134494164/](https://www.amazon.es/Clean-Architecture-Robert-C-Martin/dp/0134494164/)
* Refactoring: [https://www.amazon.es/Refactoring-Improving-Design-Existing-Technology/dp/0201485672/](https://www.amazon.es/Refactoring-Improving-Design-Existing-Technology/dp/0201485672/)
