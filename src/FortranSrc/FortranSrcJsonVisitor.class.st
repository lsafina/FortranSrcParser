Class {
	#name : #FortranSrcJsonVisitor,
	#superclass : #Object,
	#category : #'FortranSrc-Visitor'
}

{ #category : #visiting }
FortranSrcJsonVisitor >> apply: aMessage withValue: anEvaluated onReceiver: type [

	| selector |
	selector := (aMessage , ': ') asSymbol.
	type perform: selector with: anEvaluated. 
]

{ #category : #'reflective operations' }
FortranSrcJsonVisitor >> doesNotUnderstand: message [
	FortranSrcJsonVisitor compile: 
	message selector , ' anObject
	self flag: ''TODO generated automatically, please insert your code here''
'.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> parse: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> parseProgramUnit: aDictionary [

	"program unit is a dictionary that contains annotation, blocks, name, etc.
	the type of program unit depends on its tag value"

	| type |
	aDictionary isDictionary
		ifTrue: [ 
			type := self visitProgramUnitTag: (aDictionary at: 'tag').

			aDictionary keysAndValuesDo: [ :message :value | 
				| evaluated |
				evaluated := FASTFortranCharacterTypeExpression new.
				self apply: message withValue: evaluated onReceiver: type ] ]
		ifFalse: [ "TODO error malformed json" 1 halt ]
]

{ #category : #visiting }
FortranSrcJsonVisitor >> set: aParameter [

	| selector |
	selector := ('set' , aParameter  capitalized) asSymbol.
	self perform: selector 
]

{ #category : #visiting }
FortranSrcJsonVisitor >> set: aParameter receiver: aReceiver [

	| selector |
	selector := ('set' , aParameter  capitalized, ':') asSymbol.
	self perform: selector 
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> setTag: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> setTag: aSelector receiver: aReceiver [
	aReceiver perform: aSelector.
]

{ #category : #visiting }
FortranSrcJsonVisitor >> visit: aJsonElement [

	"Json elements are 
	- lists (an ordered sequenece of values) 
	- maps (an unordered associative array, mapping string property names to values)"

	aJsonElement isDictionary ifTrue: [ self visitJsonMap: aJsonElement ].

	aJsonElement isArray ifTrue: [ self visitJsonArray: aJsonElement ].
		
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitAnno: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitArguments: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitBlocks: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #visiting }
FortranSrcJsonVisitor >> visitJsonArray: aJsonArray [

	"process JSON Array"

	aJsonArray do: [ :value | self visit: value ]
]

{ #category : #visiting }
FortranSrcJsonVisitor >> visitJsonMap: aJsonMap [

	"process JSON map"

	aJsonMap keysAndValuesDo: [ :key :value | 
		| selector |
		selector := ('visit' , key capitalized , ':') asSymbol.
		self perform: selector with: value ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitLabel: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitList: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitMeta: anObject [
	"nothing to do for FAST"
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitName: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitOptions: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitProgramUnitTag: aTag [

	aTag = #main ifTrue: [ ^ FASTFortranMainProgram new ].
	aTag = #function ifTrue: [ ^ FASTFortranStatementFunction new ].
	aTag = #subroutine ifTrue: [ ^ FASTFortranStatementSoubroutine new ]
	
	"TODO error unrecognised tag"
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitProgram_units: anObject [
	"anObject is an array of program units that can be main program (tag: main) or subprogram (tags: function, subroutine, ...)"

	anObject isArray
		ifTrue: [ anObject do: [ :programUnit |
				self parseProgramUnit: programUnit 
				 ] ]
		ifFalse: [ "surprise me" 1 halt ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitResult: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSpan: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitStatement: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSubprograms: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitTag: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitType: anObject [
	self flag: 'TODO generated automatically, please insert your code here'

]
