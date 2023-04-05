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
	self assert: mainProgram class equals: FASTFortranMainProgram.
	self assert: mainProgram name equals: 'hello'
]
