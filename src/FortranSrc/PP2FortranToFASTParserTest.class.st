Class {
	#name : #PP2FortranToFASTParserTest,
	#superclass : #PP2FortranSrcGrammarTest,
	#category : #'FortranSrc-Tests'
}

{ #category : #accessing }
PP2FortranToFASTParserTest >> parserClass [
	^ PP2FortranToFASTParser 
]

{ #category : #accessing }
PP2FortranToFASTParserTest >> setUp [
	
	super setUp.
	parser := self parserInstance
]

{ #category : #test }
PP2FortranToFASTParserTest >> testProgramFile [

	| ast programFile |
	ast := self
		       parse: 'ProgramFile (MetaInfo
	{miVersion = Fortran77,
	miFilename = "emptyFile.f"})
	[]'
		       rule: #programFile.

	self
		assert: (parser model allWithType: FamixFortranProgramFile) size
		equals: 1.
	programFile := (parser model allWithType: FamixFortranProgramFile)
		               first.

	self assert: programFile version equals: 'Fortran77'.

	self assert: programFile filename equals: 'emptyFile.f'.

	self assertEmpty: programFile programUnits
]
