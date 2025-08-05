Class {
	#name : #BaselineOfGHFailures,
	#superclass : #Object,
	#category : #BaselineOfGHFailures
}

{ #category : #'as yet unclassified' }
BaselineOfGHFailures >> baseline: spec [
	<baseline>
	
	spec for: #common do: [
		spec 
			package: 'GHFailures'  
	]
]
