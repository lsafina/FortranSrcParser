Class {
	#name : #PP2FortranToFASTParserTestSetUp,
	#superclass : #PP2FortranSrcGrammarTest,
	#category : #'FortranSrc-Tests'
}

{ #category : #running }
PP2FortranToFASTParserTestSetUp >> astHaskell: sourceCode [

	| filename option |
	option := '-v77l -t json encode'.
	filename := './fortran77.f'.
	filename asFileReference writeStreamDo: [ :stream | 
		stream truncate.
		stream
		<< (sourceCode copy replaceAll: Character cr with: Character lf) ].
	
	LibC runCommand: ('{1} {2} "{3}" >"{3}.json" 2>"{3}.err"' format: { 
				 self haskellParserPath.
				 option.
				 filename. })
]

{ #category : #running }
PP2FortranToFASTParserTestSetUp >> haskellParserPath [

	"temporal dirty hard-coding"

	^ '/Users/lsafina/.cabal/bin/fortran-src-extras serialize'
	"^ '/Users/lsafina/.cabal/bin/fortran-src' - when we need to receive a haskell-based representation"
]

{ #category : #tests }
PP2FortranToFASTParserTestSetUp >> parse: sourceCode [

	self astHaskell: sourceCode.
	^ FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ])
]

{ #category : #tests }
PP2FortranToFASTParserTestSetUp >> parse: sourceCode as: puMarker [
	| parseSelector |
	parseSelector := ('parse' , puMarker , ':') asSymbol.
	self astHaskell: sourceCode.
	^ FortranSrcJsonVisitor new
		perform: parseSelector
		with:
		  ('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			   NeoJSONReader fromString: str contents ])
]

{ #category : #tests }
PP2FortranToFASTParserTestSetUp >> parse: sourceCode rule: aRule [

	FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ]).
]

{ #category : #accessing }
PP2FortranToFASTParserTestSetUp >> setUp [
	
	super setUp.
	parser := self parserInstance
]
