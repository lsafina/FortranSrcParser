Class {
	#name : #PP2FortranToFASTParserBasicTest,
	#superclass : #PP2FortranSrcGrammarTest,
	#category : #'FortranSrc-Tests'
}

{ #category : #running }
PP2FortranToFASTParserBasicTest >> astHaskell: sourceCode [

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
PP2FortranToFASTParserBasicTest >> haskellParserPath [

	"temporal dirty hard-coding"

	^ '/Users/lsafina/.cabal/bin/fortran-src-extras serialize'
	"^ '/Users/lsafina/.cabal/bin/fortran-src' - when we need to receive a haskell-based representation"
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> parse: sourceCode [

	self astHaskell: sourceCode.
	^ FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ])
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> parse: sourceCode as: puMarker [
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
PP2FortranToFASTParserBasicTest >> parse: sourceCode rule: aRule [

	FortranSrcJsonVisitor new visit:
		('fortran77.f.json' asFileReference readStreamDo: [ :str | 
			 NeoJSONReader fromString: str contents ]).
]

{ #category : #accessing }
PP2FortranToFASTParserBasicTest >> setUp [
	
	super setUp.
	parser := self parserInstance
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testBlockData [

	
	result := self
		        parse: '      block data myblck
      common /mycom/ i
      data i /12345/
      end
 '.

	self assert: result equals: FASTFortranStatementBlockData. 
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testCallSubroutine [

	result := self parse: '
      program call_sub
      real :: mat(10, 20)
      mat(:,:) = 0.0
      call print_matrix(10, 20, mat)
      end program call_sub	
 '.

	self assert: result equals: FASTFortranStatementBlockData
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testConditionalBasicIf2 [

	result := self parse: '
      PROGRAM MYPROG
      IF ( X .LT. Y ) THEN 
      M = 0
      ELSE
      M = 0
      I = 1 
      END IF
      END
'.
	"as: #Program."

	self assert: result equals: FASTFortranProgram
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testConditionalMultipleElse [

	result := self parse: '      PROGRAM MYPROG
         IF ( A ) THEN
            I = 1
         else if ( b ) then
            i = 2
            M = 0
         else if ( c ) then
            i = 3         
         ELSE
            I = 4
         END IF
      END
'.
	"as: #Program."

	self assert: result isCollection 
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testConditionalsBasicIf [

	result := self parse: '      PROGRAM MYPROG
      IF ( A ) THEN
      I = 1
      print *, ''Hello, World!''
      END IF
      END
'.
	"as: #Program."

	self assert: result equals: FASTFortranProgram
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testConditionalsBasicIfElse [

	result := self parse: '      PROGRAM MYPROG
      	IF ( L ) THEN 
	   N=N+1
	   CALL CALC 
	   ELSE 
	   K=K+1
	   END IF
'.
	"as: #Program."

	self assert: result equals: FASTFortranProgram
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testDeclaringVariables [

	| mainProgram |
	result := self parse: '
      PROGRAM P
      INTEGER I, IT(10)
      CHARACTER C, CT(10)
      END
 '.

	self assert: result isCollection.
	"TODO meaningful asserts"
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testFullBorbk [

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
PP2FortranToFASTParserBasicTest >> testFunction [

	result := self parse: '      function ifunc( k, l )
      ifunc = k
      end
c --- end ---
'.

	self assert: result class equals: FASTFortranStatementFunction
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testHelloWorld [

	| mainProgram |
	result := self parse: '      program hello
      ! This is a comment line; it is ignored by the compiler
      print *, ''Hello, World!''
      end program hello
 '.

	self assert: result isCollection.
	mainProgram := result first first.
	self assert: mainProgram class equals: FASTFortranMainProgram.
	self assert: mainProgram name equals: 'hello'. 
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testProgramWithMultipleProgUnitsWithInvocation2 [

self
		       parse: '      program myprog
      i = ifunc (i)
      end

      function ifunc( k )
      end
'
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testSubroutine [

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
PP2FortranToFASTParserBasicTest >> testSubroutineWithParameters [

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
PP2FortranToFASTParserBasicTest >> testSubroutineWithSeveralStatements [
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
