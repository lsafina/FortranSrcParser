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
	^ FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ])
]

{ #category : #tests }
PP2FortranToFASTParserTest >> parse: sourceCode as: puMarker [
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
PP2FortranToFASTParserTest >> testBlockData [

	
	result := self
		        parse: '      block data myblck
      common /mycom/ i
      data i /12345/
      end
 '.

	self assert: result equals: FASTFortranStatementBlockData. 
]

{ #category : #tests }
PP2FortranToFASTParserTest >> testConditionalMultipleElse [

	result := self parse: '      PROGRAM MYPROG
         IF ( A ) THEN
            I = 1
         else if ( b ) then
            i = 2
         else if ( c ) then
            i = 3         
         ELSE
            I = 4
         END IF
      END
'as: #Program.

	self assert: result equals: FASTFortranProgram
]

{ #category : #tests }
PP2FortranToFASTParserTest >> testFullBorbk [

	result := self parse: '      PROGRAM MYPROG
         IF ( A ) THEN
            I = 1
         ELSE IF ( B ) THEN
            I = 2
         ELSE
            I = 3
         END IF
      END
'.

self assert: result equals: FASTFortranStatementProgram. 
]

{ #category : #tests }
PP2FortranToFASTParserTest >> testFunction [

	result := self parse: '      function ifunc( k, l )
      ifunc = k
      end
c --- end ---
'.

	self assert: result class equals: FASTFortranStatementFunction
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

	| subrtn |
	result := self
		          parse: '      subroutine hello()
        write(*,*) "hello"
      end
'
		          as: #Routine.

	self assert: result size equals: 1.
	subrtn := result first.

	self assert: subrtn class equals: FASTFortranStatementSoubroutine.
	self assert: subrtn name equals: 'hello'.

]

{ #category : #tests }
PP2FortranToFASTParserTest >> testSubroutineWithParameters [

	| subrtn |
	result := self
		          parse: '      subroutine hello(name, age)
        write(*,*) name, age
      end
'
		          as: #Subroutine.

	self assert: result size equals: 1.
	subrtn := result first.

	self assert: subrtn variables size equals: 2.
	subrtn variables do: [ :parameter | 
		self assert: parameter class equals: FASTFortranVariable.
		self assert: (#( name age ) includes: parameter name) ]
]

{ #category : #tests }
PP2FortranToFASTParserTest >> testSubroutineWithSeveralStatements [
	| res|
	
	res := self
		parse: '      subroutine hello( fn, ln )
        character*20 n
        integer*4i
        n = fn // ln
        write(*,*) i, ''first='', fn, '', last='', ln, '' and name='', n
      end
'
		as: #Subroutine.
		
	1 halt.

]
