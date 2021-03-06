//
//  OpenAPIServersBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 27.03.2018.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable type_body_length file_length

class Animal {
    var name: String
    var age: Int?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

/**
    Tests for paths components in OpenAPI standard (/paths).

    ```
    "paths": {
        "/animals": {
            "get": {
                "summary": "Returns all pets",
                "description": "Returns all pets from the system that the user has access to",
                "responses": {
                    "200": {
                        "description": "A list of pets.",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "array",
                                        "items": {
                                            "$ref": "#/components/schemas/pet"
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
            "post": {
                "summary": "Create new pet",
                "description": "Create new pet to the system",
                "requestBody": {
                    "description": "A list of pets.",
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/pet"
                            }
                        }
                    }
                }
                "responses": {
                    "200": {
                        "description": "A list of pets."
                    }
                }
            }
        }
    }
    ```
 */
class OpenAPIPathsBuilderTests: XCTestCase {

    func testActionRouteShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"], "Action route should be added to the tree.")
    }

    func testActionMethodShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"], "Action method should be added to the tree.")
    }

    func testActionSummaryShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Action summary", openAPIDocument.paths["/animals"]?.get?.summary)
    }

    func testActionDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Action description", openAPIDocument.paths["/animals"]?.get?.description)
    }

    func testActionCodeResponseShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description")
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"], "Action response code should be added to the tree.")
    }

    func testActionResponseDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description")
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Response description", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.description)
    }

    func testActionResponseContentShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: Animal.self)
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content, "Response content should be added to the tree.")
    }

    func testActionDefaultResponseContentTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: Animal.self)
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"],
            "Default response content type should be added to the tree.")
    }

    func testActionCustomResponseContentTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: Animal.self, contentType: "application/xml")
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/xml"],
            "Custom response content type should be added to the tree.")
    }

    func testActionResponseSchemaShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: Animal.self)
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema,
            "Response schema should be added to the tree.")
    }

    func testActionArrayResponseTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", array: Animal.self)
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("array", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.type)
    }

    func testActionObjectResponseReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: Animal.self)
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.ref)
    }

    func testActionArrayResponseReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", array: Animal.self)
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal",
            openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.items?.ref)
    }

    func testActionRequestBodyShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: Animal.self, description: "Animal request")

                )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.requestBody,
                        "Request body should be added to the tree.")
    }

    func testActionRequestBodyDefaultContentShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: Animal.self, description: "Animal request")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/json"],
                        "Default request content type should be added to the tree.")
    }

    func testActionRequestBodyCustomContentShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: Animal.self, description: "Animal request", contentType: "application/xml")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/xml"],
                        "Custom request content type should be added to the tree.")
    }

    func testActionRequestBodyDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: Animal.self, description: "Animal request")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Animal request", openAPIDocument.paths["/animals"]?.get?.requestBody?.description)
    }

    func testActionObjectRequestReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: Animal.self, description: "Animal request")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal", openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/json"]?.schema?.ref)
    }

    func testActionParameterNameShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals/{id}", summary: "Action summary", description: "Action description", parameters: [
                    APIParameter(name: "id", parameterLocation: .path, description: "Parameter description",
                                 required: true, deprecated: true, allowEmptyValue: true)
                ])
            ])
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("id", openAPIDocument.paths["/animals/{id}"]?.get?.parameters![0].name)
    }

    func testActionParameterLocationShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals/{id}", summary: "Action summary", description: "Action description", parameters: [
                    APIParameter(name: "id", parameterLocation: .path, description: "Parameter description",
                                 required: true, deprecated: true, allowEmptyValue: true)
                    ])
                ])
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual(APILocation.path, openAPIDocument.paths["/animals/{id}"]?.get?.parameters![0].parameterLocation)
    }

    func testActionParameterDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals/{id}", summary: "Action summary", description: "Action description", parameters: [
                    APIParameter(name: "id", parameterLocation: .path, description: "Parameter description",
                                 required: true, deprecated: true, allowEmptyValue: true)
                    ])
                ])
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Parameter description", openAPIDocument.paths["/animals/{id}"]?.get?.parameters![0].description)
    }

    static var allTests = [
        ("testActionRouteShouldBeAddedToOpenAPIDocument", testActionRouteShouldBeAddedToOpenAPIDocument),
        ("testActionMethodShouldBeAddedToOpenAPIDocument", testActionMethodShouldBeAddedToOpenAPIDocument),
        ("testActionSummaryShouldBeAddedToOpenAPIDocument", testActionSummaryShouldBeAddedToOpenAPIDocument),
        ("testActionDescriptionShouldBeAddedToOpenAPIDocument", testActionDescriptionShouldBeAddedToOpenAPIDocument),
        ("testActionCodeResponseShouldBeAddedToOpenAPIDocument", testActionCodeResponseShouldBeAddedToOpenAPIDocument),
        ("testActionResponseDescriptionShouldBeAddedToOpenAPIDocument", testActionResponseDescriptionShouldBeAddedToOpenAPIDocument),
        ("testActionResponseContentShouldBeAddedToOpenAPIDocument", testActionResponseContentShouldBeAddedToOpenAPIDocument),
        ("testActionDefaultResponseContentTypeShouldBeAddedToOpenAPIDocument", testActionDefaultResponseContentTypeShouldBeAddedToOpenAPIDocument),
        ("testActionCustomResponseContentTypeShouldBeAddedToOpenAPIDocument", testActionCustomResponseContentTypeShouldBeAddedToOpenAPIDocument),
        ("testActionResponseSchemaShouldBeAddedToOpenAPIDocument", testActionResponseSchemaShouldBeAddedToOpenAPIDocument),
        ("testActionArrayResponseTypeShouldBeAddedToOpenAPIDocument", testActionArrayResponseTypeShouldBeAddedToOpenAPIDocument),
        ("testActionObjectResponseReferenceShouldBeAddedToOpenAPIDocument", testActionObjectResponseReferenceShouldBeAddedToOpenAPIDocument),
        ("testActionArrayResponseReferenceShouldBeAddedToOpenAPIDocument", testActionArrayResponseReferenceShouldBeAddedToOpenAPIDocument),
        ("testActionRequestBodyShouldBeAddedToOpenAPIDocument", testActionRequestBodyShouldBeAddedToOpenAPIDocument),
        ("testActionRequestBodyDefaultContentShouldBeAddedToOpenAPIDocument", testActionRequestBodyDefaultContentShouldBeAddedToOpenAPIDocument),
        ("testActionRequestBodyCustomContentShouldBeAddedToOpenAPIDocument", testActionRequestBodyCustomContentShouldBeAddedToOpenAPIDocument),
        ("testActionRequestBodyDescriptionShouldBeAddedToOpenAPIDocument", testActionRequestBodyDescriptionShouldBeAddedToOpenAPIDocument),
        ("testActionObjectRequestReferenceShouldBeAddedToOpenAPIDocument", testActionObjectRequestReferenceShouldBeAddedToOpenAPIDocument),
        ("testActionParameterNameShouldBeAddedToOpenAPIDocument", testActionParameterNameShouldBeAddedToOpenAPIDocument),
        ("testActionParameterLocationShouldBeAddedToOpenAPIDocument", testActionParameterLocationShouldBeAddedToOpenAPIDocument),
        ("testActionParameterDescriptionShouldBeAddedToOpenAPIDocument", testActionParameterDescriptionShouldBeAddedToOpenAPIDocument)
    ]
}
