Class {
	#name : #PP2FortranToFASTParserMiscellaneousTest,
	#superclass : #PP2FortranToFASTParserTestSetUp,
	#category : #'FortranSrc-Tests'
}

{ #category : #tests }
PP2FortranToFASTParserMiscellaneousTest >> testHelloWorld [

	| mainProgram |
	result := self parse: '      
      program hello
      ! This is a comment line; it is ignored by the compiler
      print *, ''Hello, World!''
      end program hello
 '.

	self assert: result isCollection.
	mainProgram := result first first.
	self assert: mainProgram class equals: FASTFortranProgramMain.
	self assert: mainProgram name equals: 'hello'.
]

{ #category : #tests }
PP2FortranToFASTParserMiscellaneousTest >> testMainProgramAndSubroutine [

	| mainProgram |
	result := self parse: '
      PROGRAM TESTALT
       CALL RANK ( N, *8, *9 )
       WRITE (*,*) ''OK - Normal Return [n=0]''
       STOP 
8      WRITE (*,*) ''Minor - 1st alternate return [n=1]'' 
       STOP 8
9      WRITE (*,*) ''Major - 2nd alternate return [n=2]'' 
      END 
      
      SUBROUTINE RANK ( N, *, * ) 
       IF ( N .EQ. 0 ) RETURN 
       IF ( N .EQ. 1 ) RETURN 1
       RETURN 2 
      END
'.

	self assert: result isCollection.
	mainProgram := result first first.
	self assert: mainProgram class equals: FASTFortranProgramMain.
	self assert: mainProgram name equals: 'hello'.
]
