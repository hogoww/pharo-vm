primitive support
noInlineSigned32BitIntegerFor: integerValue
	"Answer a full 32 bit integer object for the given integer value."
	<notOption: #Spur64BitMemoryManager>
	| newLargeInteger magnitude largeClass numberOfSlots |
	<inline: false>
	<var: 'magnitude' type: 'unsigned int'>
	(objectMemory isIntegerValue: integerValue) ifTrue:
		[^objectMemory integerObjectOf: integerValue].
	self deny: objectMemory hasSixtyFourBitImmediates.

	 integerValue < 0
		ifTrue: [
			largeClass := ClassLargeNegativeIntegerCompactIndex.
				magnitude := 0 asUnsignedInteger - integerValue]
		ifFalse: [largeClass := ClassLargePositiveIntegerCompactIndex.
				magnitude := integerValue].
	numberOfSlots := (integerValue digitLength / objectMemory bytesPerOop) ceiling.
	newLargeInteger := objectMemory
							eeInstantiateSmallClassIndex: largeClass
							format: (objectMemory byteFormatForNumBytes: integerValue digitLength)
							numSlots: numberOfSlots.
	SPURVM
		ifTrue:
			["Memory is 8 byte aligned in Spur, make sure that oversized bytes are set to zero" "eem 4/28/2016 questionable; they should never be read"
			0 to: numberOfSlots - 1 do: [ :index |
				objectMemory
					storeLong32: index
					ofObject: newLargeInteger
					withValue: (objectMemory byteSwapped32IfBigEndian: magnitude >> (index * 32)) ]
			]
		ifFalse: 
			[objectMemory storeLong32: 0 ofObject: newLargeInteger withValue: (objectMemory byteSwapped32IfBigEndian: magnitude)].
	^newLargeInteger
