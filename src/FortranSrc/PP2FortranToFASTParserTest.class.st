Class {
	#name : #PP2FortranToFASTParserTest,
	#superclass : #PP2FortranSrcGrammarTest,
	#category : #'FortranSrc-Tests'
}

{ #category : #running }
PP2FortranToFASTParserTest >> astHaskell: sourceCode [

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
PP2FortranToFASTParserTest >> haskellParserPath [

	"temporal dirty hard-coding"

	^ '/Users/lsafina/.cabal/bin/fortran-src-extras serialize'
	"^ '/Users/lsafina/.cabal/bin/fortran-src' - when we need to receive a haskell-based representation"
]

{ #category : #tests }
PP2FortranToFASTParserTest >> parse: sourceCode [

	self astHaskell: sourceCode.
	FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ]).
]

{ #category : #tests }
PP2FortranToFASTParserTest >> parse: sourceCode rule: aRule [

	FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ]).
]

{ #category : #accessing }
PP2FortranToFASTParserTest >> setUp [
	
	super setUp.
	parser := self parserInstance
]

{ #category : #tests }
PP2FortranToFASTParserTest >> testBasic [

	FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ])
		
			
	
]

{ #category : #tests }
PP2FortranToFASTParserTest >> testProgramWithMultipleProgUnitsWithInvocation2 [

self
		       parse: '      program myprog
      i = ifunc (i)
      end

      function ifunc( k )
      end
'
]

{ #category : #tests }
PP2FortranToFASTParserTest >> testSubroutine [

	self parse: '      subroutine hello( name )
        write(*,*) name
      end
'
]
