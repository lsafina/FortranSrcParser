Class {
	#name : #PP2FortranToFASTParserBasicTest,
	#superclass : #PP2FortranToFASTParserTestSetUp,
	#category : #'FortranSrc-Tests'
}

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testBlockData [


	| bd |
	
	result := self
		        parse: '      block data myblck
      common /mycom/ i
      end
 '.
	bd := result first first. "unpacking"
	self assert: bd class equals: FASTFortranBlockData.
	self assert: bd name equals: 'myblck'.  
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testCallSubroutine [

	| mainProgram subroutine |
	
	result := self parse: '
      PROGRAM call_sub
       CHARACTER *25 TEXT
       TEXT = ''Some kind of text string'' 
       CALL OOPS ( TEXT )
      END
      SUBROUTINE OOPS ( S )
       CHARACTER S*(*) 
       WRITE (*,*) S 
      END
 '.

	mainProgram := result first first.
	subroutine := result first last.
	
	self assert: mainProgram name equals: 'call_sub'.
	self assert: mainProgram class equals: FASTFortranProgramMain.
	self assert: subroutine name equals: 'oops'.
	self assert: subroutine class equals: FASTFortranSubroutine.
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

	result := self parse: '
      PROGRAM MYPROG
       IF ( A ) THEN
        I = 1
        print *, ''Hello, World!''
       END IF
      END
'.
	
	self assert: result equals: FASTFortranProgramMain.
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
PP2FortranToFASTParserBasicTest >> testDo [

	"The DO statement repeatedly executes a set of statements.
	Syntax: DO s [,] loop-control or DO loop-control @
	where s is a statement number. The form of loop-control is variable = e1, e2 [, e3], 
	variable is of type integer, real, or double precision,
	expressions e_n are of type integer, real or double precision, specifying initial, limit, and increment values respectively"

	result := self parse: '
      program hello	   
        do i=1,10
          print *, i**2
          print *, i**3
        end do
      end program hello
 '.

	self assert: result isCollection
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testDoIncrement [

	"The DO statement repeatedly executes a set of statements.
	Syntax: DO s [,] loop-control or DO loop-control @
	where s is a statement number. The form of loop-control is variable = e1, e2 [, e3], 
	variable is of type integer, real, or double precision,
	expressions e_n are of type integer, real or double precision, specifying initial, limit, and increment values respectively"

	result := self parse: '
      program hello	   
       do i=2,10,2
        write (*,*) i
       end do
      end program hello
 '.

	self assert: result isCollection
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testDoLineNumber [

	"The DO statement repeatedly executes a set of statements.
	Syntax: DO s [,] loop-control or DO loop-control @
	where s is a statement number. The form of loop-control is variable = e1, e2 [, e3], 
	variable is of type integer, real, or double precision,
	expressions e_n are of type integer, real or double precision, specifying initial, limit, and increment values respectively"

	result := self parse: '
      program hello	
      CHARACTER *72 A
       DO 10 i=1,3 
       WRITE (*,82)A
10     CONTINUE
      end program hello
 '.

	self assert: result isCollection
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testDoNested [

	"The DO statement repeatedly executes a set of statements.
	Syntax: DO s [,] loop-control or DO loop-control @
	where s is a statement number. The form of loop-control is variable = e1, e2 [, e3], 
	variable is of type integer, real, or double precision,
	expressions e_n are of type integer, real or double precision, specifying initial, limit, and increment values respectively"

	result := self parse: '
      N = 0 
      DO 210 I = 1, 10 
      J = I 
      DO 200 K = 5, 1 
        L = K
        N = N + 1 
      200 CONTINUE 
      210 CONTINUE 
      WRITE(*,*)''I ='',I, '', J ='',J, '', K ='',K, 
&              '', N ='',N, '', L ='',L
       END
 '.

	self assert: result isCollection
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testFunction [

	result := self parse: '
      function ifunc( k, l )
      ifunc = k
      end
'.

	self assert: result class equals: FASTFortranStatementFunction
]

{ #category : #tests }
PP2FortranToFASTParserBasicTest >> testMainProgram [

	result := self parse: '
      program main
      implicit none
c2345678901234567890123456789012345678901234567890123456789012
      end
 '.
	
	self assert: result isCollection
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
		          parse: '
      subroutine hello()
      write(*,*) "hello"
      end
'.

	self assert: result size equals: 1.
	subrtn := result first.

	"self assert: subrtn class equals: FASTFortranStatementSoubroutine."
	self assert: subrtn name equals: 'hello'
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
	.
		
	1 halt.

]
