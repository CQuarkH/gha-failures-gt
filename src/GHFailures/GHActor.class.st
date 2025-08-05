Class {
	#name : #GHActor,
	#superclass : #Object,
	#instVars : [
		'id',
		'login',
		'url',
		'type'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHActor class >> fromDictionary: aDictionary [
    ^ self new
        id: (aDictionary at: 'id' ifAbsent: [ aDictionary at: #id ifAbsent: [ nil ] ]);
        login: (aDictionary at: 'login' ifAbsent: [ aDictionary at: #login ifAbsent: [ nil ] ]);
        url: (aDictionary at: 'url' ifAbsent: [ aDictionary at: #url ifAbsent: [ nil ] ]);
        type: (aDictionary at: 'type' ifAbsent: [ aDictionary at: #type ifAbsent: [ nil ] ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHActor >> id [
    ^ id
]

{ #category : #'as yet unclassified' }
GHActor >> id: anId [
    id := anId
]

{ #category : #'as yet unclassified' }
GHActor >> login [
    ^ login
]

{ #category : #'as yet unclassified' }
GHActor >> login: aLogin [
    login := aLogin
]

{ #category : #'as yet unclassified' }
GHActor >> type [
    ^ type
]

{ #category : #'as yet unclassified' }
GHActor >> type: aType [
    type := aType
]

{ #category : #'as yet unclassified' }
GHActor >> url [
    ^ url
]

{ #category : #'as yet unclassified' }
GHActor >> url: anUrl [
    url := anUrl
]
