object access
numBytesOf: objOop 
	"Answer the number of indexable bytes in the given non-immediate object.
	 Does not adjust the size of contexts by stackPointer."
	<api>
	| fmt numBytes |
	<inline: true>
	<asmLabel: false>
	fmt := self formatOf: objOop.
	numBytes := self numSlotsOf: objOop.
	numBytes := numBytes << self shiftForWord.
	fmt <= self sixtyFourBitIndexableFormat ifTrue:
		[^numBytes].
	fmt >= self firstByteFormat ifTrue: "bytes, including CompiledMethod"
		[^numBytes - (fmt bitAnd: 7)].
	fmt >= self firstShortFormat ifTrue:
		[^numBytes - ((fmt bitAnd: 3) << 1)].
	"fmt >= self firstLongFormat"
	^numBytes - ((fmt bitAnd: 1) << 2)