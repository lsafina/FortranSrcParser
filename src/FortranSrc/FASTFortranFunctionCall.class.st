Class {
	#name : #FASTFortranFunctionCall,
	#superclass : #Object,
	#instVars : [
		'name',
		'arguments'
	],
	#category : #'FortranSrc-Visitor'
}

{ #category : #accessing }
FASTFortranFunctionCall >> arguments [

	^ arguments
]

{ #category : #accessing }
FASTFortranFunctionCall >> arguments: aList [

	arguments := aList 
]

{ #category : #accessing }
FASTFortranFunctionCall >> name [

	^ name
]

{ #category : #accessing }
FASTFortranFunctionCall >> name: aName [

	name := aName
]
