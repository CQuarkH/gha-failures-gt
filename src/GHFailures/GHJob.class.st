Class {
	#name : #GHJob,
	#superclass : #Object,
	#instVars : [
		'id',
		'nodeId',
		'name',
		'status',
		'conclusion',
		'createdAt',
		'startedAt',
		'completedAt',
		'url',
		'htmlUrl',
		'runnerName',
		'runnerGroupName',
		'runAttempt',
		'labels',
		'steps',
		'fullLog'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHJob class >> fromDictionary: aDictionary [
    | createdAtValue startedAtValue completedAtValue stepsValue |
    createdAtValue := aDictionary at: 'created_at' ifAbsent: [ aDictionary at: #createdAt ifAbsent: [ nil ] ].
    startedAtValue := aDictionary at: 'started_at' ifAbsent: [ aDictionary at: #startedAt ifAbsent: [ nil ] ].
    completedAtValue := aDictionary at: 'completed_at' ifAbsent: [ aDictionary at: #completedAt ifAbsent: [ nil ] ].
    stepsValue := aDictionary at: 'steps' ifAbsent: [ aDictionary at: #steps ifAbsent: [ nil ] ].
    
    ^ self new
        id: (aDictionary at: 'id' ifAbsent: [ aDictionary at: #id ifAbsent: [ nil ] ]);
        nodeId: (aDictionary at: 'node_id' ifAbsent: [ aDictionary at: #nodeId ifAbsent: [ nil ] ]);
        name: (aDictionary at: 'name' ifAbsent: [ aDictionary at: #name ifAbsent: [ nil ] ]);
        status: (aDictionary at: 'status' ifAbsent: [ aDictionary at: #status ifAbsent: [ nil ] ]);
        conclusion: (aDictionary at: 'conclusion' ifAbsent: [ aDictionary at: #conclusion ifAbsent: [ nil ] ]);
        createdAt: (createdAtValue ifNotNil: [ DateAndTime fromString: createdAtValue ]);
        startedAt: (startedAtValue ifNotNil: [ DateAndTime fromString: startedAtValue ]);
        completedAt: (completedAtValue ifNotNil: [ DateAndTime fromString: completedAtValue ]);
        runAttempt: (aDictionary at: 'run_attempt' ifAbsent: [ aDictionary at: #runAttempt ifAbsent: [ nil ] ]);
        steps: (stepsValue ifNotNil: [ stepsValue isArray 
            ifTrue: [ stepsValue collect: [ :s | GHStep fromDictionary: s ] ]
            ifFalse: [ nil ] ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHJob class >> fromDictionaryArray: anArray [
    ^ anArray isArray
        ifTrue: [ 
            anArray 
                select: [ :dict | 
                    | conclusion |
                    conclusion := dict at: 'conclusion' ifAbsent: [ dict at: #conclusion ifAbsent: [ nil ] ].
                    conclusion isNotNil and: [ conclusion asString trim isNotEmpty ] ]
                thenCollect: [ :dict | self fromDictionary: dict ] ]
        ifFalse: [ OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
GHJob >> completedAt [
    ^ completedAt
]

{ #category : #'as yet unclassified' }
GHJob >> completedAt: aDateTime [
    completedAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHJob >> conclusion [
    ^ conclusion
]

{ #category : #'as yet unclassified' }
GHJob >> conclusion: aConclusion [
    conclusion := aConclusion
]

{ #category : #'as yet unclassified' }
GHJob >> createdAt [
    ^ createdAt
]

{ #category : #'as yet unclassified' }
GHJob >> createdAt: aDateTime [
    createdAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHJob >> executionTime [
	^ (self completedAt - self startedAt) / 1 second
]

{ #category : #'as yet unclassified' }
GHJob >> id [
    ^ id
]

{ #category : #'as yet unclassified' }
GHJob >> id: anId [
    id := anId
]

{ #category : #'as yet unclassified' }
GHJob >> name [
    ^ name
]

{ #category : #'as yet unclassified' }
GHJob >> name: aName [
    name := aName
]

{ #category : #'as yet unclassified' }
GHJob >> nodeId [
    ^ nodeId
]

{ #category : #'as yet unclassified' }
GHJob >> nodeId: aNodeId [
    nodeId := aNodeId
]

{ #category : #'as yet unclassified' }
GHJob >> runAttempt [
    ^ runAttempt
]

{ #category : #'as yet unclassified' }
GHJob >> runAttempt: anAttempt [
    runAttempt := anAttempt
]

{ #category : #'as yet unclassified' }
GHJob >> startedAt [
    ^ startedAt
]

{ #category : #'as yet unclassified' }
GHJob >> startedAt: aDateTime [
    startedAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHJob >> status [
    ^ status
]

{ #category : #'as yet unclassified' }
GHJob >> status: aStatus [
    status := aStatus
]

{ #category : #'as yet unclassified' }
GHJob >> steps [
    ^ steps
]

{ #category : #'as yet unclassified' }
GHJob >> steps: aCollection [
    steps := aCollection
]
