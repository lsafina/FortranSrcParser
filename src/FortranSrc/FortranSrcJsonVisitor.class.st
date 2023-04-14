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
FortranSrcJsonVisitor >> parseRoutine: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

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
FortranSrcJsonVisitor >> visitAddition: anObject [

	^ FASTFortranArithmeticTypeExpression new
		  left: (self visit: (anObject at: 'left'));
		  right: (self visit: (anObject at: 'right'));
		  op: (anObject at: 'op' at: 'tag')
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

	^ self visit: (anASTArguments "at: 'list'")
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

	"The assignment statement assigns a value to a variable, substring, array element, record, or record field"

	^ FASTFortranStatementAssign new
		  right: (self visit: (anObject at: 'target'));
		  left: (self visit: (anObject at: 'expression'))
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitBase_type: anObject [

	^ self perform: (self builtVisitSelectorBaseTypes: anObject) with: anObject
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitBinary: anObject [
	| selector |
	
	selector := self builtVisitSelector: (anObject at: 'op' at: 'tag').
	^ self perform: selector with: anObject 

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

	"The CALL statement branches to the specified subroutine, executes the subroutine, and returns to the calling program after finishing the subroutine.

CALL sub [([ar[, ar]])] where sub is a name of the subroutine to be called, ar is an actual argument to be passed to the subroutine "

	| callStatement arguments|
	
	callStatement := FASTFortranStatementCall new.
	arguments := self visit: (anObject at: 'arguments').
	(arguments first notEmpty) ifTrue: [ callStatement arguments: arguments].
	
	"TODO bullshit code, need to be fixed"
	callStatement name: ((self visit: (anObject at: 'function')) name).
	
	^ callStatement  
	
	
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
FortranSrcJsonVisitor >> visitConcatenation: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitConditions: anObject else: elseObject [
	
	"read recursiveley a list of ""if then"" end ""if else"", adds else part if present"
	| conditional |

	conditional := FASTFortranStatementIfBlock new
		             condition: (self visitTaggedElement: anObject first first);
		             thenPart: (self visit: anObject first last).

	anObject size > 1
		ifTrue: [conditional elsePart: (self visitConditions: (anObject allButFirst)  else:  elseObject) ]
		ifFalse: [ 
			elseObject ifNotNil: [ 
				conditional elsePart: (self visit: elseObject) ] ].
	
	^ conditional
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitContents: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitContinue: anObject [
	
	^ FASTFortranStatementContinue new

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

	| loopControl increment|
	
	loopControl := anObject at: 'do_spec'.
	increment := (loopControl at: 'increment').
	
	^ (FASTFortranStatementDo new)
	 block: (self visitJsonArray: (anObject at: 'body'));
	loopControlInitial: (self visitTaggedElement: (loopControl at: 'initial'));
	loopControlLimit: (self visitTaggedElement: (loopControl at: 'limit'));
	loopControlIncrement: ((increment isNotNil) ifTrue:[self visitTaggedElement: (loopControl at: 'increment') ] ifFalse: [nil]).

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitEq: anObject [
	
	^ (FASTFortranArithmeticTypeExpression new) 
		left: (self visitTaggedElement: (anObject at: 'left'));
		right: (self visitTaggedElement: (anObject at: 'right')); 
		op: (anObject at: 'op' at: 'tag')

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitExit: anObject [
	
	^ FASTFortranStatementExit new

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitExponentiation: anObject [

	^ FASTFortranArithmeticTypeExpression new
		  left: (self visit: (anObject at: 'left'));
		  right: (self visit: (anObject at: 'right'));
		  op: (anObject at: 'op' at: 'tag')
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitExpr: anObject [

	"encountered in the list of format variables. for the moment the only seen structure was 
	expr {contents:[], tag: expr}, which prevents from calling visitTagged element (creates infinite loop), so we visit 	value directly and adapt any other structural variants in the future"

	^ (anObject includesKey: 'contents')
		  ifTrue: [ self visit: (anObject at: 'contents') ]
		  ifFalse: [ self visitTaggedElement: anObject ]
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitExternal: anObject [

	"The EXTERNAL statement specifies procedures or dummy procedures as external, and allows their symbolic names to be used as actual arguments.

EXTERNAL proc [, proc] ...
where proc is a name of external procedure, dummy procedure, or block data routine. "

	"you will go to hell for this code. TODO rewrite"
 ^ (FASTFortranStatementExternal new) name: (self visit: (anObject at: 'vars')) first first name.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitFormat: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitFunction: anObject [

	| function |
	
	function := FASTFortranStatementFunction new.
	function name: (anObject at: 'name').
	function arguments: (self visitArguments: (anObject at: 'arguments')).
	
	(anObject includesKey: 'body') ifTrue: [ function body: (self visitArguments: (anObject at: 'body')) ]
	ifFalse: [ function body: (self visitArguments: (anObject at: 'blocks'))  ]
	.
	
	^ function. 
	
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitFunction_call: anObject [

	"not a statement. call to a certain funstions (INTRINSIC, EXTERNAL) in expressions do not require a call statement"

	^ FASTFortranFunctionCall new
		  name: (self visit: (anObject at: 'function')) name;
		  arguments: (self visit: (anObject at: 'arguments'))
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitGoto: anObject [

	"so far only unconditional case is processed"
	
	^ (FASTFortranStatementGoToUnconditional new) label: (self visitTaggedElement: (anObject at: 'target'))	

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitIf: anObject [

	".blocks is an array with one block dedicated to else
	.conditionals is an erray where each element represent if and if else consequently 
	.conditionals[_].[0] represents a condition
	.conditionals[_].[1] is an array containing all statements of the correpsonding block"

	^ self
		  visitConditions: (anObject at: 'conditions')
		  else: (anObject at: 'blocks')
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitImplicit: anObject [
	
	"correspond to the statement implicit none. for the moment ignored"
	
	^ nil
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
FortranSrcJsonVisitor >> visitLogical: anObject [
	
	| constantContent |
	constantContent := (anObject at: 'contents') first.
	constantContent ifTrue:[ ^ FASTFortranConstantLogicalTrue ].
	constantContent ifFalse:[ ^ FASTFortranConstantLogicalFalse ].	
	
	"TODO exception: unexpected output"
	1 halt.

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitLogicalBaseType: anObject [

	^ FASTFortranStatementLogical new

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitLt: anObject [
	self flag: 'TODO generated automatically, please insert your code here'.
	1 halt.

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

	"encountered in the list of format variables. for the moment ignored"

	^ nil
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitOptions: anObject [
	
	1 halt
	
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitPrint: anObject [

	^ FASTFortranStatementPrint new
		  format: (self visit: (anObject at: 'format'));
		  variablesList: (self visit: (anObject at: 'arguments'))
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
FortranSrcJsonVisitor >> visitReal: anObject [

	^ FASTFortranStatementReal new contents: (anObject at: 'contents')

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitRealBaseType: anObject [
	
	^ FASTFortranStatementReal new

]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitResult: anObject [

	1 halt.
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitReturn: anObject [
	
	^ FASTFortranStatementReturn new

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

	^ FASTFortranStringLiteral new contents: (anObject at: 'contents')
]

{ #category : #'as yet unclassified' }
FortranSrcJsonVisitor >> visitStringBaseType: anObject [

	^ FASTFortranStringLiteral new
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
FortranSrcJsonVisitor >> visitSubtraction: anObject [
	
	^ FASTFortranArithmeticTypeExpression new
		  left: (self visit: (anObject at: 'left'));
		  right: (self visit: (anObject at: 'right'));
		  op: (anObject at: 'op' at: 'tag')

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

	"write statement. should follow the pattern: 
	WRITE([UNIT=] u [, [FMT=] f] [, IOSTAT=ios] [, REC=rn] [, ERR=s]) iolist
	WRITE([ UNIT=] u, [NML=] grname [, IOSTAT=ios] [, ERR=s])"
	
	| statement |

	statement := FASTFortranStatementWrite new.
	statement format: (self visit: (anObject at: 'format')).
	statement arguments: (self visit: (anObject at: 'arguments')).
	
	^ statement
]
