Class {
	#name : #GHRun,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'displayTitle',
		'nodeId',
		'runNumber',
		'event',
		'status',
		'conclusion',
		'workflowId',
		'checkSuiteId',
		'url',
		'htmlUrl',
		'createdAt',
		'updatedAt',
		'runStartedAt',
		'runAttempt',
		'actor',
		'triggeringActor',
		'headCommit',
		'repository',
		'workflow',
		'attempts'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHRun class >> fromDictionary: aDictionary [
    | createdAtValue updatedAtValue runStartedAtValue actorValue triggeringActorValue headCommitValue repositoryValue workflowValue attemptsValue |
    
    createdAtValue := aDictionary at: 'created_at' ifAbsent: [ aDictionary at: #createdAt ifAbsent: [ nil ] ].
    updatedAtValue := aDictionary at: 'updated_at' ifAbsent: [ aDictionary at: #updatedAt ifAbsent: [ nil ] ].
    runStartedAtValue := aDictionary at: 'run_started_at' ifAbsent: [ aDictionary at: #runStartedAt ifAbsent: [ nil ] ].
    actorValue := aDictionary at: 'actor' ifAbsent: [ aDictionary at: #actor ifAbsent: [ nil ] ].
    triggeringActorValue := aDictionary at: 'triggering_actor' ifAbsent: [ aDictionary at: #triggeringActor ifAbsent: [ nil ] ].
    headCommitValue := aDictionary at: 'head_commit' ifAbsent: [ aDictionary at: #headCommit ifAbsent: [ nil ] ].
    repositoryValue := aDictionary at: 'repository' ifAbsent: [ aDictionary at: #repository ifAbsent: [ nil ] ].
    workflowValue := aDictionary at: 'workflow' ifAbsent: [ aDictionary at: #workflow ifAbsent: [ nil ] ].
    attemptsValue := aDictionary at: 'run_attempts' ifAbsent: [ aDictionary at: #attempts ifAbsent: [ nil ] ].
    
    ^ self new
        id: (aDictionary at: 'id' ifAbsent: [ aDictionary at: #id ifAbsent: [ nil ] ]);
        name: (aDictionary at: 'name' ifAbsent: [ aDictionary at: #name ifAbsent: [ nil ] ]);
        displayTitle: (aDictionary at: 'display_title' ifAbsent: [ aDictionary at: #displayTitle ifAbsent: [ nil ] ]);
        nodeId: (aDictionary at: 'node_id' ifAbsent: [ aDictionary at: #nodeId ifAbsent: [ nil ] ]);
        runNumber: (aDictionary at: 'run_number' ifAbsent: [ aDictionary at: #runNumber ifAbsent: [ nil ] ]);
        
        status: (aDictionary at: 'status' ifAbsent: [ aDictionary at: #status ifAbsent: [ nil ] ]);
        conclusion: (aDictionary at: 'conclusion' ifAbsent: [ aDictionary at: #conclusion ifAbsent: [ nil ] ]);
   
        createdAt: (createdAtValue ifNotNil: [ DateAndTime fromString: createdAtValue ]);
        updatedAt: (updatedAtValue ifNotNil: [ DateAndTime fromString: updatedAtValue ]);
        actor: (actorValue ifNotNil: [ GHActor fromDictionary: actorValue ]);
        repository: (repositoryValue ifNotNil: [ GHRepository fromDictionary: repositoryValue ]);
        workflow: (workflowValue ifNotNil: [ GHWorkflow fromDictionary: workflowValue ]);
        attempts: (attemptsValue ifNotNil: [ attemptsValue isArray 
            ifTrue: [ attemptsValue collect: [ :a | GHRunAttempt fromDictionary: a ] ]
            ifFalse: [ nil ] ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHRun class >> fromDictionaryList: anArray [
    ^ anArray collect: [ :dict | self fromDictionary: dict ]
]

{ #category : #'as yet unclassified' }
GHRun >> actor [
    ^ actor
]

{ #category : #'as yet unclassified' }
GHRun >> actor: anActor [
    actor := anActor
]

{ #category : #'as yet unclassified' }
GHRun >> attempts [
    ^ attempts
]

{ #category : #'as yet unclassified' }
GHRun >> attempts: aCollection [
    attempts := aCollection
]

{ #category : #'as yet unclassified' }
GHRun >> conclusion [
    ^ conclusion
]

{ #category : #'as yet unclassified' }
GHRun >> conclusion: aConclusion [
    conclusion := aConclusion
]

{ #category : #'as yet unclassified' }
GHRun >> createdAt [
    ^ createdAt
]

{ #category : #'as yet unclassified' }
GHRun >> createdAt: aDateTime [
    createdAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHRun >> displayTitle [
    ^ displayTitle
]

{ #category : #'as yet unclassified' }
GHRun >> displayTitle: aTitle [
    displayTitle := aTitle
]

{ #category : #'as yet unclassified' }
GHRun >> getMostRecentStartedAt [
    ^ runStartedAt ifNil: [ 
        createdAt ifNil: [ DateAndTime now ] ifNotNil: [ createdAt ] ]
]

{ #category : #'as yet unclassified' }
GHRun >> getTotalExecutionTime [
    | totalTime |
    totalTime := 0.
    attempts ifNotNil: [ 
        attempts do: [ :element | totalTime := totalTime + element getExecutionTime ] ].
    ^ totalTime
]

{ #category : #'as yet unclassified' }
GHRun >> id [
    ^ id
]

{ #category : #'as yet unclassified' }
GHRun >> id: anId [
    id := anId
]

{ #category : #'as yet unclassified' }
GHRun >> name [
    ^ name
]

{ #category : #'as yet unclassified' }
GHRun >> name: aName [
    name := aName
]

{ #category : #'as yet unclassified' }
GHRun >> nodeId [
    ^ nodeId
]

{ #category : #'as yet unclassified' }
GHRun >> nodeId: aNodeId [
    nodeId := aNodeId
]

{ #category : #'as yet unclassified' }
GHRun >> repository [
    ^ repository
]

{ #category : #'as yet unclassified' }
GHRun >> repository: aRepository [
    repository := aRepository
]

{ #category : #'as yet unclassified' }
GHRun >> runNumber [
    ^ runNumber
]

{ #category : #'as yet unclassified' }
GHRun >> runNumber: aNumber [
    runNumber := aNumber
]

{ #category : #'as yet unclassified' }
GHRun >> status [
    ^ status
]

{ #category : #'as yet unclassified' }
GHRun >> status: aStatus [
    status := aStatus
]

{ #category : #'as yet unclassified' }
GHRun >> totalExecutionTime [
    ^ attempts 
        ifNil: [ 0 ]
        ifNotNil: [ attempts inject: 0 into: [ :total :attempt | total + attempt getExecutionTime ] ]
]

{ #category : #'as yet unclassified' }
GHRun >> updatedAt [
    ^ updatedAt
]

{ #category : #'as yet unclassified' }
GHRun >> updatedAt: aDateTime [
    updatedAt := aDateTime
]

{ #category : #'as yet unclassified' }
GHRun >> workflow [
    ^ workflow
]

{ #category : #'as yet unclassified' }
GHRun >> workflow: aWorkflow [
    workflow := aWorkflow
]
