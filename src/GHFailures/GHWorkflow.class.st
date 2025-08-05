Class {
	#name : #GHWorkflow,
	#superclass : #Object,
	#instVars : [
		'id',
		'nodeId',
		'name',
		'path',
		'state',
		'htmlUrl',
		'createdAt',
		'updatedAt',
		'runners'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHWorkflow class >> fromDictionary: aDictionary [
    | createdAtValue updatedAtValue |
    createdAtValue := aDictionary at: 'created_at' ifAbsent: [ aDictionary at: #createdAt ifAbsent: [ nil ] ].
    updatedAtValue := aDictionary at: 'updated_at' ifAbsent: [ aDictionary at: #updatedAt ifAbsent: [ nil ] ].
    ^ self new
        id: (aDictionary at: 'id' ifAbsent: [ aDictionary at: #id ifAbsent: [ nil ] ]);
        nodeId: (aDictionary at: 'node_id' ifAbsent: [ aDictionary at: #nodeId ifAbsent: [ nil ] ]);
        name: (aDictionary at: 'name' ifAbsent: [ aDictionary at: #name ifAbsent: [ nil ] ]);
        path: (aDictionary at: 'path' ifAbsent: [ aDictionary at: #path ifAbsent: [ nil ] ]);
        runners: (aDictionary at: 'runners' ifAbsent: [ aDictionary at: #runners ifAbsent: [ nil ] ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHWorkflow >> id [
    ^ id
]

{ #category : #'as yet unclassified' }
GHWorkflow >> id: anId [
    id := anId
]

{ #category : #'as yet unclassified' }
GHWorkflow >> name [
    ^ name
]

{ #category : #'as yet unclassified' }
GHWorkflow >> name: aName [
    name := aName
]

{ #category : #'as yet unclassified' }
GHWorkflow >> nodeId [
    ^ nodeId
]

{ #category : #'as yet unclassified' }
GHWorkflow >> nodeId: aNodeId [
    nodeId := aNodeId
]

{ #category : #'as yet unclassified' }
GHWorkflow >> path [
    ^ path
]

{ #category : #'as yet unclassified' }
GHWorkflow >> path: aPath [
    path := aPath
]

{ #category : #'as yet unclassified' }
GHWorkflow >> runners [
    ^ runners
]

{ #category : #'as yet unclassified' }
GHWorkflow >> runners: aCollection [
    runners := aCollection
]
