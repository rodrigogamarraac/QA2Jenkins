Feature: CRUD de publicaciones

Background:
    * url 'https://gorest.co.in/public/v2'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer 20970298190bb0e81d7c7d56094dac4b84a00abc4f87c2f4799f2747022d5241'
    * def req_headers = { Authorization: 'Bearer 20970298190bb0e81d7c7d56094dac4b84a00abc4f87c2f4799f2747022d5241' }
    * def dataGenerator = Java.type('Utils.DataGenerator')


Scenario: Crear una publicación
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id
    * def postPayload =
    """
    {
      "user_id": "#(userId)",
      "title": "Publicación creada con Karate",
      "body": "Contenido de prueba de la publicación"
    }
    """

    Given path 'posts'
    And headers req_headers
    And request postPayload
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.user_id == userId
    And match response.title == postPayload.title
    And match response.body == postPayload.body


Scenario: Obtener datos de una publicación
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id
    * def postPayload =
    """
    {
      "user_id": "#(userId)",
      "title": "Publicación para consultar",
      "body": "Contenido para consultar"
    }
    """

    Given path 'posts'
    And headers req_headers
    And request postPayload
    When method post
    Then status 201

    * def postId = response.id

    Given path 'posts', postId
    And headers req_headers
    When method get
    Then status 200
    And match response.id == postId
    And match response.user_id == userId
    And match response.title == postPayload.title
    And match response.body == postPayload.body


Scenario: Actualizar datos de una publicación
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id
    * def postPayload =
    """
    {
      "user_id": "#(userId)",
      "title": "Título original",
      "body": "Contenido original"
    }
    """

    Given path 'posts'
    And headers req_headers
    And request postPayload
    When method post
    Then status 201

    * def postId = response.id
    * def nuevoTitulo = 'Título actualizado con Karate'
    * def nuevoContenido = 'Contenido actualizado con Karate'

    Given path 'posts', postId
    And headers req_headers
    And request
    """
    {
      "title": "#(nuevoTitulo)",
      "body": "#(nuevoContenido)"
    }
    """
    When method patch
    Then status 200
    And match response.id == postId
    And match response.user_id == userId
    And match response.title == nuevoTitulo
    And match response.body == nuevoContenido


Scenario: Eliminar una publicación
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id
    * def postPayload =
    """
    {
      "user_id": "#(userId)",
      "title": "Publicación para eliminar",
      "body": "Contenido para eliminar"
    }
    """

    Given path 'posts'
    And headers req_headers
    And request postPayload
    When method post
    Then status 201

    * def postId = response.id

    Given path 'posts', postId
    And headers req_headers
    When method delete
    Then status 204

    Given path 'posts', postId
    And headers req_headers
    When method get
    Then status 404
    And match response.message == 'Resource not found'