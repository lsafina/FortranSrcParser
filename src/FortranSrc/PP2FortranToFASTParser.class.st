Class {
	#name : #PP2FortranToFASTParser,
	#superclass : #PP2FortranSrcGrammar,
	#instVars : [
		'model'
	],
	#category : #'FortranSrc-Parser'
}

{ #category : #initialization }
PP2FortranToFASTParser >> initialize [

	super initialize.
	model := FASTFortranModel new.
]

{ #category : #initialization }
PP2FortranToFASTParser >> metaInfo [
	"self parens: (self token: 'MetaInfo') , (self token: '{') , (miParameters delimitedBy: tkComma) , (self token: '}')
	  "

	^ super metaInfo
	  ==> [ :nodes | 
	  (nodes third select: [ :each | each isAssociation ]) asDictionary ]
	
]

{ #category : #initialization }
PP2FortranToFASTParser >> model [

	^ model
]

{ #category : #initialization }
PP2FortranToFASTParser >> model: anObject [

	model := anObject
]

{ #category : #initialization }
PP2FortranToFASTParser >> programFile [

	"(self token: 'ProgramFile') , metaInfo , (self haskellList: programUnit)"
	"TODO: is a name of a program file a FASTFortranProgram name"

	^ super programFile ==> [ :nodes | 
	  | program |
	
	  program := FASTFortranProgram new.
	  program
		  name: (nodes second
				   at: 'miFilename'
				   ifPresent: [ :node | node ]
				   ifAbsent: [ '' ]);
		  progUnits: nodes third.
	  program ]
]
