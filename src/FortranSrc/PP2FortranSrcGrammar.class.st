Class {
	#name : #PP2FortranSrcGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'any',
		'programFile',
		'metaInfo',
		'miVersion',
		'miFilename',
		'miParameters',
		'programUnit',
		'puMain',
		'puModule',
		'puSubroutine',
		'puFunction',
		'puBlockData',
		'puComment',
		'srcSpan',
		'prefixSuffix',
		'position',
		'tkNothing',
		'tkString',
		'tkNumber',
		'tkIdentifier',
		'tkComma',
		'emptyTuple',
		'expression',
		'expValue',
		'value',
		'block',
		'blComment',
		'comment',
		'blStatement',
		'statement',
		'impList',
		'typeSpec',
		'impElement',
		'impCharacter',
		'impRange',
		'baseType',
		'selector',
		'stDeclaration',
		'attribute',
		'declarator',
		'dimensionDeclarator',
		'intent',
		'declaratorType',
		'commonGroup',
		'valInteger',
		'ixSingle',
		'ixRange',
		'expSubscript',
		'index',
		'expBinary',
		'expUnary',
		'unaryOp',
		'binaryOp',
		'stExpressionAssign',
		'stCall',
		'argument',
		'argumentExpression',
		'blDo',
		'doSpecification',
		'expFunctionCall',
		'blIf',
		'lastPos',
		'stIfLogical',
		'forallHeader',
		'blForAll',
		'blCase',
		'blDoWhile',
		'blAssociate',
		'haskellListOfString',
		'maybeOfString',
		'valLogical',
		'stFunction'
	],
	#category : #'FortranSrc-Parser'
}

