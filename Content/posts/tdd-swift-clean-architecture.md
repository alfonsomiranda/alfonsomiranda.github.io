---
title: TDD en Swift con Clean Architecture
date: 2021-04-12 17:06
description:  TDD, Test Driven Development o Desarrollo guiado por pruebas es una forma o práctica de desarrollo donde, a muy grandes rasgos, se escriben las pruebas y a partir de ella se va implementando el código. La forma de hacer esto es ir creando las pruebas, que estas vayan fallando e ir arreglándolas refactorizando y creando el código necesario.
tags: test, swift, tdd, iOS
excerpt: TDD, Test Driven Development o Desarrollo guiado por pruebas es una forma o práctica de desarrollo donde, a muy grandes rasgos, se escriben las pruebas y a partir de ella se va implementando el código. La forma de hacer esto es ir creando las pruebas, que estas vayan fallando e ir arreglándolas refactorizando y creando el código necesario.
---

TDD, Test Driven Development o Desarrollo guiado por pruebas es una forma o práctica de desarrollo donde, a muy grandes rasgos, se escriben las pruebas y a partir de ella se va implementando el código. La forma de hacer esto es ir creando las pruebas, que estas vayan fallando e ir arreglándolas refactorizando y creando el código necesario.

Estas pruebas suelen ser tests unitarios, y cómo ya vimos en el [anterior artículo](https://alfonsomiranda.com/posts/tests-swift-basic-concepts/), es algo bastante sencillo y necesario.

# Ventajas

* **No se nos olvida hacer los tests**. Esta es la razón más obvia. Una de las excusas más usada para hacer tests es el tiempo que conllevan y, como lo dejamos para el final, no nos termina de encajar en el deadline que tengamos en el proyecto, además de quizás darnos mucha pereza hacerlo. Con esta metodología, cuando acabamos la implementación ya tenemos los tests hechos y con el deber de buen desarrollador cumplido.
* **Evitamos código innecesario**. Como veremos más adelante, TDD es algo más que escribir primero los tests, si no que implica una fase de refactorización que nos ayuda a eliminar todo código repetitivo o innecesario.
* **Documentación**. Para hacer los tests primero tenemos que tener muy claro las funcionalidades que queremos desarrollar, y es necesario tener una buena definición de requisitos y casos de uso, y los propios tests se convierte en una buena documentación de nuestro código.
* **Escalabilidad**. Al partir de los tests, el código final implementado tiene mucha más facilidad para que sea desarrollado cumpliendo ciertas reglas de `clean architecture`, lo cual va a proporcionar que nuestro código sea fácilmente escalable.

# Casos prácticos.

Vamos a ver cómo se puede hacer esta práctica en Swift, y para ello vamos a partir del [código](https://github.com/alfonsomiranda/Testing-in-swift/tree/basic) que usamos previamente para conocer los tests.

Empezamos por algo muy simple, aprovechando el código que ya tenemos. En el `ViewController` vamos a necesitar un método que nos concatene dos cadenas para los dos textfields que hay en la pantalla. Imaginad que no lo habíamos resuelto en el método `composeFullNameAction`, si no que lo haremos en otro método. Este método tendría como parámetros de entrada dos cadenas y devolvería otro `String`. En el `ViewController` creamos un método con esta definición pero sin ninguna implementación (solo devolviendo una cadena vacía para que no falle).

```
func concatenate(first: String, second: String) -> String {
    return ""
}
```
Ahora nos vamos al target de tests y añadimos un nuevo tests. Este test debe de comprobar si el método `concatenate` al pasarle dos cadenas devuelve la concatenación de ambas con la primera letra en mayúscula.

```
func test_concatenate_two_strings() {
    let viewController = ViewController()
    
    XCTAssertEqual(viewController.concatenate(first: "alfonso", second: "miranda"), "Alfonso Miranda")
}
```

Si ejecutamos este test obtenemos un error, obviamente, al no estar la implementación hecha. Esta fase de TDD se la conoce como `red`, fase roja donde estamos pensando qué queremos desarrollar y definiéndolo.

<img src="/images/tdd/tddRedState.png" alt="TDD Red state" width="800"/>

En este momento tenemos que ir a la implementación y darle una solución para que nuestro test pase. Nuestro método quedaría como sigue.

```
func concatenate(first: String, second: String) -> String {
    return first.capitalized + " " + second.capitalized
}
```
Y si ahora compilamos los tests vemos que lo pasa. Esta fase se la conoce como fase `green`, que consiste en, sea como sea, que nuestros tests pasen y estén en verde. 

<img src="/images/tdd/tddGreenState.png" alt="TDD Green state" width="800"/>

Este "sea como sea" lo digo porque en esta fase no es necesario que nuestro código sea perfecto, simplemente que cumpla nuestros requisitos. En TDD hay una tercera fase, que es la de refactorizar. Una vez pasado el test y tenerlo en verde, tenemos que hacer el código lo más limpio posible. En nuestro caso, al ser tan simple no es necesario refactorizar, pero en casos más complejos no vamos a escribir el código bien a la primera, e incluso TDD nos recomienda primero solucionar la implementación y después hacer todas las correcciones necesarias.

Podemos ver este ciclo en esta gráfica.

<img src="/images/tdd/test-driven-development.png" alt="TDD States" width="800"/>

Aunque me gusta más esta imagen de [Denise](https://quii.gitbook.io/learn-go-with-tests/), mucho más descriptiva.

<img src="/images/tdd/red-green-blue-gophers-smaller.png" alt="TDD Gophers" width="800"/>

La filosofía de TDD es básicamente estos tres estados y lo podemos aplicar a cualquier funcionalidad de nuestra aplicación.

Podemos verlo con un ejemplo más complejo, y de camino vemos como hacer testing con nuestra arquitectura limpia donde nos comunicamos desacoplando las capas a base de protocolos.

Si recordamos, en el proyecto teníamos un provider en el que habíamos implementado un método que nos obtenía una película de un endpoint que habíamos definido. Ahora vamos a necesitar obtener un listado de películas que nos proporciona otro endpoint, así que la funcionalidad que queremos desarrollar es un método que nos devuelva un array de `MovieEntity`. En MovieProvider definimos un nuevo método tal que así:

```
func getMovies(success: @escaping([MovieEntity]) -> Void, failure: @escaping(EError) -> Void) {
    
}
```

Nos vamos a nuestra clase de tests y añadimos uno nuevo que cumpla los requisitos que nos hemos impuesto. Para ello vemos que nos falta poder mockear el BaseProvider ya que, como vimos en el artículo anterior, todo lo que sea "externo" a lo que queremos probar lo tenemos que falsear. Pero si vemos como es nuestro BaseProvider, nos falta añadirle un protocolo para poder mockearlo correctamente. Además, como veremos más adelante, va a perder el sentido de ser Base, y lo vamos a utilizar más como un componente (necesario para poder testear donde se usa), así que lo modificamos así.

```
protocol ProviderProtocol {
    func request<T: Decodable>(entityClass: T.Type, endpoint: String, method: HTTPMethod, success: @escaping(_ entity: T) -> Void, failure: @escaping(EError) -> Void)
}


class Provider: ProviderProtocol {
    func request<T: Decodable>(entityClass: T.Type, endpoint: String, method: HTTPMethod, success: @escaping(_ entity: T) -> Void, failure: @escaping(EError) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: endpoint)!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            guard error == nil else {
                failure(EError(domain: endpoint, code: 0, localizedDescription: error?.localizedDescription ?? ""))
                return
            }
            guard let responseData = data else {
                failure(EError(domain: "", code: -1, localizedDescription: ""))
                return
            }
            do {
                if let response = try? JSONDecoder().decode(T.self, from: responseData) {
                    success(response)
                } else {
                    failure(EError(domain: "", code: -1, localizedDescription: ""))
                }
            }
        })
        task.resume()
    }
}

```

Y modificamos nuestro MovieProvider de forma que podamos inyectarle ese Provider y no heredar de él, porque como comentáamos antes el testeo se hace muy complicado. El resultado sería el siguiente.

```
import Foundation

protocol MovieProvider {
    func getMovie(success: @escaping(MovieEntity) -> Void, failure: @escaping(EError) -> Void)
}

class MovieProviderImplementation: MovieProvider {
    
    var provider: ProviderProtocol = Provider()
    
    func getMovie(success: @escaping(MovieEntity) -> Void, failure: @escaping(EError) -> Void) {
        provider.request(entityClass: MovieEntity.self, endpoint: "http://demo8628160.mockable.io/movie", method: .get, success: { (entity) in
            success(entity)
        }) { (error) in
            failure(error)
        }
    }
    
    func getMovies(success: @escaping([MovieEntity]) -> Void, failure: @escaping(EError) -> Void) {
        
    }
}
```

Ahora si podemos crearnos ese mock y quedaría de la siguiente forma.

```
import Foundation
@testable import TestingBasic

class ProviderMock: ProviderProtocol {
    var isRequestCalled = false
    var isSuccess = true
    
    func request<T>(entityClass: T.Type, endpoint: String, method: HTTPMethod, success: @escaping (T) -> Void, failure: @escaping (EError) -> Void) where T : Decodable {
        self.isRequestCalled = true
        
        if isSuccess {
            success([MovieEntity(title: "Terminator", year: "1985", movieEntityDescription: "", director: ""), MovieEntity(title: "Terminator", year: "1985", movieEntityDescription: "", director: ""), MovieEntity(title: "Terminator", year: "1985", movieEntityDescription: "", director: ""), MovieEntity(title: "Terminator", year: "1985", movieEntityDescription: "", director: "")] as! T)
        }
    }
}
```
Como todos los mocks, añado dos flags, uno para indicar que he pasado por el método y otro para controlar si quiero testear cuando todo ha ido bien o cuando ha habido error. Y en el caso de `success` devuelvo un array mockeado de MovieEntity.

Ahora nos vamos a hacer el test, y este tiene una peculiaridad y es que tenemos que probar bloques. Para ello tenemos que hacer uso de `expectation`, que nos simula una llamada en otro hilo para hacer la espera a que se ejecute ese bloque. Podemos verlo en este código.

```
func test_movieProvider_get_movies_when_is_success() {
    //GIVEN
    let provider = MovieProviderImplementation()
    let providerMock = ProviderMock()
    providerMock.isSuccess = true
    provider.provider = providerMock

    let expect = self.expectation(description: #function)
    
    //WHEN
    provider.getMovies { (movies) in
        XCTAssertEqual(movies.count, 4)
        expect.fulfill()
    } failure: { (error) in
        
    }
    
    waitForExpectations(timeout: 1.0) { error in
        XCTAssertNil(error)
        XCTAssertTrue(providerMock.isRequestCalled)
    }
}
```

Estamos en primer lugar inicializando `MovieProvider e inyectándole nuestro mock, indicándole que vamos a testear el bloque de success. En el bloque tenemos que llamar a `expect.fulfill()` y fuera de él añadimos un `watiForExpectations` con un timeout. De esta forma podemos probar que ese bloque se ejecuta correctamente y que devuelve lo que esperamos.

Si ejecutamos los tests vemos que, tras el tiempo que hemos indicado en el timeout, nos da error, ya que obviamente en nuestra implementación aún no estamos haciendo nada. Estamos en la fase roja, así que vamos a hacer esa implementación para pasar a verde.

```
func getMovies(success: @escaping([MovieEntity]) -> Void, failure: @escaping(EError) -> Void) {
    provider.request(entityClass: [MovieEntity].self, endpoint: "http://demo8628160.mockable.io/movies", method: .get) { (movies) in
        success(movies)
    } failure: { (error) in
        failure(error)
    }
}
```
Ya tenemos la implementación hecha, llamando a provider y devolviendo nuestro listado de MovieEntity. Si ahora ejecutamos los tests vemos que pasamos al estado verde y ya los pasamos.

A partir de aquí entraríamos en la parte de refactorización, mejorando el código, eliminando posibles duplicidades y probando el resultado con datos reales.

Tiene muchas ventajas trabajar según la metodología TDD como vimos al comienzo de este texto, y uno de los más valiosos es que cuando terminamos de desarrollar nuestra funcionalidad los tests ya están hechos, y no se nos "olvida" hacerlos.

[Aquí](https://github.com/alfonsomiranda/Testing-in-swift/tree/tdd) tenéis todo el código que hemos visto aquí por si quéreis trastear con él.
