Class {
	#name : #GHCommit,
	#superclass : #Object,
	#instVars : [
		'id',
		'treeId',
		'message',
		'timestamp',
		'authorName',
		'committerName'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHCommit class >> fromDictionary: aDictionary [
    | timestampValue |
    timestampValue := aDictionary at: 'timestamp' ifAbsent: [ aDictionary at: #timestamp ifAbsent: [ nil ] ].
    ^ self new
        id: (aDictionary at: 'id' ifAbsent: [ aDictionary at: #id ifAbsent: [ nil ] ]);
        treeId: (aDictionary at: 'tree_id' ifAbsent: [ aDictionary at: #treeId ifAbsent: [ nil ] ]);
        message: (aDictionary at: 'message' ifAbsent: [ aDictionary at: #message ifAbsent: [ nil ] ]);
        timestamp: (timestampValue ifNotNil: [ DateAndTime fromString: timestampValue ]);
        authorName: (aDictionary at: 'author_name' ifAbsent: [ aDictionary at: #authorName ifAbsent: [ nil ] ]);
        committerName: (aDictionary at: 'committer_name' ifAbsent: [ aDictionary at: #committerName ifAbsent: [ nil ] ]);
        yourself
]

{ #category : #'as yet unclassified' }
GHCommit >> authorName [
    ^ authorName
]

{ #category : #'as yet unclassified' }
GHCommit >> authorName: anAuthorName [
    authorName := anAuthorName
]

{ #category : #'as yet unclassified' }
GHCommit >> committerName [
    ^ committerName
]

{ #category : #'as yet unclassified' }
GHCommit >> committerName: aCommitterName [
    committerName := aCommitterName
]

{ #category : #'as yet unclassified' }
GHCommit >> id [
    ^ id
]

{ #category : #'as yet unclassified' }
GHCommit >> id: anId [
    id := anId
]

{ #category : #'as yet unclassified' }
GHCommit >> message [
    ^ message
]

{ #category : #'as yet unclassified' }
GHCommit >> message: aMessage [
    message := aMessage
]

{ #category : #'as yet unclassified' }
GHCommit >> timestamp [
    ^ timestamp
]

{ #category : #'as yet unclassified' }
GHCommit >> timestamp: aTimestamp [
    timestamp := aTimestamp
]

{ #category : #'as yet unclassified' }
GHCommit >> treeId [
    ^ treeId
]

{ #category : #'as yet unclassified' }
GHCommit >> treeId: aTreeId [
    treeId := aTreeId
]