{ #category : #accessing }
PP2FortranSrcGrammar class >> ignoredNames [
	^super ignoredNames , #(lastPos)
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> aList: aRule [

	^ (self prelude: 'AList')
	, (self haskellList: aRule)
]

{ #category : #token }
PP2FortranSrcGrammar >> any [
	^ #any asParser token trim

]

{ #category : #'grammar-statement' }
PP2FortranSrcGrammar >> argument [
	^ (self prelude: 'Argument')
	, (self maybe: tkString)
	, (self parens: argumentExpression)
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> argumentExpression [
	^ ((self token: 'ArgExpr'), (self parens: expression))
	/ ((self prelude: 'ArgExprVar') , tkString)
]

{ #category : #grammar }
PP2FortranSrcGrammar >> attribute [

	^ (self prelude: 'AttrAllocatable')
	/ (self prelude: 'AttrAsynchronous')
	/ (self prelude: 'AttrDimension' aList: dimensionDeclarator)
	/ (self prelude: 'AttrExternal')
	/ ((self prelude: 'AttrIntent') , intent)
	/ (self prelude: 'AttrIntrinsic')
	/ (self prelude: 'AttrOptional')
	/ (self prelude: 'AttrParameter')
	/ (self prelude: 'AttrPointer')
	/ (self prelude: 'AttrPrivate')
	/ (self prelude: 'AttrProtected')
	/ (self prelude: 'AttrPublic')
	/ (self prelude: 'AttrSave')
	/ ((self prelude: 'AttrSuffix') , tkNothing)
	/ (self prelude: 'AttrTarget')
	/ (self prelude: 'AttrValue')
	/ (self prelude: 'AttrVolatile')
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> baseType [

	^ (self token: 'TypeInteger')
  	/ (self token: 'TypeReal')
  	/ (self token: 'TypeDoublePrecision')
  	/ (self token: 'TypeComplex')
  	/ (self token: 'TypeDoubleComplex')
  	/ (self token: 'TypeLogical')
  	/ (self token: 'TypeCharacter')
  	/ ((self token: 'TypeCustom') , tkString)
  	/ (self token: 'ClassStar')
  	/ ((self token: 'ClassCustom') , tkString)
  	/ (self token: 'TypeByte')
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> binaryOp [
	^ (self token: 'Addition')
  	/ (self token: 'Subtraction')
  	/ (self token: 'Multiplication')
  	/ (self token: 'Division')
  	/ (self token: 'Exponentiation')
  	/ (self token: 'Concatenation')
  	/ (self token: 'GTE')
  	/ (self token: 'GT')
  	/ (self token: 'LTE')
  	/ (self token: 'LT')
  	/ (self token: 'EQ')
  	/ (self token: 'NE')
  	/ (self token: 'Or')
  	/ (self token: 'XOr')
  	/ (self token: 'And')
  	/ (self token: 'Equivalent')
  	/ (self token: 'NotEquivalent')
  	/ ((self token: 'BinCustom') , tkString)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blAssociate [

	^ (self prelude: 'BlAssociate') , (self maybe: expression)
	  , (self maybe: tkString) , (self maybe: expression)
	  , (self justAList: (self justATuple: expression and: expression)) , (self haskellList: block)
	  , (self maybe: expression)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blCase [
	^ (self prelude: 'BlCase')
	, (self maybe: expression)
	, (self maybe: tkString)
	, (self parens: expression)
	, (self maybe: (self parens: (self aList: index)))
	, (self haskellList: (self haskellList: block))
	, (self maybe: expression)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blComment [

	^ (self prelude: 'BlComment')
	, comment
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blDo [
	^ (self prelude: 'BlDo')
	, (self maybe: expression)
	, (self maybe: tkString)
	, (self maybe: expression)
	, (self maybe: doSpecification)
	, (self haskellList: block)
	, (self maybe: expression)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blDoWhile [

	^ (self prelude: 'BlDoWhile') , (self maybe: expression)
	  , (self maybe: tkString) , (self maybe: expression)
	  , (self parens: expression) , (self haskellList: block)
	  , (self maybe: expression)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blForAll [
	^ (self prelude: 'BlForall')
	, (self maybe: expression)
	, (self maybe: tkString)
	, (self parens: forallHeader)
	, (self haskellList: block)
	, (self maybe: expression)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blIf [
	^ (self prelude: 'BlIf')
	, (self maybe: expression)
	, (self maybe: tkString)
	, (self haskellList: (self maybeNoParens: expression))
	, (self haskellList: (self haskellList: block))
	, (self maybe: expression)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> blStatement [

	^ (self prelude: 'BlStatement')
	, (self maybe: expression)
	, (self parens: statement)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> block [

	^ blStatement / blIf / blDo / blComment / blForAll
	/ blCase
	/ blDoWhile / blAssociate "/ blInterface"
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> comment [

	^ self parens: (self token: 'Comment') , tkString
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> commonGroup [
	^ (self prelude: 'CommonGroup')
	, (self maybe: expression)
	, (self parens: (self aList: declarator))
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> declarator [

	^ (self prelude: 'Declarator')
	, (self parens: expression)
	, declaratorType
	, (self maybe: expression)
	, (self maybe: expression)
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> declaratorType [

	^ (self token: 'ScalarDecl')
	  /
	  (self parens: (self token: 'ArrayDecl') , (self parens: (self aList: dimensionDeclarator)))
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> dimensionDeclarator [

	^ (self prelude: 'DimensionDeclarator')
	, (self maybe: expression)
	, (self maybe: expression)
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> doSpecification [
	^ (self prelude: 'DoSpecification')
	, (self parens: statement)
	, (self parens: expression)
	, (self maybe: expression)
]

{ #category : #token }
PP2FortranSrcGrammar >> emptyTuple [

	^ self token: '()'
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> expBinary [
	^ (self prelude: 'ExpBinary')
	, binaryOp
	, (self parens: expression)
	, (self parens: expression)
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> expFunctionCall [
	^ (self prelude: 'ExpFunctionCall')
	, (self parens: expression)
	, (self maybe: (self aList: argument))
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> expSubscript [
	^ (self prelude: 'ExpSubscript')
	, (self parens: expression)
	, (self parens: (self aList: index))
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> expUnary [
	^ (self prelude: 'ExpUnary')
	, unaryOp
	, (self parens: expression)
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> expValue [

	^ (self prelude: 'ExpValue') , (self parens: value)
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> expression [
	^ expValue
	/ expBinary
	/ expUnary
	/ expSubscript "/ expDataRef"
	/ expFunctionCall
	"/ expImpliedDo / expInitialisation / expReturnSpec"
]

{ #category : #'grammar-block' }
PP2FortranSrcGrammar >> forallHeader [

	^ (self haskellList:
		   tkString , (self parens: expression) , (self parens: expression) , (self maybe: expression))
	  , (self maybe: expression)
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> haskellList: aRule [

	^ (self token: '[') , (aRule separatedBy: tkComma) optional
	  , (self token: ']')
]

{ #category : #'grammar-tests' }
PP2FortranSrcGrammar >> haskellListOfString [

	"rule to test method #haskellList:"

	^ self haskellList: tkString
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> impCharacter [

	^ (self prelude: 'ImpCharacter') , tkString
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> impElement [

	^ impCharacter / impRange
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> impList [

	^ (self prelude: 'ImpList') , (self parens: typeSpec)
	       , (self parens: (self aList: impElement))
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> impRange [

	^ (self prelude: 'ImpRange') , tkString , #space asParser star
	  , tkString
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> index [
	^ ixSingle / ixRange
]

{ #category : #initialization }
PP2FortranSrcGrammar >> initialize [
	super initialize.
	lastPos := {(0 @ 0) . (0 @ 0)}
]

{ #category : #grammar }
PP2FortranSrcGrammar >> intent [

	^ (self token: 'In') / (self token: 'Out') / (self token: 'InOut')
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> ixRange [
	^ (self prelude: 'IxRange') , (self maybe: expression) , (self maybe: expression) , (self maybe: expression)
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> ixSingle [
	^ (self prelude: 'IxSingle') , (self maybe: tkString) , (self parens: expression)
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> justAList: aRule [
	^ self parens: (self token: 'Just') , (self aList: aRule)
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> justATuple: aRule1 and: aRule2 [

	^ self parens:
		  (self token: 'Just') , (self aList: aRule1) , (self aList: aRule2)
]

{ #category : #accessing }
PP2FortranSrcGrammar >> lastPos [
	^lastPos 
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> maybe: aRule [
	"Maybe  -> Nothing / (Just aRule)"
	^ tkNothing / (self parens: (self token: 'Just') , aRule)
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> maybeNoParens: aRule [
	"a special #maybe: that does not put parentheses around 'Just aRule'
	notably when it is in a haskell list"
	^ tkNothing / ((self token: 'Just') , aRule)
]

{ #category : #'grammar-tests' }
PP2FortranSrcGrammar >> maybeOfString [

	"rule to test method #maybe:"

	^ self maybe: tkString
]

{ #category : #'grammar-metaInfo' }
PP2FortranSrcGrammar >> metaInfo [

	^ self parens: (self token: 'MetaInfo')
	, (self token: '{')
	, (miParameters delimitedBy: tkComma)
	, (self token: '}')
	  
]

{ #category : #'grammar-metaInfo' }
PP2FortranSrcGrammar >> miFilename [

	^ (self token: 'miFilename') , (self token: '=') , tkString
]

{ #category : #'grammar-metaInfo' }
PP2FortranSrcGrammar >> miParameters [
	^ miVersion / miFilename
]

{ #category : #'grammar-metaInfo' }
PP2FortranSrcGrammar >> miVersion [

	^ (self token: 'miVersion') , (self token: '=') , tkIdentifier
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> parens: aRule [

	^ (self token: '(') , aRule , (self token: ')')
]

{ #category : #grammar }
PP2FortranSrcGrammar >> position [

	^ self parens: tkNumber , (self token: ':') , tkNumber
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> prefixSuffix [

	^ self parens: tkNothing , tkComma , tkNothing
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> prelude: aString [

	^ aString asParser trim , emptyTuple , srcSpan
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> prelude: aString aList: aRule [

	^ (self prelude: aString) , (self parens: (self aList: aRule))
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> prelude: aString maybe: aRule [

	^ (self prelude: aString) , (self maybe: aRule)
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> programFile [

	^ (self token: 'ProgramFile') , metaInfo , (self haskellList: programUnit)
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> programUnit [
	^ puMain / puModule / puSubroutine / puFunction / puBlockData / puComment
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> puBlockData [
	^ (self prelude: 'PUBlockData')
	, (self maybe: tkString)
	, (self haskellList: block)
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> puComment [

	^ (self prelude: 'PUComment') ,  comment
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> puFunction [
	^ (self prelude: 'PUFunction')
	, (self maybe: typeSpec)
	, prefixSuffix
	, tkString
	, ((self token: 'Nothing') / (self justAList: expression))
	, (self maybe: expression)
	, (self haskellList: block)
	, (self maybe: programUnit)
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> puMain [
	^ (self prelude: 'PUMain')
	, (self maybe: tkString)
	, (self haskellList: block)
	, (self maybe: programUnit)
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> puModule [
	^ (self prelude: 'PUModule')
	, tkString
	, (self haskellList: block)
	, (self maybe: programUnit)
]

{ #category : #'grammar-programUnit' }
PP2FortranSrcGrammar >> puSubroutine [

	^ (self prelude: 'PUSubroutine') , prefixSuffix , tkString
	  , ((self token: 'Nothing') / (self justAList: expression))
	  , (self haskellList: block) , (self maybe: programUnit)
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> selector [

	^ (self prelude: 'Selector')
	, (self maybe: expression)
	, (self maybe: expression)
]

{ #category : #grammar }
PP2FortranSrcGrammar >> srcSpan [

	^ position , (self token: '-') , position
		==> [ :nodes || line col|
			line := nodes first second first asInteger.
			col := nodes first second third asInteger.
			(lastPos first x < line)
			ifTrue: [ lastPos := { (line @ col) . nodes third second} ] 
			ifFalse: [ ((lastPos first x = line) and: [lastPos first y < col])
				ifTrue: [lastPos := { (line @ col) . nodes third second}] ].
			nodes
		]
]

{ #category : #'grammar-statement' }
PP2FortranSrcGrammar >> stCall [
	^ ((self prelude: 'StCall')
	, (self parens: expression)
	, (self maybe: (self aList:  argument)))
]

{ #category : #'grammar-statement' }
PP2FortranSrcGrammar >> stDeclaration [
	^ (self prelude: 'StDeclaration')
	, (self parens: typeSpec)
	, (self maybe: (self aList: attribute))
	, (self parens: (self aList: declarator))
]

{ #category : #'grammar-statement' }
PP2FortranSrcGrammar >> stExpressionAssign [
	^ ((self prelude: 'StExpressionAssign')
	, (self parens: expression)
	, (self parens: expression))
]

{ #category : #'grammar-statement' }
PP2FortranSrcGrammar >> stFunction [

	^ (self prelude: 'StFunction') , (self parens: expression)
	  , (self parens: (self aList: expression)) , (self parens: expression)
]

{ #category : #'grammar-statement' }
PP2FortranSrcGrammar >> stIfLogical [
	^ (self prelude: 'StIfLogical')
	, (self parens: expression)
	, (self parens: statement)
]

{ #category : #accessing }
PP2FortranSrcGrammar >> start [
	^programFile
]

{ #category : #'grammar-statement' }
PP2FortranSrcGrammar >> statement [

	^ stDeclaration / (self prelude: 'StDimension' aList: declarator)
	  / (self prelude: 'StAllocatable' aList: declarator)
	  / (self prelude: 'StCommon' aList: commonGroup)
	  / (self prelude: 'StEquivalence' aList: (self aList: expression))
	  / (self prelude: 'StImplicit' maybe: (self aList: impList))
	  / stIfLogical / stExpressionAssign
	  /
	  ((self prelude: 'StGotoUnconditional') , (self parens: expression))
	  / stCall / (self prelude: 'StReturn' maybe: expression)
	  / (self prelude: 'StContinue') / stFunction 
	"/ stStructure / stIntent / stOptional / stPublic / stPrivate / stProtected / stSave"
	"/ stAsynchronous / stPointer / stTarget / stValue / stVolatile / stData / stAutomatic / ststatic / stNamelist / stParameter / stExternal / stIntrinsic"
	"/ stFormat"

	"/ stEntry / stInclude / stDo / stDoWhile / stEnddo / stCycle / stExit "
	" / stIfArithmetic / stSelectCase / stCase / stEndcase"
	" / stPointerAssign / stLabelAssign"
	" / stGotoAssigned / stGotoComputed"
	"/ ststop / stPause / stRead / stRead2 / stWrite / stPrint / stTypePrint / stOpen / stClose / stFlush / stInquire / stRewind / stRewind2 / stBackspace / stBackspace2 / stEndfile / stEndfile2 / stAllocate / stNullify / stDeallocate / stWhere / stWhereConstruct / stElsewhere / stEndWhere / stUse / stModuleProcedure / stProcedure / stType / stEndType / stSequence / stForall / stForallstatement / stEndForall / stImport / stEnum / stEnumerator / stEndEnum / stFormatBogus"
]

{ #category : #token }
PP2FortranSrcGrammar >> tkComma [

	^ self token: ','
]

{ #category : #token }
PP2FortranSrcGrammar >> tkIdentifier [

	^ #word asParser plus flatten trim
]

{ #category : #token }
PP2FortranSrcGrammar >> tkNothing [

	^ self token: 'Nothing'
]

{ #category : #token }
PP2FortranSrcGrammar >> tkNumber [
	^ #digit asParser plus flatten trim
]

{ #category : #token }
PP2FortranSrcGrammar >> tkString [

	^ $" asParser
	  , ('\"' asParser / $" asParser negate) star flatten
	  , $" asParser
]

{ #category : #'grammar-helper' }
PP2FortranSrcGrammar >> token: aString [

	^  aString asParser flatten trim
]

{ #category : #'grammar-declaration' }
PP2FortranSrcGrammar >> typeSpec [

	^ (self prelude: 'TypeSpec') , baseType , (self maybe: selector)
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> unaryOp [
	^ (self token: 'Plus') /
	(self token: 'Minus') /
	(self token: 'Not') /
	((self token: 'UnCustom') , tkString)
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> valInteger [

	^ (self token: 'ValInteger') , tkString , tkNothing
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> valLogical [

	
	^ (self token: 'ValLogical')
	  , ((self token: 'False') / (self token: 'True')) , tkNothing
]

{ #category : #'grammar-expression' }
PP2FortranSrcGrammar >> value [

	^ valInteger / ((self token: 'ValString') , tkString)
	  / ((self token: 'ValHollerith') , tkString)
	  / ((self token: 'ValVariable') , tkString)
	  / ((self token: 'ValIntrinsic') , tkString)
	  / ((self token: 'ValOperator') , tkString)
	  / ((self token: 'ValType') , tkString)
	"/ valReal / valComplex"
	"/ valBoz"
	/ valLogical
	"/ valAssignment"
	"/ valStar / valColon"
]
