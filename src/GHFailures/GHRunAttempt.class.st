Class {
	#name : #GHRunAttempt,
	#superclass : #Object,
	#instVars : [
		'runAttempt',
		'status',
		'conclusion',
		'updatedAt',
		'runStartedAt',
		'jobs'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHRunAttempt class >> fromDictionary: aDictionary [
    | updatedAtValue runStartedAtValue jobsValue |
    updatedAtValue := aDictionary at: 'updated_at' ifAbsent: [ aDictionary at: #updatedAt ifAbsent: [ nil ] ].
    runStartedAtValue := aDictionary at: 'run_started_at' ifAbsent: [ aDictionary at: #runStartedAt ifAbsent: [ nil ] ].
    jobsValue := aDictionary at: 'jobs' ifAbsent: [ aDictionary at: #jobs ifAbsent: [ nil ] ].
    
    ^ self new
        runAttempt: (aDictionary at: 'run_attempt' ifAbsent: [ aDictionary at: #runAttempt ifAbsent: [ nil ] ]);
        status: (aDictionary at: 'status' ifAbsent: [ aDictionary at: #status ifAbsent: [ nil ] ]);
        conclusion: (aDictionary at: 'conclusion' ifAbsent: [ aDictionary at: #conclusion ifAbsent: [ nil ] ]);
        updatedAt: (updatedAtValue ifNotNil: [ DateAndTime fromString: updatedAtValue ]);
        runStartedAt: (runStartedAtValue ifNotNil: [ DateAndTime fromString: runStartedAtValue ]);
        jobs: (jobsValue ifNotNil: [ jobsValue isArray 
            ifTrue: [ jobsValue collect: [ :j | GHJob fromDictionary: j ] ]
            ifFalse: [ nil ] ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHRunAttempt class >> fromDictionaryArray: anArray [
    ^ anArray isArray
        ifTrue: [ anArray collect: [ :item | self fromDictionary: item ] ]
        ifFalse: [ OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> conclusion [
    ^ conclusion
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> conclusion: aConclusion [
    conclusion := aConclusion
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> executionTime [
    | startTime endTime |
    
    startTime := self runStartedAt.
    endTime := self updatedAt.
    
    (startTime isNil or: [ endTime isNil ]) ifTrue: [ ^ 0 ].
    
    "Calcular diferencia en segundos"
    ^ (endTime asSeconds - startTime asSeconds) max: 0
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> getExecutionTime [
    ^ self executionTime
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> jobs [
    ^ jobs
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> jobs: aCollection [
    jobs := aCollection
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> runAttempt [
    ^ runAttempt
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> runAttempt: anAttempt [
    runAttempt := anAttempt
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> runStartedAt [
    ^ runStartedAt
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> runStartedAt: aDateTime [
    runStartedAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> status [
    ^ status
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> status: aStatus [
    status := aStatus
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> updatedAt [
    ^ updatedAt
]

{ #category : #'as yet unclassified' }
GHRunAttempt >> updatedAt: aDateTime [
    updatedAt := aDateTime
]
