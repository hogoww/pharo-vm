string primitives
primitiveCompareWith
	"<string1> primitiveCompareWith: string2 [collated: order] "
	<export: true>
	
	| string1 string2 order strLength1 strLength2 result |

	"1 - fetch the parameters from the stack"	
	argumentCount = 1 ifFalse:
		[argumentCount ~= 2 ifTrue:
			[^self primitiveFailFor: PrimErrBadNumArgs].
			 order := self stackTop.
			 ((objectMemory isBytes: order)
			 and: [(objectMemory numBytesOfBytes: order) = 256]) ifFalse:
				[^self primitiveFailFor: PrimErrBadArgument]].
	string1 := self stackValue: argumentCount.
	string2 := self stackValue: argumentCount - 1. 
			
	"2 - check their types - all parameters are ByteObject"
	((objectMemory isBytes: string1)
	 and: [objectMemory isBytes: string2]) ifFalse: 
		[^self primitiveFailFor: PrimErrBadArgument].
	
	"3 - compare the strings"	
	strLength1 := objectMemory numBytesOfBytes: string1.
	strLength2 := objectMemory numBytesOfBytes: string2.
	result := order 
		ifNil: [self rawCompare: string1 length: strLength1 with: string2 length: strLength2 accessBlock:
				[:str :index | objectMemory fetchByte: index ofObject: str ]]
		ifNotNil: 
			[self rawCompare: string1 length: strLength1 with: string2 length: strLength2 accessBlock:
				[:str :index | objectMemory fetchByte: (objectMemory fetchByte: index ofObject: str) + 1 ofObject: order ]].

	self methodReturnInteger: result