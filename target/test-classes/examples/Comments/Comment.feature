Feature: CRUD de comentarios

Background:
    * url 'https://gorest.co.in/public/v2'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer 20970298190bb0e81d7c7d56094dac4b84a00abc4f87c2f4799f2747022d5241'
    * def req_headers = { Authorization: 'Bearer 20970298190bb0e81d7c7d56094dac4b84a00abc4f87c2f4799f2747022d5241' }
    * def dataGenerator = Java.type('Utils.DataGenerator')


Scenario: Crear un comentario usando FakeData
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id

    Given path 'posts'
    And headers req_headers
    And request
    """
    {
      "user_id": "#(userId)",
      "title": "Publicación para comentarios",
      "body": "Contenido de la publicación"
    }
    """
    When method post
    Then status 201

    * def postId = response.id
    * def commentName = dataGenerator.getRandonName()
    * def commentEmail = dataGenerator.getEmailRandom()
    * def commentPayload =
    """
    {
      "post_id": "#(postId)",
      "name": "#(commentName)",
      "email": "#(commentEmail)",
      "body": "Comentario creado con Karate"
    }
    """

    Given path 'comments'
    And headers req_headers
    And request commentPayload
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.post_id == postId
    And match response.name == commentName
    And match response.email == commentEmail
    And match response.body == commentPayload.body


Scenario: Obtener datos de un comentario
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id

    Given path 'posts'
    And headers req_headers
    And request
    """
    {
      "user_id": "#(userId)",
      "title": "Publicación para consultar comentario",
      "body": "Contenido de prueba"
    }
    """
    When method post
    Then status 201

    * def postId = response.id
    * def commentPayload =
    """
    {
      "post_id": "#(postId)",
      "name": "Usuario de prueba",
      "email": "#(dataGenerator.getEmailRandom())",
      "body": "Comentario para consultar"
    }
    """

    Given path 'comments'
    And headers req_headers
    And request commentPayload
    When method post
    Then status 201

    * def commentId = response.id

    Given path 'comments', commentId
    And headers req_headers
    When method get
    Then status 200
    And match response.id == commentId
    And match response.post_id == postId
    And match response.name == commentPayload.name
    And match response.email == commentPayload.email
    And match response.body == commentPayload.body


Scenario: Actualizar datos de un comentario
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id

    Given path 'posts'
    And headers req_headers
    And request
    """
    {
      "user_id": "#(userId)",
      "title": "Publicación para actualizar comentario",
      "body": "Contenido de prueba"
    }
    """
    When method post
    Then status 201

    * def postId = response.id

    Given path 'comments'
    And headers req_headers
    And request
    """
    {
      "post_id": "#(postId)",
      "name": "Nombre original",
      "email": "#(dataGenerator.getEmailRandom())",
      "body": "Comentario original"
    }
    """
    When method post
    Then status 201

    * def commentId = response.id
    * def nuevoNombre = dataGenerator.getRandonName()
    * def nuevoComentario = 'Comentario actualizado con Karate'

    Given path 'comments', commentId
    And headers req_headers
    And request
    """
    {
      "name": "#(nuevoNombre)",
      "body": "#(nuevoComentario)"
    }
    """
    When method patch
    Then status 200
    And match response.id == commentId
    And match response.post_id == postId
    And match response.name == nuevoNombre
    And match response.body == nuevoComentario


Scenario: Eliminar un comentario
    * def userPayload = dataGenerator.getUserRandom()

    Given path 'users'
    And request userPayload
    When method post
    Then status 201

    * def userId = response.id

    Given path 'posts'
    And headers req_headers
    And request
    """
    {
      "user_id": "#(userId)",
      "title": "Publicación para eliminar comentario",
      "body": "Contenido de prueba"
    }
    """
    When method post
    Then status 201

    * def postId = response.id

    Given path 'comments'
    And headers req_headers
    And request
    """
    {
      "post_id": "#(postId)",
      "name": "Comentario temporal",
      "email": "#(dataGenerator.getEmailRandom())",
      "body": "Este comentario será eliminado"
    }
    """
    When method post
    Then status 201

    * def commentId = response.id

    Given path 'comments', commentId
    And headers req_headers
    When method delete
    Then status 204

    Given path 'comments', commentId
    And headers req_headers
    When method get
    Then status 404
    And match response.message == 'Resource not found'