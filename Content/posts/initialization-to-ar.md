---
title: ARKit y RealitityKit: Inicialización a AR en iOS
date: 2021-05-13 14:24
description:  La realidad aumentada existe desde hace muchos años. En iOS tomó especial fuerza cuando en 2017 Apple presentó su framework ARKit. Vamos a ver en qué estado está actualmente, qué podemos hacer y veremos RealitityKit, herramienta de modelado 3D que nos ayuda a potenciar nuestros desarrollos de AR.
tags: swift, ar, arkit, realitykit, reality composer
excerpt: La realidad aumentada existe desde hace muchos años. En iOS tomó especial fuerza cuando en 2017 Apple presentó su framework ARKit. Vamos a ver en qué estado está actualmente, qué podemos hacer y veremos RealitityKit, herramienta de modelado 3D que nos ayuda a potenciar nuestros desarrollos de AR.
---
La realidad aumentada existe desde hace muchos años. En iOS tomó especial fuerza cuando en 2017 Apple presentó su framework ARKit. Vamos a ver en qué estado está actualmente, qué podemos hacer y veremos RealitityKit, herramienta de modelado 3D que nos ayuda a potenciar nuestros desarrollos de AR.

# Creando un proyecto AR

Para empezar vamos a crear un nuevo proyecto ARKit seleccionando la opción correspondiente.

<img src="/images/arkit/createARProject.png" alt="Create AR project" width="800"/>

Podemos elegir entre varias tecnologías para el contenido, es decir, para nuestra parte virtual. Hasta no hace mucho solo teníamos SceneKit (para modelos 3D), SpriteKit (para modelos 2D) y metal. Recientemente se añadió RealityKit, el cual está especializado para funcionar con realidad aumentada, así que será el que elegiremos.

<img src="/images/arkit/createProjectSelectRealityKit.png" alt="Select RealityKit" width="800"/>

Después podemos elegir si trabajar con Storyboard o SwiftUI. Vamos a seleccionar SwiftUI, que es el presente/futuro y nos tenemos que acostumbrar a trabajar con él.

<img src="/images/arkit/selectSwiftUI.png" alt="Select SwiftUI" width="800"/>

Y listo, creamos el proyecto y ya tenemos una base con un desarrollo que nos puede servir para ver como funciona de forma básica un proyecto de realidad aumentada.

En ContentView vemos una de las partes importantes. En primer lugar importamos, en nuestro caso, tanto SwiftUI y RealityKit.

```
import SwiftUI
import RealityKit
```

Después nuestra vista será un ARViewContainer, que como su nombre indica será el contenedor de nuestra realidad aumentada, y lo añadimos en nuestra View.

```
struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}
```

Y definimos nuestro ARViewContainer de la siguiente forma, en este caso, en el ejemplo básico, cargando un objeto y añadiéndolo en nuestra escena.

```
struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
```

Pero ... ¿de dónde se está cargando ese objeto? ¿qué es ese objeto llamado 'Experience'?

Esta es la segunda cosa importante que tenemos que ver, es el fichero Experience.rcproject, que si lo abrimos vemos lo siguiente.

<img src="/images/arkit/experienceProject.png" alt="experience.project" width="800"/>

Es nuestro editor del mundo virtual que vamos a pintar en nuestra realidad. En el ejemplo básico, tan solo tenemos un cubo en el centro de nuestro mundo, que si ejecutamos el proyecto (recordemos que solo funciona en dispositivo) veremos el resultado.

<img src="/images/arkit/cubeAR.jpeg" alt="Cube in AR" width="800"/>

En la esquina superior derecha veremos un botón "Open in Reality Composer", y ahí tenemos el tercer elemento importante para empezar a construir apps de AR. 

Abrimos el archivo con Reality Composer y podremos empezar a editar, añadir y crear mundos virtuales. Vamos a ver varios ejemplos de lo que podemos hacer.

<img src="/images/arkit/sceneHorizontal.png" alt="Horizontal scene" width="800"/>

Como vemos, tenemos nuestro cubo virtual que ya vimos como único elemento en nuestra única escena. Si vemos el nombre de la escena es "Box", y si recordamos, en el código para cargar el archivo era de la siguiente forma.

```
let boxAnchor = try! Experience.loadBox()
```

Lo iremos viendo, pero el patrón sería similar con las diferentes escenas que creemos, y podremos acceder a ellas con un método 'loadNombreEscena()'

Si miramos en la parte derecha, en el menú, podemos ver varias cosas interesantes. En primer lugar tenemos diferentes tipos de escena. 

La que tenemos creada es horizontal, que significa que el objeto lo pinta en un plano horizontal que detecte. Como hemos visto, nuestro cubo se ha añadido en una mesa, detectándola como un plano horizontal.

La segunda opción es 'Vertical", y funciona de forma similar pero detectando un plano vertical, y podemos hacer la prueba poniendo un objeto y al detectar una pared lo añadirá a la realidad.

La tercera opción es el reconocimiento de una imagen. En esta opción nos podemos parar un poquito y vamos a crear una escena.

<img src="/images/arkit/imageScene.png" alt="Image recognization scene" width="800"/>

<img src="/images/arkit/imageRecognizationScene.png" alt="Image recognization scene" width="800"/>

Nos añade dos elementos a la escena, una especie de plano horizontal y un objeto 3D. En la derecha vemos que podemos seleccionar una imagen para ese plano, que será el que nos detecte. Esta imagen tiene que tener unas características concreta, una diferencia de colores y formas concretas que sean suficientes para reconocer la imagen. Si añadimos una imagen no válida nos avisará.

<img src="/images/arkit/imageRecognizationError.png" alt="Image recognization scene error" width="800"/>

Pero si encontramos una óptimas lo añadirá sin más problema.

<img src="/images/arkit/imageRecognizationSuccess.png" alt="Image recognization scene success" width="800"/>

Y si ejecutamos este proyecto podemos ver en el siguiente video como reconoce la imagen y añade el modelo que hemos definido.

<video width="800" height="800" controls>
  <source src="/videos/imageRecognization.mp4" type="video/mp4">
</video>

Nos quedarían dos tipos de escenas más, reconocimiento de caras y reconocimiento de objetos, pero da para un artículo cada uno que veremos próximamente.

Hasta ahora no hemos añadido más objetos que el que nos crea por defecto. Si le damos al "+" (añadir) que tenemos en la parte superior nos saldrá un selector donde podremos elegir entre un buen banco de modelos que nos proporciona Apple, desde figuras básicas como elementos comunes. Además, podemos importar nuestros propios modelos. Estos modelos deberían estar en formato usdz, pero si lo tenemos en otro tipo que sea compatible podríamos convertirlo con la herramienta [usdzconverter](https://developer.apple.com/news/?id=01132020a&1578956733) o en esta [https://spase.io/playground](página online) de forma mucho más cómoda.

<img src="/images/arkit/addModels.png" alt="Add models" width="800"/>

Existen más elementos relacionados con la física, materiales, gravedad y comportamientos muy interesantes, así como oclusión, que veremos en otro artículo más avanado.

Si queréis, en este directo que hice en [http://twitch.alfonsomiranda.com](twitch) y que está en [Youtube](https://www.youtube.com/watch?v=YzssNbP5q8Q&ab_channel=Serquo)  podéis ver más tranquilamente lo escrito aquí y un poquito más.





