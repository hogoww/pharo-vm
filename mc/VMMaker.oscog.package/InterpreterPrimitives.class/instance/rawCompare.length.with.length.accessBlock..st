string primitives
rawCompare: string1 length: strLength1 with: string2 length: strLength2 accessBlock: accessBlock
	| c1 c2 min |
	<inline: true> "needs to be forced else slang does not inline it by default"
	min := strLength1 min: strLength2.
	0 to: min-1 do: 
		[:i | c1 := accessBlock value: string1 value: i.
			c2 := accessBlock value: string2 value: i.
			c1 = c2 ifFalse: [^c1 - c2]].
	^strLength1 - strLength2