Class {
	#name : #FASTFortranDeclaration,
	#superclass : #Object,
	#instVars : [
		'type',
		'declarators'
	],
	#category : #'FortranSrc-Visitor'
}

{ #category : #accessing }
FASTFortranDeclaration >> declarators [

	^ declarators
]

{ #category : #accessing }
FASTFortranDeclaration >> declarators: aList [

	declarators := aList
]

{ #category : #accessing }
FASTFortranDeclaration >> type [

	^ type
]

{ #category : #accessing }
FASTFortranDeclaration >> type: aType [

	type := aType 
]
