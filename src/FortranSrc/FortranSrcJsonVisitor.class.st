Class {
	#name : #FortranSrcJsonVisitor,
	#superclass : #Object,
	#category : #'FortranSrc-Visitor'
}

{ #category : #visiting }
FortranSrcJsonVisitor >> builtVisitSelector: key [

	^ ('visit' , key capitalized , ':') asSymbol
]

{ #category : #visiting }
FortranSrcJsonVisitor >> builtVisitSelectorBaseTypes: key [

	^ ('visit' , key capitalized , 'BaseType' , ':') asSymbol
]

{ #category : #'reflective operations' }
FortranSrcJsonVisitor >> doesNotUnderstand: message [

	self class compile: message selector , ' anObject
	self flag: ''TODO generated automatically, please insert your code here''.
	1 halt.
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

	^ nil.

	
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
FortranSrcJsonVisitor >> visitArray: anObject [
	
	"its a bullshit code that need to be rewritten"

	^ FASTFortranArrayVariable new name:
		  (self visitVariable: (anObject at: 'variable')) name

	"TODO process dimensions"

	"TODO process length"	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitAssign_expression: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitBase_type: anObject [

	^ self perform: (self builtVisitSelectorBaseTypes: anObject) with: anObject
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

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitCall: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitCharacter: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitCharacterBaseType: anObject [
	
	^ FASTFortranCharacterLiteral new 

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitComment: anObject [

	^ FASTFortranComment new comment: (anObject at: 'comment')
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
	
	| declaration |
	
	declaration := FASTFortranDeclaration new.
	declaration type: (self visit: (anObject at: 'type') ) first.
	declaration declarators: (self visitDeclarators: (anObject at: 'declarators') ).
	
	^ declaration.
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitDeclarators: anObject [

	^ (anObject at: 'list') collect: [ :each | 
		  self
			  perform: (self builtVisitSelector: (each at: #type))
			  with: each ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitDims: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitDo: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitExternal: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitFormat: anObject [

	1 halt.
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
FortranSrcJsonVisitor >> visitIf: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitImplicit: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitInitial: anObject [

	^ nil

	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitInteger: anObject [

	^ FASTFortranStatementInteger new contents: (anObject at: 'contents')
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitIntegerBaseType: anObject [
	
	^ FASTFortranStatementInteger 

]

{ #category : #visiting }
FortranSrcJsonVisitor >> visitJsonArray: aJsonArray [

	"process JSON Array"

	^ aJsonArray collect: [ :value | 
			"1 halt."
		  (value includesKey: 'tag')
			  ifTrue: [ self visitTaggedElement: value ]
			  ifFalse: [ self visit: value ] ]
]

{ #category : #visiting }
FortranSrcJsonVisitor >> visitJsonMap: aJsonMap [

	"process JSON map (dictionary)"

	| newCollection |
	
	"explain why"
	(aJsonMap includesKey: 'tag') ifTrue: [ ^ self visitTaggedElement: aJsonMap ].
	
	newCollection := OrderedCollection new: aJsonMap size.

	aJsonMap associationsDo: [ :assoc | 
		| selector |
		selector := self builtVisitSelector: assoc key.
		"1 halt."
		newCollection add: (self perform: selector with: assoc value) ].
	
	"1 halt."
	
	^ newCollection reject:  [ :each | each isNil ].

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitLabel: anObject [

	^ nil

	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitLength: anObject [

	^ nil

	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitList: anObject [

	^ self visit: anObject
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitMain: anObject [
	
	| mainProgram |
	
	mainProgram := FASTFortranMainProgram new.
	mainProgram name: (anObject at: 'name').
	mainProgram statements: (self visit: (anObject at: 'blocks')). 
	
	^ mainProgram. 
	  
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitMeta: anObject [

	"nothing to do for FAST"

	^ nil
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitName: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitOptions: anObject [
	
	1 halt
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitPrint: anObject [
	
	| printStatement | 
	
	printStatement := FASTFortranStatementPrint new.
	
	printStatement format: (self visit: (anObject at: 'format')).
	printStatement variablesList: (self visit: (anObject at: 'arguments')).	
	
	^ printStatement 
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitProgram_units: anObject [

	"anObject is an array of program units that can be main program (tag: main) or subprogram (tags: function, subroutine, ...)"

	anObject isArray
		ifTrue: [ 
			^ self visitJsonArray: anObject "anObject do: [ :programUnit |
				self parseProgramUnit: programUnit 
				 ]" ]
		ifFalse: [ " todo exception " ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitRealBaseType: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitResult: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitScalar: anObject [

	"its a bullshit code that need to be rewritten"
	
	^ (FASTFortranScalarVariable new) name: ((self visitVariable: (anObject at: 'variable')) name)


]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSelector: anObject [
	
	"type selector, met in a variable declaraion, for the moment not used"
	
	^ nil

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSpan: anObject [

	" anObject is a source anchor in the form (a:b - c:d) where a and c are line numbers and b and d are columns. 
	for the moment ignored"
	
	^ nil

	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitStar: anObject [

	^ FASTFortranAsterisk new.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitStatement: anObject [

	| statement |
	
	"1 halt."	
	statement := anObject at: 'statement'.
	
	"we expect a statement to have a tag"
	^ (statement includesKey: 'tag') 
		ifTrue: [ self visitTaggedElement: statement ]
		ifFalse: [ 1 halt. ]
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitStatementBlock: anASTStatementBlock [

	| block |
	block := FASTFortranStatementBlock new.
	block statements: (anASTStatementBlock collect: [ :astStatement | 
		  self visitJsonMap: astStatement ]).
	^block
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitString: anObject [
	
	^ (anObject equals: nil) 
		ifTrue: [ FASTFortranStringLiteral new]
		ifFalse: [ FASTFortranStringLiteral new contents: (anObject at: 'contents') ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitSubprograms: anObject [

	1 halt
	
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

	1 halt
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
	
	"declaration of variable is ambigous and can be seen in diferent places of given data and might have different structure, which explains the necessity of the code below"
	
	^ (anObject includesKey: 'contents') 
		ifTrue: [ (FASTFortranVariable new) name: (anObject at: 'contents')]
		ifFalse: [ self visitTaggedElement: anObject  ]

	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitWrite: anObject [

	1 halt.
]
