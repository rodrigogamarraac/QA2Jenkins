Feature: Crud para crear Usuario

  Background:
    * url 'https://gorest.co.in/public/v2'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer 20970298190bb0e81d7c7d56094dac4b84a00abc4f87c2f4799f2747022d5241'
    * def req_headers = {Authorization: 'Bearer 20970298190bb0e81d7c7d56094dac4b84a00abc4f87c2f4799f2747022d5241'}
    * def dataGenerator = Java.type('Utils.DataGenerator')



Scenario: Crear Usuario Nuevo usando FakeData
    * def emailFake = dataGenerator.getEmailRandom()
    * def nameFake = dataGenerator.getRandonName()
    Given path 'users'
    And request {"name":#(nameFake), "gender":"male", "email":#(emailFake), "status":"active"}
    When method Post
    Then status 201
    And match response ==
    """
        {
        "id": "#number",
        "name": "#string",
        "email": "#string",
        "gender": "#string",
        "status": "#string"
        }

    """

 Scenario: Obtener Datos de un Usuario
    * def payload = dataGenerator.getUserRandom()
    Given path 'users'
    And request payload
    When method Post
    Then status 201
    * def userid = response.id
    * print userid
    Given path 'users' , userid
    And headers req_headers
    When method Get
    Then status 200
    And match response.email == payload.email

Scenario: Actualizar datos de un usuario
    * def payload = dataGenerator.getUserRandom()

    Given path 'users'
    And request payload
    When method post
    Then status 201

    * def userId = response.id
    * def nuevoNombre = dataGenerator.getRandonName()

    Given path 'users', userId
    And headers req_headers
    And request { name: '#(nuevoNombre)', status: 'inactive' }
    When method patch
    Then status 200
    And match response.id == userId
    And match response.name == nuevoNombre
    And match response.status == 'inactive'

Scenario: Eliminar un usuario
    * def payload = dataGenerator.getUserRandom()

    Given path 'users'
    And request payload
    When method post
    Then status 201

    * def userId = response.id

    Given path 'users', userId
    And headers req_headers
    When method delete
    Then status 204

    Given path 'users', userId
    And headers req_headers
    When method get
    Then status 404
    And match response.message == 'Resource not found'