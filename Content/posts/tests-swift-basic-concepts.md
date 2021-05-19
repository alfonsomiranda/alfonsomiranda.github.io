---
title: Tests en swift: Conceptos básicos
date: 2021-04-05 14:24
description:  En cualquier proyecto software es muy importante que nuestro código esté testeado. En este artículo vamos a ver los conceptos básicos para comenzar a hacer tests en swift, que necesitamos saber y por qué son tan necesarios añadirlos en nuestros proyectos.
tags: test, swift
excerpt: En cualquier proyecto software es muy importante que nuestro código esté testeado. En este artículo vamos a ver los conceptos básicos para comenzar a hacer tests en swift, que necesitamos saber y por qué son tan necesarios añadirlos en nuestros proyectos.
---

En todo este artículo los tests a los que nos vamos a referir son los tests unitarios.
¿Y qué son los tests unitarios? Según la [wikipedia](https://es.wikipedia.org/wiki/Prueba_unitaria),

> una prueba unitaria es una forma de comprobar el correcto funcionamiento de una unidad de código
> es decir, desarrollar una serie de pruebas que comprueben el correcto funcionamiento de diferentes unidades de nuestro código implementado en nuestra aplicación.

# ¿Qué es un test y por qué lo necesito?

En proyectos reales donde el tiempo siempre es escaso siempre se “olvidan” los tests aludiendo a que consumen tiempo de desarrollo y que no disponemos de él. Vamos a ver por qué son necesarios los tests:

## ¡Porque nos ahorran tiempo!

Si, la primera en la frente. Frente a las creencias de que nos consume mucho tiempo, la realidad es que es todo lo contrario. No solo el desarrollo de los tests es relativamente sencillo (si usamos una buena arquitectura, ya llegaremos a eso), si no que nos ahorra muchos problemas futuros, como malos funcionamientos, comportamientos no deseados, problemas colaterales a cambios en el código.

## Refactorización de código.

Cuando uno se dispone a refactorizar un código por diferentes motivos (deuda técnica, cambios funcionales), y más si el código que estás modificando no es tuyo, siempre está el riesgo y el miedo a romper algo que no estamos teniendo en cuenta. Si todo ese código está testeado, el riesgo a tener problemas colaterales se reduce mucho (nunca podemos llegar a 0) y podemos cambiar este código con mucha más tranquilidad ya que los tests nos avisarán de que algo hemos roto y podremos controlarlo.

## Definición de los casos de uso.

De algo que hablaremos en esta serie de artículos es de TDD que es, a MUY grandes rasgos, definir primero los tests y a partir de ellos desarrollar la implementación de nuestro proyecto. De esta forma, a partir de ir creando los tests podemos ir definiendo todos los casos de uso, y a partir de ellos definir todo el funcionamiento de la aplicación.

## Refinamiento del código.

Si estamos construyendo tests de código ya implementado nos podemos dar cuenta en algún momento que nos resulta imposible testear alguna parte de nuestro código. ¿Es problema de que no sabemos hacer tests? No, seguramente es que el código está mal escrito y necesita ser mejorado. Esto nos ayuda a refactorizar este código y arreglarlo para que podamos desarrollar los tests, y de esta forma refinarlo y mejorarlo.

## Integración contínua.

Si tenemos nuestro código en un sistema de integración continua, el tener implementado tests hará que no se suba código roto a entornos de desarrollo o producción, y que se controle que todo lo que debería funcionar, funcione.
Hay muchas otras razones para usar tests, pero estas creo que son, en mi opinión, las más básicas.

# Conceptos básicos.

Para añadir tests en tu proyecto se puede hacer o bien, si es un proyecto nuevo marcando que añade un target de test,

<img src="/images/testBasics/createProject.png" alt="Crear nuevo proyecto con tests" width="800"/>

o en tu proyecto ya creado añadiendo ese target y asociarlo al principal.

<img src="/images/testBasics/addTestsProject.png" alt="Seleccionamos un nuevo target de tests unit" width="800"/>
<img src="/images/testBasics/addTestsProject2.png" alt="Ponemos su nombre y target" width="800"/>

Una vez hecho esto, con CMD + U ejecutamos los tests y nos lista los que han pasado y los que no.

<img src="/images/testBasics/firstTestsBuild.png" alt="Ponemos su nombre y target" width="800"/>

Ahora vamos a hacer nuestro primer test. Para ello vamos a añadir en el ViewController creado por defecto una variable con un valor.

```
import UIKit

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Welcome"
      return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
```

Y añadimos un test para probarlo.

```
func test_viewController_titleLabel_is_welcome() {
        let viewController = ViewController()
        
        XCTAssertEqual(viewController.titleLabel.text!, "Welcome")
    }
```

Aquí lo único que hacemos es cargar el ViewController y comprobar que el texto que hay en el titleLabel es “Welcome”. Si ejecutamos `CMD + U` vemos que pasa el test sin problemas. Fácil, ¿no?

Seguimos y ahora añadimos en el Storyboard un label que enlazamos en el `ViewController` y en el viewDidLoad le asignamos un texto.

```
import UIKit

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Welcome"
      return label
    }()
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = "Alfonso"
    }
}
```

Ahora vamos a hacer su test. Si lo hacemos igual que antes veremos que no es que falle el test, es que nos da un crash. Esto es porque tenemos que cargar el ViewController a partir del Storyboard para que el nameLabel no sea nil, así que lo hacemos y comprobamos el texto igual que haciamos en el ejemplo anterior.

```
func test_viewController_nameLabel_is_Alfonso() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "viewController") as! ViewController
        
        XCTAssertEqual(viewController.nameLabel.text!, "Alfonso")
    }
```

Y si lo ejecutamos vemos que de nuevo nos da el mismo error, nameLabel nos sigue llegando nil. Nos falta que se ejecuten los eventos de un ViewController necesarios para que se cargue todo correctamente, y lo hacemos con beginAppearanceTransition de la siguiente forma:

```
func test_viewController_nameLabel_is_Alfonso() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "viewController") as! ViewController
        viewController.beginAppearanceTransition(true, animated: false)
        XCTAssertEqual(viewController.nameLabel.text!, "Alfonso")
        viewController.endAppearanceTransition()
    }
```

Y ahora si que todo funciona correctamente y pasamos el test. El ejemplo es muy simple, pero si en algún momento se toca ese label y se cambia, el test fallará y así evitará que se cometa ese error, porque o bien se ha cambiado el label de manera equivocada o hay que actualizar el test para que asuma un nuevo funcionamiento.

Lo complicamos un poquito más, y añadimos dos textFields y un botón en nuestro ViewController. La idea es que en uno de los textField se escriba el nombre y en el otro el apellido, y que al darle al botón en el label se formatee correctamente poniendo el nombre, un espacio, y el apellido. El ViewController quedaría así.

```
import UIKit

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Welcome"
      return label
    }()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNmeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = "Alfonso"
    }
    
    @IBAction func composeFullNameAction() {
        if let name = nameTextField.text, let lastName = lastNmeTextField.text {
            self.nameLabel.text = "\(name) \(lastName)"
        }
    }
}
```

Ahora tenemos que probar que tras pulsarse el botón el resultado en el label es el que nosotros esperamos, así que añadimos este test.

```
func test_viewController_compose_name_label() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "viewController") as! ViewController
        
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.nameTextField.text = "alfonso"
        viewController.lastNmeTextField.text = "miranda"
        viewController.composeButton.sendActions(for: .touchUpInside)
        XCTAssertEqual("alfonso miranda", viewController.nameLabel.text!)
        viewController.endAppearanceTransition()
    }
```

Podemos ver que mediante el método sendActions del botón simulamos el touch en ese botón y podemos comprobar que el resultado es el deseado.

Aquí podemos probar lo que hablábamos antes. Como vemos, en el ejemplo he puesto tanto el nombre y el apellido empezando en minúscula (es un error pensado). Imaginad que en nuestra aplicación, aunque el usuario lo ponga empezando por minúscula lo formateamos y ponemos la primera letra en mayúsculas. Si hacemos ese cambio en el código y ejecutamos ese test, fallará. En este caso el comportamiento ha cambiado y tenemos que arreglar el test asegurando que en vez de lo anteriormente escrito ahora sea

```
XCTAssertEqual("Alfonso Miranda", viewController.nameLabel.text!)
```

# Los pasos para un test: given, when, then.

Hay una práctica llamada given, when, then, definido por Martin Fowler que se usa para hacer más ordenados y legibles los tests. Se trata de dividir en tres partes un test:

* Given: Correspondería con la preparación del test, cargarlo en el estado inicial, lo que en un caso de uso serían las pre-condiciones.
* When: Se añaden las condiciones en las que queremos hacer el test.
* Then: Se realiza el test y se obtienen los resultados.

Swift no es una excepción, y podemos usar el último ejemplo del punto anterior para explicarlo. Given es la parte que prepara el test y carga lo que necesitamos, en este caso sería

```
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let viewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
```

When sería:

```
viewController.nameTextField.text = "alfonso"
viewController.lastNmeTextField.text = "miranda"
viewController.composeButton.sendActions(for: .touchUpInside)
```

Y Then:

```
XCTAssertEqual("Alfonso Miranda", viewController.nameLabel.text!)
```

# Mocks: qué son y cómo usarlos.

Por último en esta introducción al maravilloso mundo de los tests vamos a hablar de los mocks, aunque esto lo veremos más detenidamente en el siguiente artículo donde hablaremos de testing con VIPER.

Cuando queremos testear una parte de nuestro código, una capa o una vista, podemos estar haciendo ahí uso de elementos que no son el objetivo de probarlo estos tests que estamos haciendo, si no que son una herramienta que usamos pero que deberían tener sus propios tests sin interferir en los de este trozo de código.

Un ejemplo sería cuando testeamos una vista que recibe una serie de datos para pintarlos en ella, de un servicio por ejemplo. Para testear esa vista no tenemos que probar que los servicios funcionan, si no que cuando se reciban los datos lo pintamos en el sitio correcto.

Vamos a hacer un ejemplo con este caso de uso en concreto. Imaginaros que tenemos un provider que consume un api rest que nos devuelve una película, con su descripción, su director y su año. Nos creamos el provider y un modelo para lo que nos devuelve la api y lo llamamos desde la vista. La llamada será desde un botón y lo pintaremos en un par de labels que añadimos en el storyboard y en el viewController. Vamos a dar por supuesto que tenemos el provider y el modelo hecho donde implementaremos un protocolo (al final del artículo pondré un enlace al proyecto completo).

Nuestro ViewController quedaría de la siguiente forma:

```
import UIKit

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Welcome"
      return label
    }()
    
    var movieProvider: MovieProvider = MovieProviderImplementation()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNmeTextField: UITextField!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var descriptionMovieLabel: UILabel!
    @IBOutlet weak var getMovieButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = "Alfonso"
    }
    
    @IBAction func composeFullNameAction() {
        if let name = nameTextField.text, let lastName = lastNmeTextField.text {
            self.nameLabel.text = "\(name.capitalized) \(lastName.capitalized)"
        }
    }
    
    @IBAction func getBestMovie() {
        movieProvider.getMovie(success: { (movie) in
            self.titleMovieLabel.text = movie.title
            self.descriptionMovieLabel.text = movie.movieEntityDescription
        }) { (error) in
            debugPrint("Error")
        }
    }
}
```

Como vemos es lo descrito anteriormente, al pulsar el botón esperamos la respuesta, y cuando la tenemos rellenamos esos dos labels. Hemos creado una acción para ello y hemos además añadido un IBOutlet para el botón, que nos hará falta para realizar los tests.

Nuestro provider, llamado MovieProvider, implementa a este protocolo:

```
protocol MovieProvider {
    func getMovie(success: @escaping(MovieEntity) -> Void, failure: @escaping(EError) -> Void)
}
```

Y nos ponemos a testear esto pero, ¿cómo lo hacemos?

Lo primero que pensaríamos en hacer una llamada real al servicio y testearlo pero esto tiene un problema: si el servicio falla, nuestros tests fallan, y sería engañoso ya que nuestro código está bien, lo que no está funcionando son los servicios y no es nuestra responsabilidad.

Así que vamos a hacer un mock de este provider en primer lugar:

```
import Foundation
@testable import TestingBasic

class MovieProviderMock: MovieProvider {
    var isGetMovieCalled = false
    var successState = false
    
    func getMovie(success: @escaping (MovieEntity) -> Void, failure: @escaping (EError) -> Void) {
        self.isGetMovieCalled = true
        
        if successState {
            let entity = MovieEntity(title: "Terminator 2", year: "1992", movieEntityDescription: "Un robot malo intentando matar a un niño", director: "Steven Spilberg")
            success(entity)
        }
    }
}
```

Lo que estamos haciendo es hacer una implementación mockeada de nuestro provider. Tengo por costumbre, en primer lugar, tener un flag que me indique que ha ejecutado el método o no, para después en los tests comprobarlo. Además he añadido otro flag para indicar si quiero probar cuando ha ido todo bien o cuando ha habido un error, aunque en este caso solo he puesto salida para cuando todo ha ido correctamente.

En este caso me creo un MovieEntity (nuestro modelo) y lo devuelvo en el bloque de success.

Y con esto ya podemos crearnos nuestro test para comprobar qué pasa cuando le damos al botón de obtener la película, que sería de la siguiente forma:

```
func test_viewController_get_movie_when_is_success() {
        //GIVEN
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "viewController") as! ViewController
        viewController.beginAppearanceTransition(true, animated: false)
        //WHEN
        let provider = MovieProviderMock()
        provider.successState = true
        viewController.movieProvider = provider
        viewController.getMovieButton.sendActions(for: .touchUpInside)
        //THEN
        XCTAssert(provider.isGetMovieCalled)
        XCTAssert(viewController.titleMovieLabel.text == "Terminator 2")
        viewController.endAppearanceTransition()
    }
```

Como podemos ver, el principio es similar a los anteriores tests, preparando en el GIVEN el test. En el WHEN inyectamos nuestro provider mockeado y “pulsamos” el botón de obtener la película. Y por último hacemos dos comprobaciones: que el método “GetMovie” ha sido llamado y que la respuesta se ha pintado en los labels correctos y con la información que esperábamos.

Es muy sencillo, en resumen todos los tests son similares a estos y en el siguiente artículo, usando VIPER como arquitectura, podremos profundizar más en estos conceptos.

Os dejo [aquí](https://github.com/alfonsomiranda/Testing-in-swift/tree/basic/TestingBasic/TestingBasic) todo el código del proyecto.