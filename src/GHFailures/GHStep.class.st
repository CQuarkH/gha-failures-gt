Class {
	#name : #GHStep,
	#superclass : #Object,
	#instVars : [
		'name',
		'status',
		'number',
		'conclusion',
		'startedAt',
		'completedAt',
		'log',
		'workflowCode'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHStep class >> fromDictionary: aDictionary [
    | startedAtValue completedAtValue |
    startedAtValue := aDictionary at: 'started_at' ifAbsent: [ aDictionary at: #startedAt ifAbsent: [ nil ] ].
    completedAtValue := aDictionary at: 'completed_at' ifAbsent: [ aDictionary at: #completedAt ifAbsent: [ nil ] ].
    ^ self new
        name: (aDictionary at: 'name' ifAbsent: [ aDictionary at: #name ifAbsent: [ nil ] ]);
        status: (aDictionary at: 'status' ifAbsent: [ aDictionary at: #status ifAbsent: [ nil ] ]);
        number: (aDictionary at: 'number' ifAbsent: [ aDictionary at: #number ifAbsent: [ nil ] ]);
        conclusion: (aDictionary at: 'conclusion' ifAbsent: [ aDictionary at: #conclusion ifAbsent: [ nil ] ]);
        startedAt: (startedAtValue ifNotNil: [ DateAndTime fromString: startedAtValue ]);
        completedAt: (completedAtValue ifNotNil: [ DateAndTime fromString: completedAtValue ]);
        log: (aDictionary at: 'log_content' ifAbsent: [ '' ]);
        workflowCode: (aDictionary at: 'workflow_code' ifAbsent: [ '' ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHStep class >> fromDictionaryArray: anArray [
    ^ anArray isArray
        ifTrue: [ anArray collect: [ :each | self fromDictionary: each ] ]
        ifFalse: [ OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
GHStep >> completedAt [
    ^ completedAt
]

{ #category : #'as yet unclassified' }
GHStep >> completedAt: aDateTime [
    completedAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHStep >> conclusion [
    ^ conclusion
]

{ #category : #'as yet unclassified' }
GHStep >> conclusion: aConclusion [
    conclusion := aConclusion
]

{ #category : #'as yet unclassified' }
GHStep >> executionTime [
	^ (self completedAt - self startedAt) / 1 second
]

{ #category : #'as yet unclassified' }
GHStep >> log [
    ^ log
]

{ #category : #'as yet unclassified' }
GHStep >> log: aLog [
    log := aLog
]

{ #category : #'as yet unclassified' }
GHStep >> name [
    ^ name
]

{ #category : #'as yet unclassified' }
GHStep >> name: aName [
    name := aName
]

{ #category : #'as yet unclassified' }
GHStep >> number [
    ^ number
]

{ #category : #'as yet unclassified' }
GHStep >> number: aNumber [
    number := aNumber
]

{ #category : #'as yet unclassified' }
GHStep >> startedAt [
    ^ startedAt
]

{ #category : #'as yet unclassified' }
GHStep >> startedAt: aDateTime [
    startedAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHStep >> status [
    ^ status
]

{ #category : #'as yet unclassified' }
GHStep >> status: aStatus [
    status := aStatus
]

{ #category : #'as yet unclassified' }
GHStep >> workflowCode [
    ^ workflowCode
]

{ #category : #'as yet unclassified' }
GHStep >> workflowCode: aCode [
    workflowCode := aCode
]
