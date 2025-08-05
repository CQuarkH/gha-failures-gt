Class {
	#name : #GHRepository,
	#superclass : #Object,
	#instVars : [
		'id',
		'fullName',
		'description',
		'owner',
		'fork',
		'url'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHRepository class >> fromDictionary: aDictionary [
    | ownerValue |
    ownerValue := aDictionary at: 'owner' ifAbsent: [ aDictionary at: #owner ifAbsent: [ nil ] ].
    ^ self new
        id: (aDictionary at: 'id' ifAbsent: [ aDictionary at: #id ifAbsent: [ nil ] ]);
        fullName: (aDictionary at: 'full_name' ifAbsent: [ aDictionary at: #fullName ifAbsent: [ nil ] ]);
        description: (aDictionary at: 'description' ifAbsent: [ aDictionary at: #description ifAbsent: [ nil ] ]);
        owner: (ownerValue ifNotNil: [ GHActor fromDictionary: ownerValue ]);
        fork: (aDictionary at: 'fork' ifAbsent: [ aDictionary at: #fork ifAbsent: [ nil ] ]);
        url: (aDictionary at: 'url' ifAbsent: [ aDictionary at: #url ifAbsent: [ nil ] ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHRepository >> description [
    ^ description
]

{ #category : #'as yet unclassified' }
GHRepository >> description: aDescription [
    description := aDescription
]

{ #category : #'as yet unclassified' }
GHRepository >> fork [
    ^ fork
]

{ #category : #'as yet unclassified' }
GHRepository >> fork: aBoolean [
    fork := aBoolean
]

{ #category : #'as yet unclassified' }
GHRepository >> fullName [
    ^ fullName
]

{ #category : #'as yet unclassified' }
GHRepository >> fullName: aName [
    fullName := aName
]

{ #category : #'as yet unclassified' }
GHRepository >> id [
    ^ id
]

{ #category : #'as yet unclassified' }
GHRepository >> id: anId [
    id := anId
]

{ #category : #'as yet unclassified' }
GHRepository >> owner [
    ^ owner
]

{ #category : #'as yet unclassified' }
GHRepository >> owner: anOwner [
    owner := anOwner
]

{ #category : #'as yet unclassified' }
GHRepository >> url [
    ^ url
]

{ #category : #'as yet unclassified' }
GHRepository >> url: anUrl [
    url := anUrl
]
