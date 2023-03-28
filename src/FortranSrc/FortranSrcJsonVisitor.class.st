Class {
	#name : #FortranSrcJsonVisitor,
	#superclass : #Object,
	#category : #'FortranSrc-Visitor'
}

{ #category : #visiting }
FortranSrcJsonVisitor >> builtVisitSelector: key [

	^ ('visit' , key capitalized , ':') asSymbol
]

{ #category : #'reflective operations' }
FortranSrcJsonVisitor >> doesNotUnderstand: message [

	self class compile: message selector , ' anObject
	self flag: ''TODO generated automatically, please insert your code here''
'
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> parseSubroutine: anObject [

	^ self visitJsonArray: (anObject at: #program_units)
]

{ #category : #visiting }
FortranSrcJsonVisitor >> visit: aJsonElement [

	"Json elements are 
	- lists (an ordered sequenece of values) 
	- maps (an unordered associative array, mapping string property names to values)"

	aJsonElement isDictionary ifTrue: [ ^ self visitJsonMap: aJsonElement ].

	aJsonElement isArray ifTrue: [ ^ self visitJsonArray: aJsonElement ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitAnno: anObject [

	"ignored"
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitArgumentValue: anObject [

	^ self visitTaggedElement: anObject
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitArguments: anASTArguments [

	^ self visitJsonArray: (anASTArguments at: 'list')
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitAssign_expression: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitBlock_data: anObject [

	| value |
	value := FASTFortranStatementBlockData new.
	value name: (anObject at: 'name').

	value statements: (self visit: (anObject at: 'blocks')).

	^ value
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitBlocks: anObject [

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitComment: anObject [

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitCommon: anObject [

	"creates common statement which defines a block of main memory storage so that different program units can share the same data without using arguments.

COMMON [/[cb]/] nlist [[,]/[cb]/ nlist] where 
cb: Common block name,
nlist: List of variable names, array names, and array declarators  "

	| value |
	
	value := FASTFortranStatementCommon new
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitContents: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitData: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitDeclaration: anObject [
	
	| variable |
	1 halt.
	variable := self visit: (anObject at: 'declarators').
	self visit: (anObject at: 'type').
	
	^ variable.
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitFunction: anObject [

	| function |
	
	1 halt.
	function := FASTFortranStatementFunction new.
	function name: (anObject at: 'name').
	function arguments: (self visitArguments: (anObject at: 'arguments')).
	function body: (self visitArguments: (anObject at: 'blocks')).
	^ function. 
	
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitInitial: anObject [

	"ignore"
]

{ #category : #visiting }
FortranSrcJsonVisitor >> visitJsonArray: aJsonArray [

	"process JSON Array"

	^ aJsonArray collect: [ :value | 
		  1 halt.
		  (value includesKey: 'tag')
			  ifTrue: [ self visitTaggedElement: value ]
			  ifFalse: [ self visit: value ] ]
]

{ #category : #visiting }
FortranSrcJsonVisitor >> visitJsonMap: aJsonMap [

	"process JSON map"

	| newCollection |
	newCollection := OrderedCollection new: aJsonMap size.

	aJsonMap associationsDo: [ :assoc | 
		| selector |
		1 halt.
		selector := self builtVisitSelector: assoc key.
		newCollection add: (self perform: selector with: assoc value) ].

	1 halt.
	^ newCollection
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitLabel: anObject [

	"ignored"
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitLength: anObject [

	"ignore"
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitList: anObject [

	^ self visit: anObject
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitMain: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitMeta: anObject [
	"nothing to do for FAST"
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitName: anObject [

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitOptions: anObject [

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitProgram_units: anObject [

	"anObject is an array of program units that can be main program (tag: main) or subprogram (tags: function, subroutine, ...)"

	anObject isArray
		ifTrue: [ 
			self visitJsonArray: anObject "anObject do: [ :programUnit |
				self parseProgramUnit: programUnit 
				 ]" ]
		ifFalse: [ " todo exception " ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitResult: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSpan: anObject [

	" anObject is a source anchor in the form (a:b - c:d) where a and c are line numbers and b and d are columns. 
	for the moment ignored"

	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitStatement: anObject [
	
	^ self visitTaggedElement: anObject.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitStatementBlock: anASTStatementBlock [

	| block |
	block := FASTFortranStatementBlock new.
	block statements: (anASTStatementBlock collect: [ :astStatement | 
			1 halt.
		  self visitJsonMap: astStatement ]).
	^block
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSubprograms: anObject [

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSubroutine: anObject [

	| soubroutine |
	soubroutine := FASTFortranStatementSoubroutine new.
	soubroutine name: (anObject at: 'name').
	soubroutine variables:
		(self visitArguments: (anObject at: 'arguments')).
	soubroutine body:
		(self visitStatementBlock: (anObject at: 'blocks')).

	^ soubroutine
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitTag: anObject [

]

{ #category : #visiting }
FortranSrcJsonVisitor >> visitTaggedElement: value [

	| selector |
	
	selector := self builtVisitSelector: (value at: #tag).
	^ self perform: selector with: value
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitType: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitValue: anObject [
	
	"| value |"
	"value := (anObject at: 'tag')."
	"^ self visitTaggedElement: anObject ."
	
	^ self visitArgumentValue: (anObject at: 'value').
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitVariable: anObject [

	| variable |
	
	variable := FASTFortranVariable new.
	variable name: (anObject at: 'contents').

	^ variable
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitWrite: anObject [

	1 halt.
]
